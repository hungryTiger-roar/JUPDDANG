package com.jupddang.jupddang.party.dto;

import com.jupddang.jupddang.party.domain.PartyStatus;
import java.time.LocalDateTime;
import java.util.List;

public record PartyDetailResponse(
        Long partyId,
        String inviteCode,
        String name,
        PartyStatus status,
        PartyLeaderInfo leader,
        PartyMembersInfo members,
        LocalDateTime createdAt,
        LocalDateTime startedAt
) {
    /**
     * 방장 정보
     */
    public record PartyLeaderInfo(
            Long userId,
            boolean isCurrentUser  // 현재 요청한 사용자가 방장인지
    ) {}

    /**
     * 참여자 정보
     */
    public record PartyMembersInfo(
            int current,  // 현재 인원
            int max,      // 최대 인원
            List<MemberDto> list  // 참여자 목록
    ) {}

    /**
     * 개별 멤버 정보
     */
    public record MemberDto(
            Long userId,
            boolean isLeader,
            LocalDateTime joinedAt
    ) {}
}