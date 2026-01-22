package com.jupddang.jupddang.party.repository;

import com.jupddang.jupddang.party.domain.Party;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PartyRepository extends JpaRepository<Party, Long> {

    /**
     * 초대 코드 존재 여부 확인
     * 중복 체크에 사용
     */
    boolean existsByInviteCode(String inviteCode);

    /**
     * 초대 코드로 파티 조회
     * 파티 입장 시 사용
     */
    Optional<Party> findByInviteCode(String inviteCode);
}
