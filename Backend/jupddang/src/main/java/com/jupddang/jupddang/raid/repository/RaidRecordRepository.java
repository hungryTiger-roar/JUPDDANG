package com.jupddang.jupddang.raid.repository;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.raid.entity.RaidBoss;
import com.jupddang.jupddang.raid.entity.RaidRecord;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RaidRecordRepository extends JpaRepository<RaidRecord, Long> {

    // [1] 테스트 코드에서 사용하는 메서드 (JPA Query Method)
    // "특정 보스"에 대해 "특정 유저"가 남긴 기록 조회
    Optional<RaidRecord> findByRaidBossAndAccount(RaidBoss raidBoss, Account account);

    // ------------------------------------------------------------------------

    // [2] RaidService.getBossDetail()에서 사용
    // 특정 보스의 총 점수 합계 (NULL일 경우 0 반환)
    @Query("SELECT COALESCE(SUM(r.totalScore), 0) FROM RaidRecord r WHERE r.raidBoss.id = :bossId")
    long sumTotalScoreByBossId(@Param("bossId") Long bossId);

    // [3] RaidService.getBossDetail()에서 사용
    // 랭킹 조회 (점수 내림차순 -> 달성 시간 오름차순), N+1 방지를 위해 Fetch Join 사용
    @Query("SELECT r FROM RaidRecord r JOIN FETCH r.account WHERE r.raidBoss.id = :bossId ORDER BY r.totalScore DESC, r.updatedAt ASC")
    List<RaidRecord> findTopRankers(@Param("bossId") Long bossId, Pageable pageable);

    // [4] RaidService.applyRaidScore()에서 사용
    // 점수 추가 (Update) - 이미 기록이 있을 때 Update 쿼리를 바로 날려 성능 최적화
    // clearAutomatically = true: 벌크 연산 후 영속성 컨텍스트를 비워야 DB와 싱크가 맞음 (테스트 통과 필수)
    @Modifying(clearAutomatically = true)
    @Query("UPDATE RaidRecord r SET r.totalScore = r.totalScore + :score, r.updatedAt = CURRENT_TIMESTAMP " +
            "WHERE r.raidBoss.id = :bossId AND r.account.userId = :userId")
    int addDamage(@Param("bossId") Long bossId, @Param("userId") String userId, @Param("score") int score);
}