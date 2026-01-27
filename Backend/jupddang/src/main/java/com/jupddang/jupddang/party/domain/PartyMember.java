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

    @Column(name = "user_id", nullable = false, length = 50)
    private String userId;

    @Column(name = "joined_at", nullable = false)
    private LocalDateTime joinedAt;

    protected PartyMember() {
    }

    public PartyMember(Party party, String userId) {
        this.party = party;
        this.userId = userId;
        this.joinedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public Party getParty() {
        return party;
    }

    public String getUserId() {
        return userId;
    }

    public LocalDateTime getJoinedAt() {
        return joinedAt;
    }
}