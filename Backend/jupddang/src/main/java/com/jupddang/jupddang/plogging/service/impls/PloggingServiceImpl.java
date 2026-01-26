package com.jupddang.jupddang.plogging.service.impls;

import com.jupddang.jupddang.plogging.domain.Grids;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.plogging.dto.UserPloggingStatus;
import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
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

@Service
@Slf4j
@RequiredArgsConstructor
public class PloggingServiceImpl implements PloggingService {

    private final PloggingRepository ploggingRepository;
    private final PloggingRedisRepository redisRepository;
    private final ApplicationEventPublisher eventPublisher;
    private final GridRepository gridRepository;

    private final H3Core h3Core;
    private final SimpMessagingTemplate messagingTemplate;

    private static final int H3_RESOLUTION = 9; // 헥사곤 크기 (약 골목길 단위)
    private static final long OCCUPY_THRESHOLD_MS = 180 * 1000L; // 3분

    // --- 1. 실시간 위치 처리 로직 (WebSocket) ---
    @Override
    @Transactional
    public void processLocation(Long userId, LocationRequest request) {
        // A. H3 변환
        String currentH3 = h3Core.latLngToCellAddress(request.getLat(), request.getLon(), H3_RESOLUTION);
        long currentTime = System.currentTimeMillis();

        // B. Redis 상태 조회
        UserPloggingStatus lastStatus = redisRepository.getUserState(userId);

        // C. 새로운 땅 진입 or 첫 시작 (Record getter 문법 적용: .h3Index())
        if (lastStatus == null || !lastStatus.h3Index().equals(currentH3)) {
            redisRepository.updateUserState(userId, currentH3, currentTime);
            log.info("User {} moved to {}", userId, currentH3);
            return;
        }

        // D. 같은 땅 머무름 -> 시간 계산 (Record getter 문법 적용: .entryTime())
        long timeElapsed = currentTime - lastStatus.entryTime();

        // E. 3분 초과 시 점령 처리
        if (timeElapsed >= OCCUPY_THRESHOLD_MS) {
            handleOccupation(userId, currentH3, request.getPartyId());

            // 중복 점령 방지: 시간을 현재로 갱신하여 다시 0초부터 카운트 (또는 '이미 점령함' 상태 관리 필요)
            redisRepository.updateUserState(userId, currentH3, currentTime);
        }
    }

    private void handleOccupation(Long userId, String h3Index, Long partyId) {
        // 1. 이미 누군가 점령한 땅인지 확인 (findById = PK 조회)
        gridRepository.findById(h3Index).ifPresentOrElse(
                // A. 이미 주인이 있는 경우 -> 주인 변경 (땅 뺏기)
                existingGrid -> {
                    log.info("Grid {} ownership changed from {} to {}", h3Index, existingGrid.getUserId(), userId);
                    existingGrid.changeOwner(userId, partyId);
                    // JPA 변경 감지(Dirty Checking)로 인해 트랜잭션 종료 시 자동 update 쿼리 나감
                },
                // B. 주인이 없는 경우 -> 새로 생성 (Insert)
                () -> {
                    Grids newGrid = Grids.builder()
                            .id(h3Index) // PK에 H3 인덱스 넣기
                            .userId(userId)
                            .partyId(partyId)
                            .build();
                    gridRepository.save(newGrid);
                }
        );

        // 2. 알림 전송 (동일)
        if (partyId != null) {
            messagingTemplate.convertAndSend("/topic/party/" + partyId,
                    "유저 " + userId + "님이 " + h3Index + " 구역을 점령했습니다!");
        }
    }

    // --- 2. 종료 로직 (REST API) ---
    @Override
    @Transactional
    public PloggingResultResponse endPlogging(
            Long userId,
            PloggingEndRequest request,
            MultipartFile beforeImage,
            MultipartFile afterImage,
            MultipartFile mapImage) {

        log.info("플로깅 종료 요청 - userId: {}", userId);

        // A. MySQL 저장
        Plogging plogging = Plogging.builder()
                .userId(userId)
                .distance(request.distance())
                .times(request.endTime())
                .build();

        Plogging savedPlogging = ploggingRepository.save(plogging);

        // [TODO] 실제 점령한 땅 개수 계산 로직 필요 (DB에서 count 하거나 별도 로직)
        int occupiedCount = 0;
        // occupiedCount = landRepository.countByPloggingId(savedPlogging.getId());

        // B. 이벤트 발행
        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(savedPlogging.getId())
                .userId(String.valueOf(userId))
                .beforeImage(beforeImage)
                .afterImage(afterImage)
                .mapImage(mapImage)
                .occupiedGridCnt(occupiedCount)
                .build();
        eventPublisher.publishEvent(event);

        // C. [중요] Redis 상태 정리 (Clean Up)
        redisRepository.deleteUserState(userId);
        log.info("Redis 유저 상태 삭제 완료 - userId: {}", userId);

        return new PloggingResultResponse(
                "플로깅이 종료되었습니다.",
                100, // score 예시
                occupiedCount
        );
    }
}