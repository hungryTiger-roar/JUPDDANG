package com.jupddang.jupddang.plogging.service.impls;

import com.jupddang.jupddang.account.entity.Account; // [Import]
import com.jupddang.jupddang.account.repository.AccountRepository; // [Import]
import com.jupddang.jupddang.plogging.domain.Grids;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.domain.PloggingStatus;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.plogging.dto.UserPloggingStatus;
import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.dto.response.PloggingTempDetailResponse;
import com.jupddang.jupddang.plogging.dto.response.PloggingTempSaveResponse;
import com.jupddang.jupddang.plogging.exception.PloggingErrorCode;
import com.jupddang.jupddang.plogging.exception.PloggingException;
import com.jupddang.jupddang.plogging.repository.GridRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRedisRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.plogging.service.PloggingService;
import com.jupddang.jupddang.party.domain.Party;
import com.jupddang.jupddang.party.domain.PartyStatus;
import com.jupddang.jupddang.party.repository.PartyMemberRepository;
import com.jupddang.jupddang.party.repository.PartyRepository;
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

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
@Slf4j
@RequiredArgsConstructor
public class PloggingServiceImpl implements PloggingService {

    private final PloggingRepository ploggingRepository;
    private final PloggingRedisRepository redisRepository;
    private final PartyRepository partyRepository;
    private final PartyMemberRepository partyMemberRepository;
    private final GridRepository gridRepository;
    private final AccountRepository accountRepository; // [NEW] Account 조회를 위해 추가
    private final ApplicationEventPublisher eventPublisher;
    private final H3Core h3Core;
    private final SimpMessagingTemplate messagingTemplate;
    private final RaidService raidService;
    private final PostRepository postRepository;
    private final GcsImageService gcsImageService;

    private static final int H3_RESOLUTION = 9;
    private static final long OCCUPY_THRESHOLD_MS = 60 * 1000L; // 1분

    @Override
    @Transactional
    public void processLocation(String userId, LocationRequest request) {
        log.info("📥 위치 수신: userId={}, lat={}, lon={}", userId, request.getLat(), request.getLon());
        log.info("📦 요청 데이터: currentH3Index={}, occupyProgress={}",
                request.getCurrentH3Index(), request.getOccupyProgress());

        validateCoordinate(request.getLat(), request.getLon());

        Long partyId = request.getPartyId();
        boolean isLeader = false;

        if (partyId != null) {
            Party party = partyRepository.findById(partyId)
                    .orElseThrow(() -> new PloggingException(PloggingErrorCode.PARTY_NOT_FOUND));

            isLeader = party.getLeaderId().equals(userId);

            log.info("🎯 파티 정보: partyId={}, isLeader={}", partyId, isLeader);

            if (!partyMemberRepository.existsByPartyIdAndUserId(partyId, userId)) {
                throw new PloggingException(PloggingErrorCode.PARTY_MEMBER_NOT_FOUND);
            }

            if (party.getStatus() != PartyStatus.IN_PROGRESS) {
                throw new PloggingException(PloggingErrorCode.PARTY_NOT_IN_PROGRESS);
            }

            // 파티원은 위치만 저장하고 점령 로직 실행 안 함
            if (!isLeader) {
                log.info("👥 파티원 위치 저장");
                processLocationForMember(userId, request);
                return;
            }
        } else {
            if (partyMemberRepository.existsByUserIdAndParty_Status(userId, PartyStatus.IN_PROGRESS)) {
                throw new PloggingException(PloggingErrorCode.PARTY_ACTIVE_BLOCKS_SOLO);
            }
        }

        // 여기서부터는 솔로 플로깅 or 파티장만 실행
        try {
            String currentH3 = h3Core.latLngToCellAddress(request.getLat(), request.getLon(), H3_RESOLUTION);
            long currentTime = System.currentTimeMillis();

            UserPloggingStatus lastStatus = redisRepository.getUserState(userId);

            if (lastStatus == null || !lastStatus.h3Index().equals(currentH3)) {
                log.info("🔄 H3 Index 변경: {} → {}",
                        lastStatus != null ? lastStatus.h3Index() : "null", currentH3);

                redisRepository.updateUserState(userId, currentH3, currentTime, false);

                if (partyId != null && isLeader) {
                    log.info("📡 H3 변경 - 브로드캐스트 호출");
                    broadcastLeaderData(partyId, userId, request);
                }
                return;
            }

            if (lastStatus.isOccupied()) {
                log.info("✅ 이미 점령된 그리드: {}", currentH3);

                if (partyId != null && isLeader) {
                    log.info("📡 점령 완료 - 브로드캐스트 호출");
                    broadcastLeaderData(partyId, userId, request);
                }
                return;
            }

            long timeElapsed = currentTime - lastStatus.entryTime();
            log.info("⏱️ 체류 시간: {}ms / {}ms", timeElapsed, OCCUPY_THRESHOLD_MS);

            if (timeElapsed >= OCCUPY_THRESHOLD_MS) {
                log.info("🎯 점령 시도: {}", currentH3);

                boolean success = handleOccupationAttempt(userId, currentH3, partyId);

                if (success) {
                    redisRepository.updateUserState(userId, currentH3, lastStatus.entryTime(), true);
                    redisRepository.addCapturedGrid(userId, currentH3);

                    if (partyId != null && isLeader) {
                        log.info("📡 점령 성공 - 브로드캐스트 호출");
                        broadcastLeaderData(partyId, userId, request);
                    }
                }
            } else {
                // 🎯 체류 중 - 파티장이면 브로드캐스트
                if (partyId != null && isLeader) {
                    log.info("📡 체류 중 - 브로드캐스트 호출");
                    broadcastLeaderData(partyId, userId, request);
                }
            }

        } catch (PloggingException e) {
            throw e;
        } catch (Exception e) {
            log.error("Location processing error", e);
            throw new PloggingException(PloggingErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    // 파티원은 위치만 업데이트 (점령 로직 제거)
    private void processLocationForMember(String userId, LocationRequest request) {
        try {
            String currentH3 = h3Core.latLngToCellAddress(request.getLat(), request.getLon(), H3_RESOLUTION);
            long currentTime = System.currentTimeMillis();
            UserPloggingStatus lastStatus = redisRepository.getUserState(userId);

            // 위치만 업데이트 (점령 시도 안 함)
            if (lastStatus == null || !lastStatus.h3Index().equals(currentH3)) {
                redisRepository.updateUserState(userId, currentH3, currentTime, false);
            }

        } catch (Exception e) {
            log.error("Member location processing error", e);
        }
    }

    // 파티장 데이터 브로드캐스트 (점령 그리드 + 진행도 포함)
    private void broadcastLeaderData(Long partyId, String userId, LocationRequest request) {
        Set<String> capturedGrids = redisRepository.getCapturedGrids(userId);
        int occupiedCount = capturedGrids.size();

        // 🎯 프론트에서 보낸 데이터를 그대로 사용
        double occupyProgress = request.getOccupyProgress() != null
                ? request.getOccupyProgress()
                : 0.0;

        String currentH3Index = request.getCurrentH3Index() != null
                ? request.getCurrentH3Index()
                : "";

        log.info("📤 브로드캐스트: partyId={}, userId={}, currentH3Index={}, occupyProgress={}",
                partyId, userId, currentH3Index, occupyProgress);

        Map<String, Object> message = Map.of(
                "userId", userId,
                "lat", request.getLat(),
                "lon", request.getLon(),
                "elapsedTime", request.getElapsedTime() != null ? request.getElapsedTime() : 0,
                "totalDistance", request.getTotalDistance() != null ? request.getTotalDistance() : 0.0,
                "score", request.getScore() != null ? request.getScore() : 0,
                "occupiedCount", occupiedCount,
                "occupyProgress", occupyProgress,
                "currentH3Index", currentH3Index,
                "timestamp", System.currentTimeMillis()
        );

        messagingTemplate.convertAndSend("/sub/party/" + partyId + "/leader", message);
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


        log.info("request.partyId(): {}", request.partyId());

        // 파티 플로깅인 경우는 체크 건너뛰기
        boolean isPartyPlogging = request.partyId() != null;

        if (!isPartyPlogging) {
            // 솔로 플로깅인데 파티 활동 중인지 체크
            boolean hasActiveParty = partyMemberRepository.existsByUserIdAndParty_Status(
                    userId, PartyStatus.IN_PROGRESS
            );

            log.info("hasActiveParty: {}", hasActiveParty);

            if (hasActiveParty) {
                throw new PloggingException(PloggingErrorCode.PARTY_ACTIVE_BLOCKS_SOLO);
            }
        }

        // 1. [수정됨] Account 조회 (getReferenceById는 프록시만 가져오므로 성능상 유리함)
        // userId는 이미 String이므로 변환 불필요
        Account account = accountRepository.getReferenceById(userId);

        log.info("distance : {}", request.distance());
//        log.info("times : {}", request.endTime());
        log.info("content : {}", request.content());

        // 2. 점령 그리드 조회 (점수 계산에 필요)
        Set<String> capturedGrids = redisRepository.getCapturedGrids(userId);
        int occupiedCount = capturedGrids.size();

        // 3. 플로깅 점수 계산 (레이드 점수 제외)
        int ploggingScore = calculatePloggingScore(request.distance(), request.times(), occupiedCount);

        // 4. Plogging 저장 (계산된 점수 포함)
        Plogging savedPlogging = ploggingRepository.save(Plogging.builder()
                .account(account)
                .distance(request.distance())
                .times(request.times())
                .recordName(request.recordTitle())
                .status(PloggingStatus.TEMP)
                .score(ploggingScore) // 계산된 플로깅 점수 저장
                .build());

        // 5. 레이드 점수 계산 (별도 처리)
        int totalRaidScore = 0;
        if (!capturedGrids.isEmpty()) {
            totalRaidScore = raidService.applyRaidScore(userId, capturedGrids);
        }

        // 6. GCS에 이미지 업로드
        String folder = "plogging/" + userId + "/" + savedPlogging.getId();
        String beforeUrl = gcsImageService.uploadImage(before, folder);
        String afterUrl = gcsImageService.uploadImage(after, folder);
        String mapUrl = gcsImageService.uploadImage(map, folder);

        // 7. 기록 정보 생성
        String recordInfo = buildRecordInfo(request, ploggingScore);
        log.info("생성된 기록 정보: {}", recordInfo);

        // 8. content에 기록 정보 추가
        String finalContent = request.content();
        if (finalContent == null || finalContent.trim().isEmpty()) {
            // content가 비어있으면 기록 정보만
            finalContent = recordInfo;
        } else {
            // content가 있으면 뒤에 기록 정보 추가
            finalContent = finalContent + "\n\n" + recordInfo;
        }

        log.info("최종 content: {}", finalContent);

        // 9. Post 생성 및 저장 (수정된 content 사용!)
        Post savedPost = postRepository.save(Post.builder()
                .account(account)
                .ploggingId(savedPlogging.getId())
                .beforeImageUrl(beforeUrl)
                .afterImageUrl(afterUrl)
                .mapImageUrl(mapUrl)
                .content(finalContent)  // 기록 정보 포함된 content
                .likeCount(0)
                .build());

        // 9-1 게시글 작성 완료 시 기록 상태 변경
        savedPlogging.markAsUsed();

        // 10. 이벤트 발행 (점수 정산 및 랭킹 업데이트용)
        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(savedPlogging.getId())
                .userId(userId)
                .occupiedGridCnt(occupiedCount)
                .raidScore(totalRaidScore)
                .ploggingScore(ploggingScore) // 플로깅 점수 추가
                .build();

        eventPublisher.publishEvent(event);

        // 11. Redis 정리
        redisRepository.deleteUserState(userId);

        log.info("플로깅 종료: userId={}, captured={}, ploggingScore={}, raidScore={}",
                userId, occupiedCount, ploggingScore, totalRaidScore);

        // 12. 응답 반환
        return new PloggingResultResponse(
                savedPlogging.getId(),
                savedPost.getPostId(),
                "오늘의 플로깅 완료!",
                request.times(),
                request.distance(),
                request.recordTitle(),
                occupiedCount,
                totalRaidScore
        );
    }

    /**
     * 플로깅 점수 계산
     * 공식: score = (distance * 10) + (times / 60) + (occupiedCount * 5)
     * 
     * @param distance      이동 거리 (km)
     * @param times         소요 시간 (초)
     * @param occupiedCount 점령한 그리드 수
     * @return 계산된 플로깅 점수
     */
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
            // [중요] 이 예외가 발생해야 엣지 테스트 통과
            throw new PloggingException(PloggingErrorCode.INVALID_COORDINATE);
        }
    }

    /**
     * 기록 정보 문자열 생성
     * 형식: "기록: 제목 · 날짜 · 거리 · 시간 · 점수"
     */
    private String buildRecordInfo(PloggingEndRequest request, int score) {
        // 시간 포맷 (초 → 분/초)
        int times = request.times();
        String timeStr;
        if (times < 60) {
            timeStr = times + "초";
        } else {
            int minutes = times / 60;
            int seconds = times % 60;
            if (seconds > 0) {
                timeStr = minutes + "분 " + seconds + "초";
            } else {
                timeStr = minutes + "분";
            }
        }

        // 거리 포맷 (m → km, 소수점 1자리)
        String distanceKm = String.format("%.1f", request.distance());

        // 날짜 포맷 (endTime에서 추출)
        // "2024-02-02T10:30:00" → "2024-02-02"
        String dateStr;
        try {
            dateStr = request.endTime()
                    .toLocalDate()
                    .toString();
        } catch (Exception e) {
            // 파싱 실패 시 오늘 날짜 사용
            LocalDate today = LocalDate.now();
            dateStr = today.toString();
        }

        // 기록 제목 (없으면 기본값)
        String recordTitle = request.recordTitle();
        if (recordTitle == null || recordTitle.trim().isEmpty()) {
            recordTitle = "플로깅 활동";
        }

        // 기록 정보 조합 (구분자: ·)
        return String.format("기록: %s · %s · %skm · %s · %d점",
                recordTitle, dateStr, distanceKm, timeStr, score);
    }

    @Transactional
    public PloggingTempSaveResponse savePloggingTemp(
            String userId,
            PloggingEndRequest request,
            MultipartFile before,  // ✅ nullable
            MultipartFile after,   // ✅ nullable
            MultipartFile map) {   // 맵은 필수

        log.info("임시 저장 시작: userId={}", userId);

        // 파티 플로깅 체크
        boolean isPartyPlogging = request.partyId() != null;
        if (!isPartyPlogging) {
            boolean hasActiveParty = partyMemberRepository.existsByUserIdAndParty_Status(
                    userId, PartyStatus.IN_PROGRESS
            );
            if (hasActiveParty) {
                throw new PloggingException(PloggingErrorCode.PARTY_ACTIVE_BLOCKS_SOLO);
            }
        }

        Account account = accountRepository.getReferenceById(userId);

        // 점령 그리드 조회
        Set<String> capturedGrids = redisRepository.getCapturedGrids(userId);
        int occupiedCount = capturedGrids.size();

        // 플로깅 점수 계산
        int ploggingScore = calculatePloggingScore(
                request.distance(),
                request.times(),
                occupiedCount
        );

        // Plogging 저장 (TEMP 상태)
        Plogging savedPlogging = ploggingRepository.save(Plogging.builder()
                .account(account)
                .distance(request.distance())
                .times(request.times())
                .recordName(request.recordTitle())
                .status(PloggingStatus.TEMP)
                .score(ploggingScore)
                .build());

        // 레이드 점수 계산
        int totalRaidScore = 0;
        if (!capturedGrids.isEmpty()) {
            totalRaidScore = raidService.applyRaidScore(userId, capturedGrids);
        }

        // 이미지 업로드 (nullable 처리)
        String folder = "plogging/" + userId + "/" + savedPlogging.getId();

        String beforeUrl = null;
        String afterUrl = null;
        String mapUrl = null;

        // Before 이미지가 있으면 업로드
        if (before != null && !before.isEmpty()) {
            beforeUrl = gcsImageService.uploadImage(before, folder);
            log.info("Before 이미지 업로드 완료: {}", beforeUrl);
        }

        // After 이미지가 있으면 업로드
        if (after != null && !after.isEmpty()) {
            afterUrl = gcsImageService.uploadImage(after, folder);
            log.info("After 이미지 업로드 완료: {}", afterUrl);
        }

        // Map 이미지는 필수 (null 체크)
        if (map != null && !map.isEmpty()) {
            mapUrl = gcsImageService.uploadImage(map, folder);
            log.info("Map 이미지 업로드 완료: {}", mapUrl);
        } else {
            log.warn("Map 이미지가 없습니다. userId={}", userId);
        }

        // 이미지 URL을 Plogging에 저장 (null 가능)
        savedPlogging.updateImageUrls(beforeUrl, afterUrl, mapUrl);

        // 🎯 작성 내용(content)도 저장
        String recordInfo = buildRecordInfo(request, ploggingScore);
        String finalContent = request.content();
        if (finalContent == null || finalContent.trim().isEmpty()) {
            finalContent = recordInfo;
        } else {
            finalContent = finalContent + "\n\n" + recordInfo;
        }
        savedPlogging.updateContent(finalContent);

        // 이벤트 발행 (랭킹 업데이트 등)
        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(savedPlogging.getId())
                .userId(userId)
                .occupiedGridCnt(occupiedCount)
                .raidScore(totalRaidScore)
                .ploggingScore(ploggingScore)
                .build();

        eventPublisher.publishEvent(event);

        // Redis 정리
        redisRepository.deleteUserState(userId);

        log.info("임시 저장 완료: ploggingId={}, score={}, raidScore={}, beforeUrl={}, afterUrl={}, mapUrl={}",
                savedPlogging.getId(), ploggingScore, totalRaidScore, beforeUrl, afterUrl, mapUrl);

        return new PloggingTempSaveResponse(
                savedPlogging.getId(),
                "임시 저장 완료!",
                request.times(),
                request.distance(),
                request.recordTitle(),
                occupiedCount,
                totalRaidScore
        );
    }

    /**
     * 특정 임시 저장 Plogging 상세 조회 (게시글 폼에 채우기 위한 데이터)
     */
    @Transactional(readOnly = true)
    public PloggingTempDetailResponse getTempPloggingDetail(String userId, Long ploggingId) {

        Plogging plogging = ploggingRepository.findById(ploggingId)
                .orElseThrow(() -> new PloggingException(PloggingErrorCode.PLOGGING_NOT_FOUND));

        return new PloggingTempDetailResponse(
                plogging.getId(),
                plogging.getRecordName(),
                plogging.getDistance(),
                plogging.getTimes(),
                plogging.getScore(),
                plogging.getBeforeImageUrl(),
                plogging.getAfterImageUrl(),
                plogging.getMapImageUrl(),
                plogging.getContent(),
                plogging.getCreatedAt()
        );
    }

    /**
     * 사용자의 임시 저장된 Plogging 목록 조회
     */
    @Transactional(readOnly = true)
    public List<PloggingTempDetailResponse> getTempPloggings(String userId) {

        List<Plogging> tempPloggings = ploggingRepository.findByAccountUserIdAndStatusOrderByCreatedAtDesc(
                userId,
                PloggingStatus.TEMP
        );

        return tempPloggings.stream()
                .map(p -> new PloggingTempDetailResponse(
                        p.getId(),
                        p.getRecordName(),
                        p.getDistance(),
                        p.getTimes(),
                        p.getScore(),
                        p.getBeforeImageUrl(),
                        p.getAfterImageUrl(),
                        p.getMapImageUrl(),
                        p.getContent(),
                        p.getCreatedAt()
                ))
                .toList();
    }

}