package com.jupddang.jupddang.plogging.service.impls;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.fcm.FcmService;
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
import com.jupddang.jupddang.party.dto.response.PartyMemberLocationResponse;
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
    private final AccountRepository accountRepository;
    private final ApplicationEventPublisher eventPublisher;
    private final H3Core h3Core;
    private final SimpMessagingTemplate messagingTemplate;
    private final RaidService raidService;
    private final PostRepository postRepository;
    private final GcsImageService gcsImageService;
    private final FcmService fcmService;

    // [변경된 로직 1] H3 Resolution 9
    private static final int H3_RESOLUTION = 9;
    // [변경된 로직 2] 점령 기준 거리 100m
    private static final double OCCUPY_DISTANCE_THRESHOLD = 100.0;

    @Override
    @Transactional
    public void processLocation(String userId, LocationRequest request) {

        log.info("📥 위치 수신: userId={}, lat={}, lon={}", userId, request.getLat(), request.getLon());
        log.info("📦 요청 데이터: currentH3Index={}, occupyProgress={}",
                request.getCurrentH3Index(), request.getOccupyProgress());

        validateCoordinate(request.getLat(), request.getLon());

        // 🎯 [NEW] 프론트엔드에서 100% 점령 완료 신호가 오면 즉시 점령 처리
        if (request.getOccupyProgress() != null && request.getOccupyProgress() >= 1.0 
                && request.getCurrentH3Index() != null && !request.getCurrentH3Index().isEmpty()) {
            log.info("🎯 프론트 점령 완료 감지: userId={}, h3Index={}", userId, request.getCurrentH3Index());
            boolean success = handleOccupationAttempt(userId, request.getCurrentH3Index(), request.getPartyId());
            if (success) {
                redisRepository.addCapturedGrid(userId, request.getCurrentH3Index());
                log.info("✅ 프론트 기반 점령 성공: {}", request.getCurrentH3Index());
            }
            // 점령 처리 후에도 나머지 로직 계속 실행 (위치 업데이트 등)
        }

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
            // 1. H3 Index 변환 (안전장치 추가)
            String currentH3;
            try {
                currentH3 = h3Core.latLngToCellAddress(request.getLat(), request.getLon(), H3_RESOLUTION);
            } catch (Exception e) {
                log.warn("H3 Index 변환 실패 (좌표: {}, {}): {}", request.getLat(), request.getLon(), e.getMessage());
                // 변환 실패 시 로직 중단하고 리턴 (서버 에러 아님)
                return;
            }

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

            // [추가] 파티원들에게 내 위치 전송 (Broadcasting)
            if (partyId != null) {
                broadcastLocation(partyId, userId, request, newTotalDistance);
            }

        } catch (PloggingException e) {
            throw e;
        } catch (Exception e) {
            log.error("Location processing error", e);
            throw new PloggingException(PloggingErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 파티원 위치 처리 (점령 로직 없음, 위치만 저장)
     */
    private void processLocationForMember(String userId, LocationRequest request) {
        try {
            String currentH3 = h3Core.latLngToCellAddress(
                    request.getLat(),
                    request.getLon(),
                    H3_RESOLUTION);

            long currentTime = System.currentTimeMillis();
            UserPloggingStatus lastStatus = redisRepository.getUserState(userId);

            // 거리 계산
            double dist = 0.0;
            if (lastStatus != null) {
                dist = calculateDistance(
                        lastStatus.lastLat(),
                        lastStatus.lastLon(),
                        request.getLat(),
                        request.getLon());
            }

            double newTotalDistance = (lastStatus != null ? lastStatus.totalDistance() : 0.0) + dist;

            // 🎯 파티원은 점령 없이 위치만 저장
            redisRepository.updateUserState(userId, new UserPloggingStatus(
                    currentH3,
                    request.getLat(),
                    request.getLon(),
                    newTotalDistance,
                    currentTime,
                    false // 파티원은 점령 안 함
            ));

            // [추가] 파티원들에게 내 위치 전송 (Broadcasting)
            if (request.getPartyId() != null) {
                broadcastLocation(request.getPartyId(), userId, request, newTotalDistance);
            }

            log.info("👥 파티원 위치 업데이트: userId={}, h3={}, distance={}",
                    userId, currentH3, newTotalDistance);

        } catch (Exception e) {
            log.error("파티원 위치 처리 실패: userId={}", userId, e);
            throw new PloggingException(PloggingErrorCode.LOCATION_PROCESSING_ERROR);
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

    private void broadcastLocation(Long partyId, String userId, LocationRequest request, double totalDistance) {
        try {
            int occupiedCount = redisRepository.getCapturedCount(userId);

            PartyMemberLocationResponse response = PartyMemberLocationResponse.builder()
                    .userId(userId)
                    .lat(request.getLat())
                    .lon(request.getLon())
                    .totalDistance(totalDistance)
                    .elapsedTime(request.getElapsedTime())
                    .occupiedCount(occupiedCount)
                    .occupyProgress(request.getOccupyProgress())
                    .currentH3Index(request.getCurrentH3Index())
                    .build();

            messagingTemplate.convertAndSend("/sub/party/" + partyId + "/locations", response);
            // log.debug("📡 파티 위치 전송: partyId={}, userId={}", partyId, userId);
        } catch (Exception e) {
            log.error("위치 브로드캐스팅 실패: partyId={}, userId={}", partyId, userId, e);
        }
    }

    @Override
    @Transactional
    public PloggingResultResponse endPlogging(String userId, PloggingEndRequest request,
            MultipartFile before, MultipartFile after, MultipartFile map) {

        Account account = accountRepository.getReferenceById(userId);

        log.info("distance : {}", request.distance());
        log.info("content : {}", request.content());

        // Redis에서 점령 그리드 조회
        Set<String> capturedGrids = redisRepository.getCapturedGrids(userId);
        
        // 🎯 [NEW] 프론트에서 보낸 점령 목록과 병합 (누락 방지)
        if (request.capturedGrids() != null && !request.capturedGrids().isEmpty()) {
            log.info("📦 프론트에서 받은 점령 그리드: {}", request.capturedGrids());
            capturedGrids.addAll(request.capturedGrids());
            
            // 프론트에서 받은 그리드들을 DB에 저장 (아직 없으면)
            for (String h3Index : request.capturedGrids()) {
                handleOccupationAttempt(userId, h3Index, request.partyId());
            }
        }
        
        int occupiedCount = capturedGrids.size();
        log.info("🎯 총 점령 그리드 수: {}", occupiedCount);

        int ploggingScore = calculatePloggingScore(request.distance(), request.times(), occupiedCount);

        Plogging savedPlogging = ploggingRepository.save(Plogging.builder()
                .account(account)
                .distance(request.distance())
                .times(request.times())
                .score(ploggingScore)
                .recordName(request.recordTitle())
                .build());

        int totalRaidScore = 0;
        if (!capturedGrids.isEmpty()) {
            totalRaidScore = raidService.applyRaidScore(userId, capturedGrids);
        }

        String folder = "plogging/" + userId + "/" + savedPlogging.getId();
        String beforeUrl = gcsImageService.uploadImage(before, folder);
        String afterUrl = gcsImageService.uploadImage(after, folder);
        String mapUrl = gcsImageService.uploadImage(map, folder);

        // 🎯 작성 내용(content)도 저장
        String recordInfo = buildRecordInfo(request, ploggingScore);
        String finalContent = request.content();
        if (finalContent == null || finalContent.trim().isEmpty()) {
            finalContent = recordInfo;
        } else {
            finalContent = finalContent + "\n\n" + recordInfo;
        }

        Post savedPost = postRepository.save(Post.builder()
                .account(account)
                .ploggingId(savedPlogging.getId())
                .beforeImageUrl(beforeUrl)
                .afterImageUrl(afterUrl)
                .mapImageUrl(mapUrl)
                .content(finalContent) // 기록 정보 포함된 content
                .likeCount(0)
                .build());

        // 게시글 작성 성공 이후 플로깅 기록 상태 변경
        savedPlogging.markAsUsed();

        try {
            fcmService.sendPloggingCompletedNotification(
                    userId,
                    request.recordTitle(),
                    request.distance(),
                    request.times(),
                    ploggingScore,
                    LocalDateTime.now());
            log.info("플로깅 완료 알림 전송 성공: userId={}", userId);
        } catch (Exception e) {
            log.error("플로깅 완료 알림 전송 실패: userId={}, error={}", userId, e.getMessage());
            // 알림 실패해도 플로깅 완료 처리는 계속 진행
        }

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
                "오늘의 플로깅 완료!",
                request.times(),
                request.distance(),
                request.recordTitle(),
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
            // throw new PloggingException(PloggingErrorCode.INVALID_COORDINATE);
            log.warn("⚠️ 이상한 좌표 감지 (무시함): lat={}, lon={}", lat, lon);
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
            MultipartFile before, //
            MultipartFile after, //
            MultipartFile map) { // 맵은 필수

        log.info("임시 저장 시작: userId={}", userId);

        // 파티 플로깅 체크
        boolean isPartyPlogging = request.partyId() != null;
        if (!isPartyPlogging) {
            boolean hasActiveParty = partyMemberRepository.existsByUserIdAndParty_Status(
                    userId, PartyStatus.IN_PROGRESS);
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
                occupiedCount);

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
                totalRaidScore);
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
                plogging.getCreatedAt());
    }

    /**
     * 사용자의 임시 저장된 Plogging 목록 조회
     */
    @Transactional(readOnly = true)
    public List<PloggingTempDetailResponse> getTempPloggings(String userId) {

        List<Plogging> tempPloggings = ploggingRepository.findByAccountUserIdAndStatusOrderByCreatedAtDesc(
                userId,
                PloggingStatus.TEMP);

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
                        p.getCreatedAt()))
                .toList();
    }

}