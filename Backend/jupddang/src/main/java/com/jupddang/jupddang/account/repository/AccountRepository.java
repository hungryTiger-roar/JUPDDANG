package com.jupddang.jupddang.account.repository;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.sns.entity.Comment;
import com.jupddang.jupddang.sns.entity.Post;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, String> {

    Optional<Account> findByUserId(String userId);

    // [추가됨] 이메일 중복 체크용
    boolean existsByEmail(String email);

    // [Redis 연동용]
    List<Account> findAllByUserIdIn(List<String> userIds);

    // [DB 랭킹 조회용]
    Slice<Account> findAllByOrderByTotalScoreDesc(Pageable pageable);

    // [내 등수 확인용]
    long countByTotalScoreGreaterThan(long totalScore);
}