package com.jupddang.jupddang.party.service;

import com.jupddang.jupddang.party.domain.Party;
import com.jupddang.jupddang.party.domain.PartyMember;
import com.jupddang.jupddang.party.domain.PartyStatus;
import com.jupddang.jupddang.party.dto.PartyCreateRequest;
import com.jupddang.jupddang.party.dto.PartyCreateResponse;
import com.jupddang.jupddang.party.dto.PartyDetailResponse;
import com.jupddang.jupddang.party.dto.PartyJoinRequest;
import com.jupddang.jupddang.party.dto.PartyJoinResponse;
import com.jupddang.jupddang.party.exception.InviteCodeGenerationException;
import com.jupddang.jupddang.party.repository.PartyMemberRepository;
import com.jupddang.jupddang.party.repository.PartyRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.util.List;

@Service
public class PartyService {

    private final PartyRepository partyRepository;
    private final PartyMemberRepository partyMemberRepository;
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int CODE_LENGTH = 6;
    private static final int MAX_CODE_VALUE = 1_000_000;
    private static final int MAX_ATTEMPTS = 10;

    public PartyService(PartyRepository partyRepository,
                        PartyMemberRepository partyMemberRepository) {
        this.partyRepository = partyRepository;
        this.partyMemberRepository = partyMemberRepository;
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
    public PartyCreateResponse createParty(PartyCreateRequest request, Long userId) {
        // 1. 초대 코드 생성 (기존 메서드 재사용)
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
    public PartyJoinResponse joinParty(PartyJoinRequest request, Long userId) {
        // 1. 초대 코드로 파티 찾기
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

    // 파티 상세 조회 (새로 추가)
    @Transactional(readOnly = true)
    public PartyDetailResponse getPartyDetail(Long partyId, Long currentUserId) {
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
}