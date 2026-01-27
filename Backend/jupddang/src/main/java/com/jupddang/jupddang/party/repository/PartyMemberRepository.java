package com.jupddang.jupddang.party.repository;

import com.jupddang.jupddang.party.domain.PartyMember;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PartyMemberRepository extends JpaRepository<PartyMember, Long> {

    // 특정 파티의 모든 멤버 조회
    List<PartyMember> findByPartyId(Long partyId);

    // 특정 파티의 특정 멤버 조회
    Optional<PartyMember> findByPartyIdAndUserId(Long partyId, Long userId);

    // 멤버 참여 여부 확인
    boolean existsByPartyIdAndUserId(Long partyId, Long userId);

    // 파티 인원 수 카운트
    long countByPartyId(Long partyId);

    // 멤버 삭제 (파티 나가기용)
    void deleteByPartyIdAndUserId(Long partyId, Long userId);
}