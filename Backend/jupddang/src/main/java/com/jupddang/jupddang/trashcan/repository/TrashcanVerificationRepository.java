package com.jupddang.jupddang.trashcan.repository;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.trashcan.entity.TrashcanVerification;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TrashcanVerificationRepository extends JpaRepository<TrashcanVerification, Long> {

    /**
     * 특정 사용자가 특정 쓰레기통을 이미 검증했는지 확인
     * 중복 검증 방지용
     *
     * @param trashcanId 쓰레기통 ID
     * @param user 검증한 사용자
     * @return 이미 검증했으면 true, 아니면 false
     */
    boolean existsByTrashcan_IdAndUser(Long trashcanId, Account user);
}