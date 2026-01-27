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
import com.jupddang.jupddang.raid.service.RaidService;
import com.uber.h3core.H3Core;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.Set;

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
    private final RaidService raidService;

    private static final int H3_RESOLUTION = 9;
    private static final long OCCUPY_THRESHOLD_MS = 180 * 1000L; // 3분

    @Override
    @Transactional
    public void processLocation(String userId, LocationRequest request) {
        validateCoordinate(request.getLat(), request.getLon());

        try {
            String currentH3 = h3Core.latLngToCellAddress(request.getLat(), request.getLon(), H3_RESOLUTION);
            long currentTime = System.currentTimeMillis();

            UserPloggingStatus lastStatus = redisRepository.getUserState(userId);

            // CASE A: 새로운 그리드 진입
            if (lastStatus == null || !lastStatus.h3Index().equals(currentH3)) {
                redisRepository.updateUserState(userId, currentH3, currentTime, false);
                return;
            }

            // CASE B: 이미 점령 완료한 그리드
            if (lastStatus.isOccupied()) {
                return;
            }

            // CASE C: 동일 그리드 체류 중 -> 시간 체크
            long timeElapsed = currentTime - lastStatus.entryTime();

            if (timeElapsed >= OCCUPY_THRESHOLD_MS) {
                // 3분 경과 -> 점령 시도
                boolean success = handleOccupationAttempt(userId, currentH3, request.getPartyId());

                if (success) {
                    redisRepository.updateUserState(userId, currentH3, lastStatus.entryTime(), true);
                    // 점령 목록(Captured)에 추가 -> 종료 시 정산용
                    redisRepository.addCapturedGrid(userId, currentH3);
                }
            }

        } catch (Exception e) {
            log.error("Location processing error", e);
            throw new PloggingException(PloggingErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    private boolean handleOccupationAttempt(String userId, String h3Index, Long partyId) {
        LocalDateTime now = LocalDateTime.now();
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

    private void notifyParty(Long partyId, String h3Index, String userId) {
        if (partyId != null) {
            messagingTemplate.convertAndSend("/topic/party/" + partyId,
                    "유저 " + userId + "님이 " + h3Index + " 구역을 점령했습니다!");
        }
    }

    @Override
    @Transactional
    public PloggingResultResponse endPlogging(String userId, PloggingEndRequest request,
                                              MultipartFile before, MultipartFile after, MultipartFile map) {

        Plogging savedPlogging = ploggingRepository.save(Plogging.builder()
                .userId(userId)
                .distance(request.distance())
                .times(request.endTime())
                .build());

        // 2. Redis 점령 목록 조회
        Set<String> capturedGrids = redisRepository.getCapturedGrids(userId);
        int occupiedCount = capturedGrids.size();

        // 3. RaidService 호출 (String userId 전달)
        int totalRaidScore = 0;
        if (!capturedGrids.isEmpty()) {
            totalRaidScore = raidService.applyRaidScore(userId, capturedGrids);
        }

        // 4. 이벤트 발행 (RaidScore 포함)
        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(savedPlogging.getId())
                .userId(userId) // String
                .occupiedGridCnt(occupiedCount)
                .raidScore(totalRaidScore) // [NEW]
                .beforeImage(before).afterImage(after).mapImage(map)
                .build();

        eventPublisher.publishEvent(event);

        // 5. Redis 정리
        redisRepository.deleteUserState(userId);

        log.info("플로깅 종료: userId={}, captured={}, raidScore={}", userId, occupiedCount, totalRaidScore);

        return new PloggingResultResponse(
                "종료되었습니다.",
                request.distance(),
                occupiedCount,
                totalRaidScore
        );
    }

    private void validateCoordinate(Double lat, Double lon) {
        if (lat == null || lon == null || lat < -90 || lat > 90 || lon < -180 || lon > 180) {
            throw new PloggingException(PloggingErrorCode.INVALID_COORDINATE);
        }
    }
}