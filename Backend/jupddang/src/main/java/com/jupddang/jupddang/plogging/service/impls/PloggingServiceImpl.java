package com.jupddang.jupddang.plogging.service.impls;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository; // [추가] Account 조회를 위해 필요
import com.jupddang.jupddang.plogging.domain.Grids;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.plogging.dto.UserPloggingStatus;
import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.exception.PloggingErrorCode;
import com.jupddang.jupddang.plogging.exception.PloggingException;
import com.jupddang.jupddang.plogging.repository.GridRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRedisRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.plogging.service.PloggingService;
import com.uber.h3core.H3Core;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;

@Service
@Slf4j
@RequiredArgsConstructor
public class PloggingServiceImpl implements PloggingService {

    private final PloggingRepository ploggingRepository;
    private final PloggingRedisRepository redisRepository;
    private final GridRepository gridRepository;
    private final AccountRepository accountRepository; // [추가] 유저 객체 조회용
    private final ApplicationEventPublisher eventPublisher;
    private final H3Core h3Core;
    private final SimpMessagingTemplate messagingTemplate;

    private static final int H3_RESOLUTION = 9;
    private static final long OCCUPY_THRESHOLD_MS = 180 * 1000L; // 3분

    @Override
    @Transactional
    public void processLocation(Long userId, LocationRequest request) {
        validateCoordinate(request.getLat(), request.getLon());

        try {
            String currentH3 = h3Core.latLngToCellAddress(request.getLat(), request.getLon(), H3_RESOLUTION);
            long currentTime = System.currentTimeMillis();

            // 1. Redis 상태 조회
            UserPloggingStatus lastStatus = redisRepository.getUserState(userId);

            // CASE A: 새로운 그리드 진입 (혹은 최초 시작)
            if (lastStatus == null || !lastStatus.h3Index().equals(currentH3)) {
                redisRepository.updateUserState(userId, currentH3, currentTime, false);
                return;
            }

            // CASE B: 이미 점령 완료한 그리드에 계속 머무는 중
            if (lastStatus.isOccupied()) {
                return; 
            }

            // CASE C: 동일 그리드 체류 중 + 아직 점령 안함 -> 시간 체크
            long timeElapsed = currentTime - lastStatus.entryTime();

            if (timeElapsed >= OCCUPY_THRESHOLD_MS) {
                // 3분이 지남 -> 실제 DB 조회하여 점령 시도
                boolean success = handleOccupationAttempt(userId, currentH3, request.getPartyId());

                if (success) {
                    // 1) 상태 업데이트: occupied=true
                    redisRepository.updateUserState(userId, currentH3, lastStatus.entryTime(), true);
                    // 2) 이번 세션 점령 목록에 추가
                    redisRepository.addCapturedGrid(userId, currentH3);
                }
            }

        } catch (Exception e) {
            log.error("Location processing error", e);
            throw new PloggingException(PloggingErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    private boolean handleOccupationAttempt(Long userId, String h3Index, Long partyId) {
        LocalDateTime now = LocalDateTime.now();
        // Grids 엔티티가 아직 userId(Long)를 사용하는지, Account를 사용하는지에 따라 수정 필요할 수 있음.
        // 현재는 기존 코드(Long userId)를 유지합니다.
        return gridRepository.findById(h3Index).map(existingGrid -> {
            if (existingGrid.isClaimable(userId, now)) {
                existingGrid.changeOwner(userId, partyId, now);
                log.info("Grid {} ownership taken by {}", h3Index, userId);
                notifyParty(partyId, h3Index, userId);
                return true;
            }
            return false;
        }).orElseGet(() -> {
            Grids newGrid = Grids.builder()
                    .id(h3Index)
                    .userId(userId)
                    .partyId(partyId)
                    .occupiedAt(now)
                    .build();
            gridRepository.save(newGrid);
            log.info("Grid {} created by {}", h3Index, userId);
            notifyParty(partyId, h3Index, userId);
            return true;
        });
    }

    private void notifyParty(Long partyId, String h3Index, Long userId) {
        if (partyId != null) {
            messagingTemplate.convertAndSend("/topic/party/" + partyId,
                    "유저 " + userId + "님이 " + h3Index + " 구역을 점령했습니다!");
        }
    }

    @Override
    @Transactional
    public PloggingResultResponse endPlogging(Long userId, PloggingEndRequest request,
                                              MultipartFile before, MultipartFile after, MultipartFile map) {

        // 1. [변경] Account 엔티티 조회 (Entity 연관관계를 위해 필수)
        Account account = accountRepository.findById(userId)
                .orElseThrow(() -> new PloggingException(PloggingErrorCode.USER_NOT_FOUND));

        // 2. Redis에서 이번 세션 점령 개수 조회
        int occupiedCount = redisRepository.getCapturedCount(userId);
        
        // 3. [추가] 점수 계산 로직 (거리 + 점령 수 등 기획에 맞춰 계산)
        int calculatedScore = calculateScore(request.distance(), occupiedCount);

        // 4. [변경] 플로깅 기록 저장 (userId -> account, score 추가)
        Plogging savedPlogging = ploggingRepository.save(Plogging.builder()
                .account(account)             // [수정] 객체 매핑
                .distance(request.distance())
                .times(request.endTime())
                .score(calculatedScore)       // [추가] 필수 필드
                .build());

        // 5. 이벤트 발행
        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(savedPlogging.getId())
                .userId(String.valueOf(userId))
                .occupiedGridCnt(occupiedCount)
                .beforeImage(before).afterImage(after).mapImage(map)
                .build();

        eventPublisher.publishEvent(event);

        // 6. Redis 상태 정리
        redisRepository.deleteUserState(userId);
        log.info("플로깅 종료: userId={}, occupied={}, score={}", userId, occupiedCount, calculatedScore);

        return new PloggingResultResponse("종료되었습니다.", calculatedScore, occupiedCount);
    }

    /**
     * [추가] 간단한 점수 계산 로직
     * 예시: (거리 km * 100) + (점령 땅 * 10)
     */
    private int calculateScore(Double distance, int occupiedCount) {
        if (distance == null) distance = 0.0;
        return (int) (distance * 100) + (occupiedCount * 10);
    }

    private void validateCoordinate(Double lat, Double lon) {
        if (lat == null || lon == null || lat < -90 || lat > 90 || lon < -180 || lon > 180) {
            throw new PloggingException(PloggingErrorCode.INVALID_COORDINATE);
        }
    }
}