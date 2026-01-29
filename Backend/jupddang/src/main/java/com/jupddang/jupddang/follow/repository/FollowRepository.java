package com.jupddang.jupddang.follow.repository;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.follow.domain.Follow;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FollowRepository extends JpaRepository<Follow, Long> {
    // 이미 팔로우한 관계인지 확인 (언팔로우나 중복 방지용)
    Optional<Follow> findByFollowerAndFollowing(Account follower, Account following);

    // 팔로워/팔로잉 숫자 카운트
    long countByFollower(Account follower);
    long countByFollowing(Account following);

    List<Follow> findAllByFollower(Account follower); // 내가 팔로우하는 관계들 찾기
    List<Follow> findAllByFollowing(Account following); // 나를 팔로우하는 관계들 찾기
}