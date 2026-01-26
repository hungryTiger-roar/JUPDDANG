package com.jupddang.jupddang.trashcan.repository;

import com.jupddang.jupddang.trashcan.entity.Trashcan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrashcanRepository extends JpaRepository<Trashcan, Long> {

    /**
     * 지도 영역 내의 쓰레기통 조회
     *
     * @param minLat 최소 위도
     * @param maxLat 최대 위도
     * @param minLng 최소 경도
     * @param maxLng 최대 경도
     * @return 범위 내 쓰레기통 목록
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
}