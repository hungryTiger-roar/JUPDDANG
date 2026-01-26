package com.jupddang.jupddang.trashcan.repository;

import com.jupddang.jupddang.trashcan.entity.TrashcanVerification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrashcanVerificationRepository extends JpaRepository<TrashcanVerification, Long> {
    // 기본 CRUD 메서드 제공
}