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
    private final AccountRepository accountRepository;
    private final ApplicationEventPublisher eventPublisher;
    private final H3Core h3Core;
    private final SimpMessagingTemplate messagingTemplate;
    private final RaidService raidService;
    private final PostRepository postRepository;
    private final GcsImageService gcsImageService;

    // [변경된 로직 1] H3 Resolution 11 (약 25m)
    private static final int H3_RESOLUTION = 11;
    // [변경된 로직 2] 점령 기준 거리 100m
    private static final double OCCUPY_DISTANCE_THRESHOLD = 100.0;

    @Override
    @Transactional
    public void processLocation(String userId, LocationRequest request) {
        validateCoordinate(request.getLat(), request.getLon());

        try {
            String currentH3 = h3Core.latLngToCellAddress(request.getLat(), request.getLon(), H3_RESOLUTION);
            UserPloggingStatus lastStatus = redisRepository.getUserState(userId);
            long currentTime = System.currentTimeMillis();

            // 1. 첫 진입, Redis 만료, 혹은 다른 구역으로 이동한 경우 -> 초기화
            if (lastStatus == null || !lastStatus.h3Index().equals(currentH3)) {

                // 새로운 구역 진입: 거리 0, 현재 위치 저장
                redisRepository.updateUserState(userId, new UserPloggingStatus(
                        currentH3,
                        request.getLat(),
                        request.getLon(),
                        0.0,
                        currentTime,
                        false));
                return;
            }

            // 2. 이미 점령한 구역은 로직 패스 (최적화)
            if (lastStatus.isOccupied()) {
                // 필요 시 마지막 좌표만 갱신하거나, 그냥 빠져나감.
                // 여기서는 좌표 갱신 없이 리턴 (가장 강력한 최적화)
                return;
            }

            // 3. 같은 구역 내 이동 -> 거리 누적
            double dist = calculateDistance(lastStatus.lastLat(), lastStatus.lastLon(), request.getLat(),
                    request.getLon());
            double newTotalDistance = lastStatus.totalDistance() + dist;

            // 4. 거리 기준 도달 체크
            if (newTotalDistance >= OCCUPY_DISTANCE_THRESHOLD) {
                // 점령 시도
                boolean success = handleOccupationAttempt(userId, currentH3, request.getPartyId());

                if (success) {
                    // 점령 성공 상태 저장
                    redisRepository.updateUserState(userId, new UserPloggingStatus(
                            currentH3,
                            request.getLat(),
                            request.getLon(),
                            newTotalDistance,
                            currentTime,
                            true));
                    // 점령 목록에 추가 (정산용)
                    redisRepository.addCapturedGrid(userId, currentH3);
                } else {
                    // 점령 실패 (이미 아군 땅 등) -> 상태만 갱신 (계속 시도하지 않도록 Occupied=True 처리 할 수도 있지만,
                    // 로직상 handleOccupationAttempt가 false면 '점령할 필요 없음'이므로 True로 처리해도 무방하거나,
                    // 혹은 그냥 거리만 업데이트하고 다음 틱에 다시 체크.
                    // 여기서는 '이미 우리땅'도 점령 완료로 취급하여 불필요한 연산 방지
                    redisRepository.updateUserState(userId, new UserPloggingStatus(
                            currentH3,
                            request.getLat(),
                            request.getLon(),
                            newTotalDistance,
                            currentTime,
                            true // 이미 우리 땅이어도 더이상 체크 안 함
                    ));
                }
            } else {
                // 아직 거리 부족 -> 상태 업데이트
                redisRepository.updateUserState(userId, new UserPloggingStatus(
                        currentH3,
                        request.getLat(),
                        request.getLon(),
                        newTotalDistance,
                        currentTime,
                        false));
            }

        } catch (Exception e) {
            log.error("Location processing error", e);
            throw new PloggingException(PloggingErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    // Haversine 공식 (미터 단위)
    private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        double theta = lon1 - lon2;
        double dist = Math.sin(Math.toRadians(lat1)) * Math.sin(Math.toRadians(lat2))
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) * Math.cos(Math.toRadians(theta));

        dist = Math.acos(dist);
        dist = Math.toDegrees(dist);
        dist = dist * 60 * 1.1515;
        dist = dist * 1.609344; // km 단위
        return dist * 1000; // 미터 단위 변환
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

        Account account = accountRepository.getReferenceById(userId);

        log.info("distance : {}", request.distance());
        log.info("content : {}", request.content());

        Set<String> capturedGrids = redisRepository.getCapturedGrids(userId);
        int occupiedCount = capturedGrids.size();

        int ploggingScore = calculatePloggingScore(request.distance(), request.times(), occupiedCount);

        Plogging savedPlogging = ploggingRepository.save(Plogging.builder()
                .account(account)
                .distance(request.distance())
                .times(request.times())
                .score(ploggingScore)
                .build());

        int totalRaidScore = 0;
        if (!capturedGrids.isEmpty()) {
            totalRaidScore = raidService.applyRaidScore(userId, capturedGrids);
        }

        String folder = "plogging/" + userId + "/" + savedPlogging.getId();
        String beforeUrl = gcsImageService.uploadImage(before, folder);
        String afterUrl = gcsImageService.uploadImage(after, folder);
        String mapUrl = gcsImageService.uploadImage(map, folder);

        Post savedPost = postRepository.save(Post.builder()
                .account(account)
                .ploggingId(savedPlogging.getId())
                .beforeImageUrl(beforeUrl)
                .afterImageUrl(afterUrl)
                .mapImageUrl(mapUrl)
                .content(request.content())
                .likeCount(0)
                .build());

        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(savedPlogging.getId())
                .userId(userId)
                .occupiedGridCnt(occupiedCount)
                .raidScore(totalRaidScore)
                .ploggingScore(ploggingScore)
                .build();

        eventPublisher.publishEvent(event);

        redisRepository.deleteUserState(userId);

        log.info("플로깅 종료: userId={}, captured={}, ploggingScore={}, raidScore={}",
                userId, occupiedCount, ploggingScore, totalRaidScore);

        return new PloggingResultResponse(
                savedPlogging.getId(),
                savedPost.getPostId(),
                "종료되었습니다.",
                request.distance(),
                occupiedCount,
                totalRaidScore);
    }

    private int calculatePloggingScore(Double distance, Integer times, int occupiedCount) {
        int distanceScore = (distance != null) ? (int) (distance * 10) : 0;
        int timeScore = (times != null) ? (times / 60) : 0;
        int gridScore = occupiedCount * 5;

        int totalScore = distanceScore + timeScore + gridScore;

        log.debug("점수 계산: distance={}km({}점), times={}초({}점), grids={}개({}점) => 총 {}점",
                distance, distanceScore, times, timeScore, occupiedCount, gridScore, totalScore);

        return totalScore;
    }

    private void validateCoordinate(Double lat, Double lon) {
        if (lat == null || lon == null || lat < -90 || lat > 90 || lon < -180 || lon > 180) {
            throw new PloggingException(PloggingErrorCode.INVALID_COORDINATE);
        }
    }
}