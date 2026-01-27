package com.jupddang.jupddang.party.dto.response;

import com.jupddang.jupddang.party.domain.ActivityStatus;
import java.time.LocalDateTime;
import java.util.List;

public record PartyActivityStatusResponse(
        Long partyId,
        List<MemberActivityStatus> activities
) {

    /**
     * 개별 멤버의 활동 상태
     */
    public record MemberActivityStatus(
            String  userId,
            boolean isLeader,
            ActivityStatus status,
            LocalDateTime startedAt,
            LocalDateTime endedAt,
            Double distance,
            Integer trashCount
    ) {}
}