package com.jupddang.jupddang.party.dto.response;

public record PartyCreateResponse(
        Long partyId,
        String inviteCode,
        String name,
        boolean isLeader
) {}