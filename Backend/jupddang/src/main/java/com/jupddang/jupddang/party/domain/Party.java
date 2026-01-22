package com.jupddang.jupddang.party.domain;

import jakarta.persistence.*;

import java.time.LocalDateTime;

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

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    // JPA 기본 생성자 (protected로 외부 생성 방지)
    protected Party() {
    }

    // 생성자 (final 필드 초기화)
    public Party(String inviteCode, String name) {
        this.inviteCode = inviteCode;
        this.name = name;
        this.createdAt = LocalDateTime.now();
    }

    // Getter만 제공 (불변성 유지)
    public Long getId() {
        return id;
    }

    public String getInviteCode() {
        return inviteCode;
    }

    public String getName() {
        return name;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}