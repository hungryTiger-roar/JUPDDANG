package com.jupddang.jupddang.party.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "party_activity")
public class PartyActivity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "party_id", nullable = false)
    private Long partyId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private ActivityStatus status = ActivityStatus.IN_PROGRESS;

    @Column(name = "started_at", nullable = false)
    private LocalDateTime startedAt;

    @Column(name = "ended_at")
    private LocalDateTime endedAt;

    @Column(name = "distance")
    private Double distance;  // 이동 거리 (km)

    @Column(name = "trash_count")
    private Integer trashCount;  // 수거한 쓰레기 개수

    // JPA 기본 생성자
    protected PartyActivity() {
    }

    // 비즈니스 생성자
    public PartyActivity(Long partyId, Long userId) {
        this.partyId = partyId;
        this.userId = userId;
        this.status = ActivityStatus.IN_PROGRESS;
        this.startedAt = LocalDateTime.now();
    }

    // 비즈니스 메서드 - 활동 완료
    public void complete(Double distance, Integer trashCount) {
        this.status = ActivityStatus.COMPLETED;
        this.endedAt = LocalDateTime.now();
        this.distance = distance;
        this.trashCount = trashCount;
    }

    // Getters
    public Long getId() {
        return id;
    }

    public Long getPartyId() {
        return partyId;
    }

    public Long getUserId() {
        return userId;
    }

    public ActivityStatus getStatus() {
        return status;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public LocalDateTime getEndedAt() {
        return endedAt;
    }

    public Double getDistance() {
        return distance;
    }

    public Integer getTrashCount() {
        return trashCount;
    }
}