package com.jupddang.jupddang.follow.service;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.follow.domain.Follow;
import com.jupddang.jupddang.follow.repository.FollowRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Transactional
public class FollowService {
    private final FollowRepository followRepository;
    private final AccountRepository accountRepository;

    public String toggleFollow(String followerId, String followingId) {
        // 1. 자기 자신 팔로우 검증
        if (followerId.equals(followingId)) {
            throw new IllegalArgumentException("자기 자신을 팔로우할 수 없습니다.");
        }

        // 2. 두 사용자(Account) 존재 여부 확인
        Account follower = accountRepository.findByUserId(followerId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));
        Account following = accountRepository.findByUserId(followingId)
                .orElseThrow(() -> new IllegalArgumentException("대상 사용자를 찾을 수 없습니다."));

        // 3. 이미 팔로우 중인지 확인 후 토글 처리
        return followRepository.findByFollowerAndFollowing(follower, following)
                .map(follow -> {
                    followRepository.delete(follow);
                    return "unfollowed";
                })
                .orElseGet(() -> {
                    followRepository.save(Follow.builder()
                            .follower(follower)
                            .following(following)
                            .build());
                    return "followed";
                });
    }
}