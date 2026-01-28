package com.jupddang.jupddang.raid.entity;

import com.jupddang.jupddang.account.entity.Account;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
// ▼▼▼ [여기] 이 부분이 중복 방어막입니다 ▼▼▼
@Table(name = "raid_record",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_raid_record_boss_account",
                        columnNames = {"boss_id", "account_user_id"}
                )
        },
        indexes = {
                @Index(name = "idx_raid_ranking", columnList = "boss_id, total_score DESC, updated_at ASC")
        }
)
// ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
public class RaidRecord {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "boss_id", nullable = false)
    private RaidBoss raidBoss;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_user_id", nullable = false)
    private Account account;

    @Column(name = "total_score", nullable = false)
    private long totalScore;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Builder
    public RaidRecord(RaidBoss raidBoss, Account account, long totalScore) {
        this.raidBoss = raidBoss;
        this.account = account;
        this.totalScore = totalScore;
    }

    public void addScore(int score) {
        this.totalScore += score;
    }
}