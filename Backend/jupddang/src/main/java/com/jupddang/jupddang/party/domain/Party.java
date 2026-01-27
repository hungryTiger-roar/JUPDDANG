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

    @Column(name = "leader_id", nullable = false)
    private Long leaderId;  // 추가: 방장 User ID

    @Column(name = "max_members", nullable = false)
    private Integer maxMembers = 6;  // 추가: 최대 인원 (기본값 6명)

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private PartyStatus status = PartyStatus.WAITING;  // 추가: 파티 상태

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "started_at")
    private LocalDateTime startedAt;  // 추가: 파티 시작 시각

    @OneToMany(mappedBy = "party", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PartyMember> members = new ArrayList<>();  // 추가: 참여자 목록

    // JPA 기본 생성자 (protected로 외부 생성 방지)
    protected Party() {
    }

    // 기존 생성자 (하위 호환성 유지)
    public Party(String inviteCode, String name) {
        this.inviteCode = inviteCode;
        this.name = name;
        this.createdAt = LocalDateTime.now();
        this.maxMembers = 6;
        this.status = PartyStatus.WAITING;
    }

    // 새로운 생성자 (leaderId 포함)
    public Party(String inviteCode, String name, Long leaderId) {
        this.inviteCode = inviteCode;
        this.name = name;
        this.leaderId = leaderId;
        this.maxMembers = 6;
        this.status = PartyStatus.WAITING;
        this.createdAt = LocalDateTime.now();
    }

    // === 비즈니스 메서드 ===

    /**
     * 파티 인원이 가득 찼는지 확인
     */
    public boolean isFull() {
        return members.size() >= maxMembers;
    }

    /**
     * 특정 사용자가 방장인지 확인
     */
    public boolean isLeader(Long userId) {
        return this.leaderId.equals(userId);
    }

    /**
     * 파티 시작 가능 여부 확인
     */
    public boolean canStart() {
        return this.status == PartyStatus.WAITING && !members.isEmpty();
    }

    /**
     * 파티 시작 (방장만 가능)
     * @throws IllegalStateException 방장이 아니거나 시작할 수 없는 상태일 때
     */
    public void start(Long requestUserId) {
        if (!isLeader(requestUserId)) {
            throw new IllegalStateException("방장만 파티를 시작할 수 있습니다.");
        }
        if (!canStart()) {
            throw new IllegalStateException("파티를 시작할 수 없는 상태입니다.");
        }
        this.status = PartyStatus.IN_PROGRESS;
        this.startedAt = LocalDateTime.now();
    }

    /**
     * 파티 완료
     * @throws IllegalStateException 진행 중이 아닐 때
     */
    public void complete() {
        if (this.status != PartyStatus.IN_PROGRESS) {
            throw new IllegalStateException("진행 중인 파티만 완료할 수 있습니다.");
        }
        this.status = PartyStatus.COMPLETED;
    }

    // === Getter 메서드 (불변성 유지) ===

    public Long getId() {
        return id;
    }

    public String getInviteCode() {
        return inviteCode;
    }

    public String getName() {
        return name;
    }

    public Long getLeaderId() {
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