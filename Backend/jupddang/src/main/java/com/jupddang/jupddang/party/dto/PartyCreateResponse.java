package com.jupddang.jupddang.party.dto;

public record PartyCreateResponse(
        Long partyId,
        String inviteCode,
        String name,
        boolean isLeader
) {}