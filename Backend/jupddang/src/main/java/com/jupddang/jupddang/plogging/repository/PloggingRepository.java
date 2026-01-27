

package com.jupddang.jupddang.plogging.repository;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.plogging.domain.Plogging;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;


public interface PloggingRepository  extends JpaRepository<Plogging, String> {

    // 1. 월간 랭킹 리스트 조회 (상위 N명)
    @Query("SELECT p.account.userId, p.account.nickname, p.account.profileImage, SUM(p.score) " +
            "FROM Plogging p " +
            "WHERE p.createdAt BETWEEN :startDate AND :endDate " +
            "GROUP BY p.account " +
            "ORDER BY SUM(p.score) DESC")
    List<Object[]> findMonthlyRanking(@Param("startDate") LocalDateTime startDate,
                                      @Param("endDate") LocalDateTime endDate,
                                      Pageable pageable);

    // 2. [추가] 내 월간 점수 합계 조회 (내 랭킹용)
    @Query("SELECT SUM(p.score) FROM Plogging p " +
            "WHERE p.account = :account AND p.createdAt BETWEEN :startDate AND :endDate")
    Optional<Long> sumScoreByAccountAndDate(@Param("account") Account account,
                                            @Param("startDate") LocalDateTime startDate,
                                            @Param("endDate") LocalDateTime endDate);
}
