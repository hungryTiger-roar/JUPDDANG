package com.jupddang.jupddang.account.repository;

import com.jupddang.jupddang.account.entity.Account;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, String> {

    Optional<Account> findByUserId(String userId);

    Optional<Account> findByUserIdAndPw(String userId, String pw);

    // 점수 높은 순으로 상위 10명(임의) 가져오기
    Slice<Account> findAllByOrderByScoreDesc(Pageable pageable);

    // 나보다 점수 높은 사람 몇 명인지 세기(내 등수 계산용)
    long countByScoreGreaterThan(int score);
}
