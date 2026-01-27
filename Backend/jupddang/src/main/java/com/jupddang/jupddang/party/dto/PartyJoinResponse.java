package com.jupddang.jupddang.party.dto;

public record PartyJoinResponse(
        Long partyId,
        String partyName,
        boolean isLeader,
        int currentMembers,
        int maxMembers
) {}