package com.jupddang.jupddang.plogging.service.impls;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
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
    private final AccountRepository accountRepository;
    private final ApplicationEventPublisher eventPublisher;
    private final H3Core h3Core;
    private final SimpMessagingTemplate messagingTemplate;

    private static final int H3_RESOLUTION = 9;
    private static final long OCCUPY_THRESHOLD_MS = 180 * 1000L; // 3분

    @Override
    @Transactional
    // [변경] Long userId -> String userId
    public void processLocation(String userId, LocationRequest request) {
        validateCoordinate(request.getLat(), request.getLon());

        try {
            String currentH3 = h3Core.latLngToCellAddress(request.getLat(), request.getLon(), H3_RESOLUTION);
            long currentTime = System.currentTimeMillis();

            // 1. Redis 상태 조회 (Redis Key도 String이므로 호환됨)
            UserPloggingStatus lastStatus = redisRepository.getUserState(userId);

            // CASE A: 새로운 그리드 진입 (혹은 최초 시작)
            if (lastStatus == null || !lastStatus.h3Index().equals(currentH3)) {
                redisRepository.updateUserState(userId, currentH3, currentTime, false);
                return;
            }

            // CASE B: 이미 점령 완료한 그리드
            if (lastStatus.isOccupied()) {
                return; 
            }

            // CASE C: 점령 시도 (시간 체크)
            long timeElapsed = currentTime - lastStatus.entryTime();

            if (timeElapsed >= OCCUPY_THRESHOLD_MS) {
                // [변경] userId 전달 (String)
                boolean success = handleOccupationAttempt(userId, currentH3, request.getPartyId());

                if (success) {
                    redisRepository.updateUserState(userId, currentH3, lastStatus.entryTime(), true);
                    redisRepository.addCapturedGrid(userId, currentH3);
                }
            }

        } catch (Exception e) {
            log.error("Location processing error", e);
            throw new PloggingException(PloggingErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    // [변경] Long -> String userId
    private boolean handleOccupationAttempt(String userId, String h3Index, Long partyId) {
        LocalDateTime now = LocalDateTime.now();
        
        return gridRepository.findById(h3Index).map(existingGrid -> {
            // Grid 엔티티의 changeOwner 메서드도 파라미터가 String userId여야 함 (확인 필요)
            if (existingGrid.isClaimable(userId, now)) {
                existingGrid.changeOwner(userId, partyId, now);
                log.info("Grid {} ownership taken by {}", h3Index, userId);
                notifyParty(partyId, h3Index, userId);
                return true;
            }
            return false;
        }).orElseGet(() -> {
            // [변경] Grids 생성 시 userId 타입 String으로
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

    // [변경] Long -> String userId
    private void notifyParty(Long partyId, String h3Index, String userId) {
        if (partyId != null) {
            messagingTemplate.convertAndSend("/topic/party/" + partyId,
                    "유저 " + userId + "님이 " + h3Index + " 구역을 점령했습니다!");
        }
    }

    @Override
    @Transactional
    // [변경] Long userId -> String userId
    public PloggingResultResponse endPlogging(String userId, PloggingEndRequest request,
                                              MultipartFile before, MultipartFile after, MultipartFile map) {

        // 1. Account 조회 (String ID이므로 이제 타입 에러 없음)
        Account account = accountRepository.findById(userId)
                .orElseThrow(() -> new PloggingException(PloggingErrorCode.USER_NOT_FOUND));

        // 2. Redis 조회
        int occupiedCount = redisRepository.getCapturedCount(userId);

        // 3. 점수 계산
        int calculatedScore = calculateScore(request.distance(), occupiedCount);

        // [중요] 4. Account 엔티티에 점수 누적 (Account.java에 있는 메서드 활용)
        account.addScore(calculatedScore);

        // 5. 플로깅 기록(로그) 저장
        Plogging savedPlogging = ploggingRepository.save(Plogging.builder()
                .account(account)
                .distance(request.distance())
                .times(request.endTime())
                .score(calculatedScore)
                .build());

        // 6. 이벤트 발행
        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(savedPlogging.getId())
                .userId(userId) // String 그대로 전달
                .occupiedGridCnt(occupiedCount)
                .beforeImage(before).afterImage(after).mapImage(map)
                .build();

        eventPublisher.publishEvent(event);

        // 7. Redis 정리
        redisRepository.deleteUserState(userId);
        
        log.info("플로깅 종료: userId={}, score={}", userId, calculatedScore);

        return new PloggingResultResponse("종료되었습니다.", calculatedScore, occupiedCount);
    }

    private int calculateScore(Double distance, int occupiedCount) {
        if (distance == null) distance = 0.0;
        // 예: 거리(km) * 100점 + 점령한 땅 * 10점
        return (int) (distance * 100) + (occupiedCount * 10);
    }

    private void validateCoordinate(Double lat, Double lon) {
        if (lat == null || lon == null || lat < -90 || lat > 90 || lon < -180 || lon > 180) {
            throw new PloggingException(PloggingErrorCode.INVALID_COORDINATE);
        }
    }
}