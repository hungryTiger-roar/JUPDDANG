//package com.jupddang.jupddang.plogging.repository;
//
//import com.jupddang.jupddang.plogging.domain.Plogging;
//import org.springframework.data.jpa.repository.JpaRepository;
//
//import java.util.List;
//import java.util.Optional;
//
//
//public interface PloggingRepository  extends JpaRepository<Plogging, Long> {
//
//}

package com.jupddang.jupddang.plogging.repository;

import com.jupddang.jupddang.plogging.domain.Plogging;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface PloggingRepository extends JpaRepository<Plogging, Long> {

    // 이제 Plogging 엔티티에 account, score, createdAt이 생겼으니 빨간 줄이 사라집니다!
    @Query("SELECT p.account.userId, p.account.nickname, p.account.profileImage, SUM(p.score) " +
            "FROM Plogging p " +
            "WHERE p.createdAt BETWEEN :startDate AND :endDate " +
            "GROUP BY p.account " +
            "ORDER BY SUM(p.score) DESC")
    List<Object[]> findMonthlyRanking(@Param("startDate") LocalDateTime startDate,
                                      @Param("endDate") LocalDateTime endDate,
                                      Pageable pageable);
}