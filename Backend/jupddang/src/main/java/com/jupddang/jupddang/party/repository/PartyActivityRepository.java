package com.jupddang.jupddang.party.repository;

import com.jupddang.jupddang.party.domain.PartyActivity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PartyActivityRepository extends JpaRepository<PartyActivity, Long> {

    // 특정 파티의 모든 활동 조회
    List<PartyActivity> findByPartyId(Long partyId);

    // 특정 사용자의 특정 파티 활동 조회
    Optional<PartyActivity> findByPartyIdAndUserId(Long partyId, Long userId);
}