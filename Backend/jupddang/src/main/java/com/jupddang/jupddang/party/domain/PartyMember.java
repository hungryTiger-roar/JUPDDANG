package com.jupddang.jupddang.party.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "party_member",
        uniqueConstraints = @UniqueConstraint(columnNames = {"party_id", "user_id"}))
public class PartyMember {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "party_id", nullable = false)
    private Party party;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "joined_at", nullable = false)
    private LocalDateTime joinedAt;

    // JPA 기본 생성자
    protected PartyMember() {
    }

    // 비즈니스 생성자
    public PartyMember(Party party, Long userId) {
        this.party = party;
        this.userId = userId;
        this.joinedAt = LocalDateTime.now();
    }

    // Getters
    public Long getId() {
        return id;
    }

    public Party getParty() {
        return party;
    }

    public Long getUserId() {
        return userId;
    }

    public LocalDateTime getJoinedAt() {
        return joinedAt;
    }
}