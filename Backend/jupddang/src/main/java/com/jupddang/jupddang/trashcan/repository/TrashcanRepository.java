package com.jupddang.jupddang.trashcan.repository;

import com.jupddang.jupddang.trashcan.entity.Trashcan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrashcanRepository extends JpaRepository<Trashcan, Long> {
    // 기본 CRUD 메서드는 JpaRepository가 자동 제공
    // save, findById, findAll, delete, count 등
}