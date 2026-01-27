package com.jupddang.jupddang.party.dto.response;

import com.jupddang.jupddang.party.domain.PartyStatus;
import java.time.LocalDateTime;
import java.util.List;

public record PartyStartResponse(
        Long partyId,
        PartyStatus status,
        LocalDateTime startedAt,
        List<String > startedMemberIds,  // 활동이 시작된 멤버 ID 목록
        int totalMembers
) {}