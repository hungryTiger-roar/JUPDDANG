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

    @OneToMany(mappedBy = "party", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PartyMember> members = new ArrayList<>();

    protected Party() {
    }

    public Party(String inviteCode, String name) {
        this.inviteCode = inviteCode;
        this.name = name;
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

    public void complete() {
        if (this.status != PartyStatus.IN_PROGRESS) {
            throw new IllegalStateException("진행 중인 파티만 완료할 수 있습니다.");
        }
        this.status = PartyStatus.COMPLETED;
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