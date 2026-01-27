package com.jupddang.jupddang.account.repository;

import com.jupddang.jupddang.account.entity.Account;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, String> {

    Optional<Account> findByUserId(String userId);

    // [누적 랭킹]
    // [Redis]
    // Redis에서 등수, 아이디를 가져왔을 때
    // 그 아이디들의 닉네임, 프사 등을 한방에 조회하는 메서드
    List<Account> findAllByUserIdIn(List<String> userIds);

    // [DB]
    // 누적 점수(total_score) 높은 순으로 잘라서 가져오기
    Slice<Account> findAllByOrderByTotalScoreDesc(Pageable pageable);

    // 내 누적 점수(total_score)보다 높은 사람이 몇 명인지 세기
    long countByTotalScoreGreaterThan(long totalScore);
}
