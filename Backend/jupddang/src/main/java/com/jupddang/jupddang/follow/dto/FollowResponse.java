package com.jupddang.jupddang.follow.dto;

import com.jupddang.jupddang.account.entity.Account;

public record FollowResponse(
        String userId,
        String nickname,
        String profileImage,
        String intro
) {
    // 엔티티를 DTO로 변환하는 정적 팩토리 메서드
    public static FollowResponse from(Account account) {
        return new FollowResponse(
                account.getUserId(),
                account.getNickname(),
                account.getProfileImage(),
                account.getIntro()
        );
    }
}