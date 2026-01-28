package com.jupddang.jupddang.party.domain;

public enum ActivityStatus {
    IN_PROGRESS("진행 중"),
    COMPLETED("완료"),
    ABANDONED("포기");

    private final String description;

    ActivityStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}