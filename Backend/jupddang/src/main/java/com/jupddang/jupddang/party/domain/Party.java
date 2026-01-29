package com.jupddang.jupddang.party.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "party")
public class Party {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "invite_code", unique = true, nullable = false, length = 6)
    private String inviteCode;

    @Column(name = "name", length = 100)
    private String name;

    @Column(name = "leader_id", nullable = false, length = 50)
    private String leaderId;

    @Column(name = "max_members", nullable = false)
    private Integer maxMembers = 6;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private PartyStatus status = PartyStatus.WAITING;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "started_at")
    private LocalDateTime startedAt;

    @Column(name = "ended_at") // 종료 시간
    private LocalDateTime endedAt;

    @OneToMany(mappedBy = "party", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PartyMember> members = new ArrayList<>();

    @Column(name = "total_distance")
    private Double totalDistance; // 총 이동 거리 (km 단위 등)

    @Column(name = "total_time")
    private Integer totalTime; // 총 소요 시간 (초 또는 분 단위)

    @Column(name = "total_score")
    private Integer totalScore; // 파티 총 점수 (랭킹용)

    protected Party() {
    }

    public Party(String inviteCode, String name) {
        this.inviteCode = inviteCode;
        this.name = name;
        this.leaderId = leaderId;
        this.createdAt = LocalDateTime.now();
        this.maxMembers = 6;
        this.status = PartyStatus.WAITING;
    }

    public Party(String inviteCode, String name, String leaderId) {
        this.inviteCode = inviteCode;
        this.name = name;
        this.leaderId = leaderId;
        this.maxMembers = 6;
        this.status = PartyStatus.WAITING;
        this.createdAt = LocalDateTime.now();
    }

    public boolean isFull() {
        return members.size() >= maxMembers;
    }

    public boolean isLeader(String userId) {
        return this.leaderId.equals(userId);
    }

    public boolean canStart() {
        return this.status == PartyStatus.WAITING && !members.isEmpty();
    }

    public void start(String requestUserId) {
        if (!isLeader(requestUserId)) {
            throw new IllegalStateException("방장만 파티를 시작할 수 있습니다.");
        }
        if (!canStart()) {
            throw new IllegalStateException("파티를 시작할 수 없는 상태입니다.");
        }
        this.status = PartyStatus.IN_PROGRESS;
        this.startedAt = LocalDateTime.now();
    }

    public void complete(Double totalDistance, Integer totalTime, Integer totalScore) {
        if (this.status != PartyStatus.IN_PROGRESS) {
            throw new IllegalStateException("진행 중인 파티만 완료할 수 있습니다.");
        }
        this.status = PartyStatus.COMPLETED;
        this.endedAt = LocalDateTime.now();

        this.totalDistance = totalDistance;
        this.totalTime = totalTime;
        this.totalScore = totalScore;
    }


    public Long getId() {
        return id;
    }

    public String getInviteCode() {
        return inviteCode;
    }

    public String getName() {
        return name;
    }

    public String getLeaderId() {
        return leaderId;
    }

    public Integer getMaxMembers() {
        return maxMembers;
    }

    public PartyStatus getStatus() {
        return status;
    }

    public LocalDateTime getEndedAt() {
        return endedAt;
    }

    public Double getTotalDistance() {
        return totalDistance;
    }

    public Integer getTotalTime() {
        return totalTime;
    }

    public Integer getTotalScore() {
        return totalScore;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public List<PartyMember> getMembers() {
        return members;
    }
}