package com.jupddang.jupddang.plogging.service.impls;

import com.jupddang.jupddang.account.entity.Account; // [Import]
import com.jupddang.jupddang.account.repository.AccountRepository; // [Import]
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
import com.jupddang.jupddang.sns.entity.Post;
import com.jupddang.jupddang.sns.repository.PostRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;

import java.time.LocalDateTime;
import java.util.Set;

@Service
@Slf4j
@RequiredArgsConstructor
public class PloggingServiceImpl implements PloggingService {

    private final PloggingRepository ploggingRepository;
    private final PloggingRedisRepository redisRepository;
    private final GridRepository gridRepository;
    private final AccountRepository accountRepository; // [NEW] Account 조회를 위해 추가
    private final ApplicationEventPublisher eventPublisher;
    private final H3Core h3Core;
    private final SimpMessagingTemplate messagingTemplate;
    private final RaidService raidService;
    private final PostRepository postRepository;
    private final GcsImageService gcsImageService;

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

            if (lastStatus == null || !lastStatus.h3Index().equals(currentH3)) {
                redisRepository.updateUserState(userId, currentH3, currentTime, false);
                return;
            }

            if (lastStatus.isOccupied()) {
                return;
            }

            long timeElapsed = currentTime - lastStatus.entryTime();

            if (timeElapsed >= OCCUPY_THRESHOLD_MS) {
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

        // 1. [수정됨] Account 조회 (getReferenceById는 프록시만 가져오므로 성능상 유리함)
        // userId는 이미 String이므로 변환 불필요
        Account account = accountRepository.getReferenceById(userId);

        // 2. [수정됨] Plogging 저장 (Account 객체 연결)
        // Plogging 엔티티에 score 필드가 추가되었으므로 초기값을 설정합니다. (여기선 0, 필요시 계산 로직 추가)
        Plogging savedPlogging = ploggingRepository.save(Plogging.builder()
                .account(account)   // [핵심] .userId(Long) -> .account(Account) 변경
                .distance(request.distance())
                .times(request.endTime())
                .score(0)           // score 필드 초기화 (int 기본값)
                .build());

        // 3. Redis 점령 목록 조회
        Set<String> capturedGrids = redisRepository.getCapturedGrids(userId);
        int occupiedCount = capturedGrids.size();

        // 4. RaidService 호출
        int totalRaidScore = 0;
        if (!capturedGrids.isEmpty()) {
            totalRaidScore = raidService.applyRaidScore(userId, capturedGrids);
        }

        // 5. GCS에 이미지 업로드
        String folder = "plogging/" + userId + "/" + savedPlogging.getId();
        String beforeUrl = gcsImageService.uploadImage(before, "plogging/" + userId);
        String afterUrl = gcsImageService.uploadImage(after, "plogging/" + userId);
        String mapUrl = gcsImageService.uploadImage(map, "plogging/" + userId);

        // 6. Post 생성 및 저장
        Post savedPost = postRepository.save(Post.builder()
                .account(account)
                .ploggingId(savedPlogging.getId())
                .beforeImageUrl(beforeUrl)
                .afterImageUrl(afterUrl)
                .mapImageUrl(mapUrl)
                .content("플로깅 완료!")
                .likeCount(0)
                .build());

        // 7. 이벤트 발행 (알림 용도)
        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(savedPlogging.getId())
                .userId(userId)
                .occupiedGridCnt(occupiedCount)
                .raidScore(totalRaidScore)
                .build();

        eventPublisher.publishEvent(event);

        // 8. Redis 정리
        redisRepository.deleteUserState(userId);

        log.info("플로깅 종료: userId={}, captured={}, raidScore={}", userId, occupiedCount, totalRaidScore);

        // 9. 응답 반환
        return new PloggingResultResponse(
                savedPlogging.getId(),
                savedPost.getPostId(),
                "종료되었습니다.",
                request.distance(),
                occupiedCount,
                totalRaidScore
        );
    }

    private void validateCoordinate(Double lat, Double lon) {
        if (lat == null || lon == null || lat < -90 || lat > 90 || lon < -180 || lon > 180) {
            // [중요] 이 예외가 발생해야 엣지 테스트 통과
            throw new PloggingException(PloggingErrorCode.INVALID_COORDINATE);
        }
    }
}