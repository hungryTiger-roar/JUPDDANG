package com.jupddang.jupddang.plogging.service.impls;

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
                // [FIX] 객체(new UserPloggingStatus)가 아니라 개별 인자로 전달
                redisRepository.updateUserState(userId, currentH3, currentTime, false);
                return;
            }

            // CASE B: 이미 점령 완료한 그리드에 계속 머무는 중
            if (lastStatus.isOccupied()) {
                return; // DB 부하 방지
            }

            // CASE C: 동일 그리드 체류 중 + 아직 점령 안함 -> 시간 체크
            long timeElapsed = currentTime - lastStatus.entryTime();

            if (timeElapsed >= OCCUPY_THRESHOLD_MS) {
                // 3분이 지남 -> 실제 DB 조회하여 점령 시도 (보호막 체크 포함)
                boolean success = handleOccupationAttempt(userId, currentH3, request.getPartyId());

                if (success) {
                    // 1) 상태 업데이트: occupied=true (중복 DB 접근 차단)
                    // [FIX] 여기서도 개별 인자로 전달해야 합니다.
                    redisRepository.updateUserState(userId, currentH3, lastStatus.entryTime(), true);

                    // 2) [Account Logic] 이번 세션 점령 목록에 추가 (카운팅용)
                    redisRepository.addCapturedGrid(userId, currentH3);
                } else {
                    // 점령 실패 (보호막 등). 재시도 여부는 기획에 따라 결정.
                    // 현재는 상태 유지 (다음 좌표 수신 시 다시 체크)
                }
            }

        } catch (Exception e) {
            log.error("Location processing error", e);
            throw new PloggingException(PloggingErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    private boolean handleOccupationAttempt(Long userId, String h3Index, Long partyId) {
        LocalDateTime now = LocalDateTime.now();
        return gridRepository.findById(h3Index).map(existingGrid -> {
            // 1. 이미 존재하는 땅 -> 보호막 체크
            if (existingGrid.isClaimable(userId, now)) {
                existingGrid.changeOwner(userId, partyId, now);
                log.info("Grid {} ownership taken by {}", h3Index, userId);
                notifyParty(partyId, h3Index, userId);
                return true;
            }
            return false;
        }).orElseGet(() -> {
            // 2. 빈 땅 -> 즉시 점령
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

        // 1. 플로깅 기록 저장
        Plogging savedPlogging = ploggingRepository.save(Plogging.builder()
                .userId(userId)
                .distance(request.distance())
                .times(request.endTime())
                .build());

        // 2. [Account Logic] Redis에서 이번 세션 점령 개수 조회
        int occupiedCount = redisRepository.getCapturedCount(userId);

        // 3. 이벤트 발행 (점수 계산 및 Account 반영 위임)
        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(savedPlogging.getId())
                .userId(String.valueOf(userId))
                // Listener가 DB(Plogging)를 조회하여 distance/times를 가져가므로 여기선 ID와 Count가 중요
                .occupiedGridCnt(occupiedCount)
                .beforeImage(before).afterImage(after).mapImage(map)
                .build();

        eventPublisher.publishEvent(event);

        // 4. Redis 상태 정리 (필수)
        redisRepository.deleteUserState(userId);
        log.info("플로깅 종료: userId={}, occupied={}", userId, occupiedCount);

        return new PloggingResultResponse("종료되었습니다.", 0, occupiedCount);
    }

    private void validateCoordinate(Double lat, Double lon) {
        if (lat == null || lon == null || lat < -90 || lat > 90 || lon < -180 || lon > 180) {
            throw new PloggingException(PloggingErrorCode.INVALID_COORDINATE);
        }
    }
}