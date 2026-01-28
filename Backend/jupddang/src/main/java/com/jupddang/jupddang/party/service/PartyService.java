package com.jupddang.jupddang.party.service;

import com.jupddang.jupddang.party.domain.Party;
import com.jupddang.jupddang.party.domain.PartyMember;
import com.jupddang.jupddang.party.domain.PartyStatus;
import com.jupddang.jupddang.party.domain.PartyActivity;
import com.jupddang.jupddang.party.dto.request.PartyCreateRequest;
import com.jupddang.jupddang.party.dto.request.PartyJoinRequest;
import com.jupddang.jupddang.party.dto.response.ActivityCompleteResponse;
import com.jupddang.jupddang.party.dto.response.PartyActivityStatusResponse;
import com.jupddang.jupddang.party.dto.response.PartyCreateResponse;
import com.jupddang.jupddang.party.dto.response.PartyDetailResponse;
import com.jupddang.jupddang.party.dto.response.PartyJoinResponse;
import com.jupddang.jupddang.party.dto.response.PartyStartResponse;
import com.jupddang.jupddang.party.exception.InviteCodeGenerationException;
import com.jupddang.jupddang.party.repository.PartyActivityRepository;
import com.jupddang.jupddang.party.repository.PartyMemberRepository;
import com.jupddang.jupddang.party.repository.PartyRepository;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.plogging.service.PloggingService;
import com.jupddang.jupddang.sns.entity.Post;
import com.jupddang.jupddang.sns.repository.PostRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.security.SecureRandom;
import java.util.List;

@Service
public class PartyService {

    private final PartyRepository partyRepository;
    private final PartyMemberRepository partyMemberRepository;
    private final PartyActivityRepository partyActivityRepository;
    private final PloggingService ploggingService;
    private final PloggingRepository ploggingRepository;
    private final PostRepository postRepository;

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int CODE_LENGTH = 6;
    private static final int MAX_CODE_VALUE = 1_000_000;
    private static final int MAX_ATTEMPTS = 10;

    public PartyService(PartyRepository partyRepository,
                        PartyMemberRepository partyMemberRepository,
                        PartyActivityRepository partyActivityRepository,
                        PloggingService ploggingService,
                        PloggingRepository ploggingRepository,
                        PostRepository postRepository) {
        this.partyRepository = partyRepository;
        this.partyMemberRepository = partyMemberRepository;
        this.partyActivityRepository = partyActivityRepository;
        this.ploggingService = ploggingService;
        this.ploggingRepository = ploggingRepository;
        this.postRepository = postRepository;
    }

    // 초대 코드 생성
    public String generateUniqueInviteCode() {
        int attempts = 0;

        while (attempts < MAX_ATTEMPTS) {
            String code = generateSixDigitCode();

            if (!partyRepository.existsByInviteCode(code)) {
                return code;
            }

            attempts++;
        }

        throw new InviteCodeGenerationException(
                "초대 코드 생성 실패: 최대 시도 횟수(" + MAX_ATTEMPTS + "회) 초과"
        );
    }

    private String generateSixDigitCode() {
        int code = RANDOM.nextInt(MAX_CODE_VALUE);
        return String.format("%0" + CODE_LENGTH + "d", code);
    }

    // 파티 생성
    @Transactional
    public PartyCreateResponse createParty(PartyCreateRequest request, String userId) {
        String inviteCode = generateUniqueInviteCode();

        // 2. 파티 생성 (방장 설정)
        Party party = new Party(inviteCode, request.name(), userId);
        Party savedParty = partyRepository.save(party);

        // 3. 방장을 자동으로 멤버에 추가
        PartyMember leaderMember = new PartyMember(savedParty, userId);
        partyMemberRepository.save(leaderMember);

        return new PartyCreateResponse(
                savedParty.getId(),
                savedParty.getInviteCode(),
                savedParty.getName(),
                true
        );
    }

    // 파티 참여
    @Transactional
    public PartyJoinResponse joinParty(PartyJoinRequest request, String userId) {
        Party party = partyRepository.findByInviteCode(request.inviteCode())
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 초대 코드입니다."));

        // 2. 파티 상태 확인 (대기 중인 파티만 참여 가능)
        if (party.getStatus() != PartyStatus.WAITING) {
            throw new IllegalStateException("이미 시작되었거나 완료된 파티입니다.");
        }

        // 3. 이미 참여 중인지 확인
        if (partyMemberRepository.existsByPartyIdAndUserId(party.getId(), userId)) {
            throw new IllegalStateException("이미 참여 중인 파티입니다.");
        }

        // 4. 인원 제한 확인
        if (party.isFull()) {
            throw new IllegalStateException(
                    "파티 인원이 가득 찼습니다. (최대 " + party.getMaxMembers() + "명)"
            );
        }

        // 5. 파티에 참여
        PartyMember member = new PartyMember(party, userId);
        partyMemberRepository.save(member);

        // 6. 현재 인원 수 조회
        long currentMembers = partyMemberRepository.countByPartyId(party.getId());

        return new PartyJoinResponse(
                party.getId(),
                party.getName(),
                party.isLeader(userId),
                (int) currentMembers,
                party.getMaxMembers()
        );
    }

    // 파티 상세 조회
    @Transactional(readOnly = true)
    public PartyDetailResponse getPartyDetail(Long partyId, String currentUserId) {
        Party party = partyRepository.findById(partyId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 파티입니다."));

        if (!partyMemberRepository.existsByPartyIdAndUserId(partyId, currentUserId)) {
            throw new IllegalStateException("파티에 참여하지 않은 사용자입니다.");
        }

        List<PartyMember> members = partyMemberRepository.findByPartyId(partyId);

        List<PartyDetailResponse.MemberDto> memberDtos = members.stream()
                .map(m -> new PartyDetailResponse.MemberDto(
                        m.getUserId(),
                        party.isLeader(m.getUserId()),
                        m.getJoinedAt()
                ))
                .sorted((a, b) -> {
                    if (a.isLeader()) return -1;
                    if (b.isLeader()) return 1;
                    return a.joinedAt().compareTo(b.joinedAt());
                })
                .toList();

        return new PartyDetailResponse(
                party.getId(),
                party.getInviteCode(),
                party.getName(),
                party.getStatus(),
                new PartyDetailResponse.PartyLeaderInfo(
                        party.getLeaderId(),
                        party.isLeader(currentUserId)
                ),
                new PartyDetailResponse.PartyMembersInfo(
                        members.size(),
                        party.getMaxMembers(),
                        memberDtos
                ),
                party.getCreatedAt(),
                party.getStartedAt()
        );
    }

    // 파티 시작 (방장 전용)
    @Transactional
    public PartyStartResponse startParty(Long partyId, String userId) {
        Party party = partyRepository.findById(partyId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 파티입니다."));

        party.start(userId);

        List<PartyMember> members = partyMemberRepository.findByPartyId(partyId);

        List<String> startedMemberIds = members.stream()
                .map(member -> {
                    PartyActivity activity = new PartyActivity(partyId, member.getUserId());
                    partyActivityRepository.save(activity);
                    return member.getUserId();
                })
                .toList();

        return new PartyStartResponse(
                party.getId(),
                party.getStatus(),
                party.getStartedAt(),
                startedMemberIds,
                members.size()
        );
    }

    // 실시간 활동 상태 조회
    @Transactional(readOnly = true)
    public PartyActivityStatusResponse getActivityStatus(Long partyId, String userId) {
        Party party = partyRepository.findById(partyId)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 파티입니다."));

        if (!partyMemberRepository.existsByPartyIdAndUserId(partyId, userId)) {
            throw new IllegalStateException("파티에 참여하지 않은 사용자입니다.");
        }

        List<PartyActivity> activities = partyActivityRepository.findByPartyId(partyId);

        List<PartyActivityStatusResponse.MemberActivityStatus> statusList = activities.stream()
                .map(activity -> new PartyActivityStatusResponse.MemberActivityStatus(
                        activity.getUserId(),
                        party.isLeader(activity.getUserId()),
                        activity.getStatus(),
                        activity.getStartedAt(),
                        activity.getEndedAt(),
                        activity.getDistance(),
                        activity.getTrashCount()
                ))
                .toList();

        return new PartyActivityStatusResponse(partyId, statusList);
    }

    /**
     * 개별 활동 완료
     * - 본인의 활동만 완료 처리
     * - PloggingService를 통해 개인 플로깅 생성
     * - Post도 함께 생성됨
     */
    @Transactional
    public ActivityCompleteResponse completeActivity(
            Long partyId, String userId,
            PloggingEndRequest request,
            MultipartFile beforeImage,
            MultipartFile afterImage,
            MultipartFile mapImage
    ) {
        // 1. 활동 조회
        PartyActivity activity = partyActivityRepository
                .findByPartyIdAndUserId(partyId, userId)
                .orElseThrow(() -> new IllegalArgumentException("활동을 찾을 수 없습니다."));

        // 2. 개인 플로깅 생성 (PloggingService 재사용)
        PloggingResultResponse ploggingResult = ploggingService.endPlogging(
                userId, request, beforeImage, afterImage, mapImage
        );

        // 3. Plogging 조회 - ploggingResult에서 ID 가져오기!
        Plogging plogging = ploggingRepository.findById(ploggingResult.ploggingId())
                .orElseThrow(() -> new IllegalArgumentException("플로깅을 찾을 수 없습니다."));

        // 4. Post 조회
        Post post = postRepository.findByPloggingId(plogging.getId())
                .orElseThrow(() -> new IllegalArgumentException("게시물을 찾을 수 없습니다."));

        // 5. PartyActivity 완료 처리
        activity.complete(plogging);

        // 6. 응답 생성
        return new ActivityCompleteResponse(
                activity.getId(),
                activity.getPartyId(),
                activity.getUserId(),
                activity.getStatus(),
                activity.getEndedAt(),
                plogging.getId(),
                plogging.getDistance(),
                plogging.getTimes(),
                post.getPostId(),
                post.getBeforeImageUrl(),
                post.getAfterImageUrl(),
                post.getMapImageUrl()
        );
    }
}