package com.jupddang.jupddang.party.domain;

public enum PartyStatus {
    WAITING("대기 중"),
    IN_PROGRESS("진행 중"),
    COMPLETED("완료");

    private final String description;

    PartyStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}