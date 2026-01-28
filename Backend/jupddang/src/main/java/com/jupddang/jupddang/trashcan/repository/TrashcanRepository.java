package com.jupddang.jupddang.trashcan.repository;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.trashcan.entity.Trashcan;
import com.jupddang.jupddang.trashcan.entity.TrashcanStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrashcanRepository extends JpaRepository<Trashcan, Long> {

    /**
     * 지도 영역 내의 쓰레기통 조회
     */
    @Query("SELECT t FROM Trashcan t " +
            "WHERE t.latitude BETWEEN :minLat AND :maxLat " +
            "AND t.longitude BETWEEN :minLng AND :maxLng")
    List<Trashcan> findByLocationRange(
            @Param("minLat") Double minLat,
            @Param("maxLat") Double maxLat,
            @Param("minLng") Double minLng,
            @Param("maxLng") Double maxLng
    );

    /**
     * 특정 사용자가 제안한 쓰레기통 전체 조회 (최신순)
     */
    List<Trashcan> findByReportedByOrderByIdDesc(Account reportedBy);

    /**
     * 특정 사용자가 제안한 쓰레기통 중 특정 상태만 조회 (최신순)
     */
    List<Trashcan> findByReportedByAndStatusOrderByIdDesc(Account reportedBy, TrashcanStatus status);

    // ========================================================================
    //  동시성 해결을 위한 Atomic Query (JPQL)
    // ========================================================================

    /**
     * 검증 횟수 1 증가 (DB 직접 업데이트, 1차 캐시 무시)
     */
    @Modifying(clearAutomatically = true)
    @Query("UPDATE Trashcan t SET t.verificationCount = t.verificationCount + 1 WHERE t.id = :id")
    void increaseVerificationCount(@Param("id") Long id);

    /**
     * 검증 횟수가 3회 이상이면 상태를 VERIFIED로 변경
     */
    @Modifying(clearAutomatically = true)
    @Query("UPDATE Trashcan t SET t.status = 'VERIFIED' WHERE t.id = :id AND t.verificationCount >= 3")
    void updateStatusIfVerified(@Param("id") Long id);
}