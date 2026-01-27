package com.jupddang.jupddang.party.domain;

import com.jupddang.jupddang.plogging.domain.Plogging;
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

    @Column(name = "user_id", nullable = false, length = 50)
    private String userId;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private ActivityStatus status = ActivityStatus.IN_PROGRESS;

    @Column(name = "started_at", nullable = false)
    private LocalDateTime startedAt;

    @Column(name = "ended_at")
    private LocalDateTime endedAt;

    @Column(name = "distance")
    private Double distance;

    @Column(name = "trash_count")
    private Integer trashCount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "plogging_id")
    private Plogging plogging;

    protected PartyActivity() {
    }

    public PartyActivity(Long partyId, String userId) {
        this.partyId = partyId;
        this.userId = userId;
        this.status = ActivityStatus.IN_PROGRESS;
        this.startedAt = LocalDateTime.now();
    }

    public void complete(Plogging plogging) {
        this.status = ActivityStatus.COMPLETED;
        this.endedAt = LocalDateTime.now();
        this.plogging = plogging;
        this.distance = plogging.getDistance();
        // trashCount는 나중에 계산 (Plogging에서 가져오거나 별도 로직)
    }

    // Getters
    public Long getId() {
        return id;
    }

    public Long getPartyId() {
        return partyId;
    }

    public String getUserId() {
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

    public Plogging getPlogging() {
        return plogging;
    }
}