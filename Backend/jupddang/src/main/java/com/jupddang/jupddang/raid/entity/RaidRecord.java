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
@Table(name = "raid_record", indexes = {
        // [핵심] 랭킹 조회용 복합 인덱스 (점수 내림차순 -> 달성 시간 오름차순)
        @Index(name = "idx_raid_ranking", columnList = "boss_id, total_score DESC, updated_at ASC")
})
public class RaidRecord {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 어떤 구역(보스)에 대한 기록인지
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "boss_id", nullable = false)
    private RaidBoss raidBoss;

    // 누구의 기록인지
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "account_user_id", nullable = false)
    private Account account;

    // [변경] int -> long (개인의 누적 점수도 안전하게 long 처리)
    // "누적 기여도"
    @Column(name = "total_score", nullable = false)
    private long totalScore;

    // 마지막 기여 시간 (랭킹 동점자 처리용)
    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Builder
    public RaidRecord(RaidBoss raidBoss, Account account, long totalScore) {
        this.raidBoss = raidBoss;
        this.account = account;
        this.totalScore = totalScore;
    }

    // [주의] 동시성 이슈 때문에 이 메서드 대신 Repository의 @Modifying 쿼리 사용 권장
    // 테스트 코드나 초기 생성 시에만 사용하세요.
    public void addScore(int score) {
        this.totalScore += score;
    }
}