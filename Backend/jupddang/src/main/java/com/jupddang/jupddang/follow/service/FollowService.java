package com.jupddang.jupddang.follow.service;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.fcm.FcmService;
import com.jupddang.jupddang.follow.domain.Follow;
import com.jupddang.jupddang.follow.dto.FollowResponse;
import com.jupddang.jupddang.follow.repository.FollowRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class FollowService {
    private final FollowRepository followRepository;
    private final AccountRepository accountRepository;
    private final FcmService fcmService;

    @Transactional
    public String toggleFollow(String followerId, String followingId) {

        // 1. 자기 자신 팔로우 방지
        if (followerId.equals(followingId)) {
            throw new IllegalArgumentException("자기 자신을 팔로우할 수 없습니다.");
        }

        // 2. 사용자 조회
        Account follower = accountRepository.findByUserId(followerId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        Account following = accountRepository.findByUserId(followingId)
                .orElseThrow(() -> new IllegalArgumentException("대상 사용자를 찾을 수 없습니다."));

        // 3. 팔로우 토글
        return followRepository.findByFollowerAndFollowing(follower, following)
                .map(follow -> {
                    // 이미 팔로우 중 → 언팔로우
                    followRepository.delete(follow);
                    return "unfollowed";
                })
                .orElseGet(() -> {
                    // 새로 팔로우
                    followRepository.save(Follow.builder()
                            .follower(follower)
                            .following(following)
                            .build());

                    // 팔로우 알림 전송
                    try {
                        fcmService.sendFollowNotification(
                                following.getUserId(),      // 알림 받을 사람
                                follower.getUserId(), // 팔로우한 사람 아이디
                                follower.getNickname()       // 팔로우한 사람 닉네임
                        );
                    } catch (Exception e) {
                        log.warn("팔로우 알림 전송 실패", e);
                    }

                    return "followed";
                });
    }

    @Transactional(readOnly = true)
    public List<FollowResponse> getFollowings(String userId) {
        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        // 내가 팔로잉하는 목록 (Follow 엔티티의 following 대상들을 추출)
        return followRepository.findAllByFollower(account).stream()
                .map(follow -> FollowResponse.from(follow.getFollowing()))
                .toList();
    }

    @Transactional(readOnly = true)
    public List<FollowResponse> getFollowers(String userId) {
        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        // 나를 팔로우하는 목록 (Follow 엔티티의 follower들을 추출)
        return followRepository.findAllByFollowing(account).stream()
                .map(follow -> FollowResponse.from(follow.getFollower()))
                .toList();
    }
}