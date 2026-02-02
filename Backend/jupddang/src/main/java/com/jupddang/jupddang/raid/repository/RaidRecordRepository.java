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

    // =========================================================================
    // [1] 단일 레코드 조회
    // =========================================================================

    /**
     * 특정 보스에 대한 특정 사용자의 레이드 기록 조회
     * 
     * @param raidBoss 레이드 보스 엔티티
     * @param account  계정 엔티티
     * @return 레이드 기록 (없으면 Optional.empty())
     *
     *         사용처:
     *         - RaidService.applyRaidScore(): 기존 기록 존재 여부 확인용
     *         - 테스트 코드: 점수 누적 검증용
     */
    Optional<RaidRecord> findByRaidBossAndAccount(RaidBoss raidBoss, Account account);

    /**
     * 특정 보스에 대한 특정 사용자의 레이드 기록 조회 (ID 기반)
     * 
     * @param bossId 레이드 보스 ID
     * @param userId 사용자 ID
     * @return 레이드 기록 (없으면 Optional.empty())
     *
     *         사용처:
     *         - 엔티티를 조회하지 않고 ID만으로 빠르게 조회할 때 사용
     */
    @Query("SELECT r FROM RaidRecord r WHERE r.raidBoss.id = :bossId AND r.account.userId = :userId")
    Optional<RaidRecord> findByBossIdAndUserId(@Param("bossId") Long bossId, @Param("userId") String userId);

    // =========================================================================
    // [2] 집계 쿼리
    // =========================================================================

    /**
     * 특정 보스에 대한 총 공격력(점수) 합계 조회
     * 
     * @param bossId 레이드 보스 ID
     * @return 총 공격력 (레코드가 없으면 0 반환)
     *
     *         사용처:
     *         - RaidService.getBossDetail(): 보스의 현재 체력 계산 (maxHp - totalDamage)
     */
    @Query("SELECT COALESCE(SUM(r.totalScore), 0) FROM RaidRecord r WHERE r.raidBoss.id = :bossId")
    long sumTotalScoreByBossId(@Param("bossId") Long bossId);

    /**
     * 특정 보스에 참여한 전체 유저 수 조회
     * 
     * @param bossId 레이드 보스 ID
     * @return 참여 유저 수
     *
     *         사용처:
     *         - 통계 조회, 랭킹 페이징 처리
     */
    @Query("SELECT COUNT(r) FROM RaidRecord r WHERE r.raidBoss.id = :bossId")
    long countByBossId(@Param("bossId") Long bossId);

    // =========================================================================
    // [3] 랭킹 조회
    // =========================================================================

    /**
     * 특정 보스의 랭킹 조회 (점수 내림차순, 동점 시 달성 시간 빠른 순)
     * 
     * @param bossId   레이드 보스 ID
     * @param pageable 페이징 정보 (PageRequest.of(0, 10) 등)
     * @return 랭킹 리스트 (N+1 문제 방지를 위해 Fetch Join 사용)
     *
     *         사용처:
     *         - RaidService.getBossDetail(): 상위 랭커 조회
     *
     *         성능 최적화:
     *         - JOIN FETCH로 Account 엔티티를 한 번에 조회하여 N+1 문제 방지
     */
    @Query("SELECT r FROM RaidRecord r JOIN FETCH r.account " +
            "WHERE r.raidBoss.id = :bossId " +
            "ORDER BY r.totalScore DESC, r.updatedAt ASC")
    List<RaidRecord> findTopRankers(@Param("bossId") Long bossId, Pageable pageable);

    /**
     * 특정 사용자의 랭킹 조회 (본인보다 높은 점수를 가진 사람 수 + 1)
     * 
     * @param bossId     레이드 보스 ID
     * @param totalScore 사용자의 현재 점수
     * @return 랭킹 순위 (1위부터 시작)
     *
     *         사용처:
     *         - 내 랭킹 조회 API
     */
    @Query("SELECT COUNT(r) + 1 FROM RaidRecord r " +
            "WHERE r.raidBoss.id = :bossId " +
            "AND (r.totalScore > :totalScore OR (r.totalScore = :totalScore AND r.updatedAt < :updatedAt))")
    long findRankByBossIdAndScore(
            @Param("bossId") Long bossId,
            @Param("totalScore") long totalScore,
            @Param("updatedAt") java.time.LocalDateTime updatedAt);

    // =========================================================================
    // [4] 점수 업데이트 (벌크 연산)
    // =========================================================================

    /**
     * 기존 레이드 기록에 점수 추가 (Update)
     * 
     * @param bossId 레이드 보스 ID
     * @param userId 사용자 ID
     * @param score  추가할 점수
     * @return 업데이트된 행 수 (0이면 기록이 없음, 1이면 성공)
     *
     *         사용처:
     *         - RaidService.applyRaidScore(): 기존 기록에 점수 추가
     *
     *         성능 최적화:
     *         - Bulk Update 쿼리로 직접 DB에 반영 (영속성 컨텍스트를 거치지 않음)
     *         - clearAutomatically = true: 벌크 연산 후 영속성 컨텍스트 초기화
     *         → 이후 조회 시 DB의 최신 데이터를 가져옴 (테스트 통과 필수)
     *
     *         주의사항:
     *         - 이 메서드 호출 후 같은 트랜잭션에서 해당 엔티티를 조회하면
     *         영속성 컨텍스트가 비워졌으므로 DB에서 최신 값을 가져옴
     */
    @Modifying(clearAutomatically = true)
    @Query("UPDATE RaidRecord r " +
            "SET r.totalScore = r.totalScore + :score, " +
            "    r.updatedAt = CURRENT_TIMESTAMP " +
            "WHERE r.raidBoss.id = :bossId AND r.account.userId = :userId")
    int addDamage(
            @Param("bossId") Long bossId,
            @Param("userId") String userId,
            @Param("score") int score);

    // =========================================================================
    // [5] 삭제 쿼리
    // =========================================================================

    /**
     * 특정 보스의 모든 레이드 기록 삭제
     * 
     * @param bossId 레이드 보스 ID
     *
     *               사용처:
     *               - 보스 삭제 시 연관된 모든 레코드 삭제 (Cascade 대신 명시적 삭제)
     */
    @Modifying
    @Query("DELETE FROM RaidRecord r WHERE r.raidBoss.id = :bossId")
    void deleteAllByBossId(@Param("bossId") Long bossId);

    /**
     * 특정 보스의 모든 기록 삭제 (관리자용 - 삭제 개수 반환)
     * 
     * @param bossId 레이드 보스 ID
     * @return 삭제된 레코드 수
     */
    @Modifying
    @Query("DELETE FROM RaidRecord r WHERE r.raidBoss.id = :bossId")
    int deleteByRaidBossId(@Param("bossId") Long bossId);

    /**
     * 특정 사용자의 모든 레이드 기록 삭제
     * 
     * @param userId 사용자 ID
     *
     *               사용처:
     *               - 회원 탈퇴 시 해당 유저의 모든 레이드 기록 삭제
     */
    @Modifying
    @Query("DELETE FROM RaidRecord r WHERE r.account.userId = :userId")
    void deleteAllByUserId(@Param("userId") String userId);

    // =========================================================================
    // [6] 조건부 조회
    // =========================================================================

    /**
     * 특정 점수 이상의 레코드 조회
     * 
     * @param bossId   레이드 보스 ID
     * @param minScore 최소 점수
     * @return 조건에 맞는 레코드 리스트
     *
     *         사용처:
     *         - 특정 점수 이상 달성한 유저 조회 (이벤트, 보상 지급)
     */
    @Query("SELECT r FROM RaidRecord r JOIN FETCH r.account " +
            "WHERE r.raidBoss.id = :bossId AND r.totalScore >= :minScore " +
            "ORDER BY r.totalScore DESC")
    List<RaidRecord> findByBossIdAndMinScore(
            @Param("bossId") Long bossId,
            @Param("minScore") long minScore);
}
