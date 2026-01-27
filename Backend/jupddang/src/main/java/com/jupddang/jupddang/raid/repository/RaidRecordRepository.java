package com.jupddang.jupddang.raid.repository;

import com.jupddang.jupddang.raid.entity.RaidRecord;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RaidRecordRepository extends JpaRepository<RaidRecord, Long> {

    // 1. 내 기여도 추가 (Upsert용 Update)
    @Modifying
    @Query("UPDATE RaidRecord r SET r.totalScore = r.totalScore + :score, r.updatedAt = NOW() " +
            "WHERE r.raidBoss.id = :bossId AND r.account.id = :userId")
    // [수정] userId 타입을 Long -> String으로 변경
    int addDamage(@Param("bossId") Long bossId, @Param("userId") String userId, @Param("score") int score);

    // 2. 특정 구역의 총 누적 점수 합계
    @Query("SELECT COALESCE(SUM(r.totalScore), 0) FROM RaidRecord r WHERE r.raidBoss.id = :bossId")
    long sumTotalScoreByBossId(@Param("bossId") Long bossId);

    // 3. 랭킹 조회
    @Query("SELECT r FROM RaidRecord r JOIN FETCH r.account " +
            "WHERE r.raidBoss.id = :bossId " +
            "ORDER BY r.totalScore DESC, r.updatedAt ASC")
    List<RaidRecord> findTopRankers(@Param("bossId") Long bossId, Pageable pageable);
}