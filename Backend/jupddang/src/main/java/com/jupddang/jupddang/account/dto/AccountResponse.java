package com.jupddang.jupddang.account.dto;

import com.jupddang.jupddang.account.entity.Account;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class AccountResponse {

    private String userId;
    private String email;
    private String nickname;
    String profileImage;
    String intro;
    private String color;
    private long totalScore;
    private String tier;
    private String color; // 사용자 개인 색상 추가
    private LocalDateTime createdAt;
    private boolean isFollowing;
    private long followerCount;
    private long followingCount;

    public static AccountResponse from(Account account, boolean isFollowing, long followers, long followings) {
        String color = account.getColor();
        if (color == null || color.isBlank()) {
            color = "#111111";
        }
        return new AccountResponse(
                account.getUserId(),
                account.getEmail(),
                account.getNickname(),
                account.getProfileImage(),
                account.getIntro(),
                color,
                account.getTotalScore(),
                account.getTier(),
                account.getColor(), // color 매핑 추가
                account.getCreatedAt(),
                isFollowing,
                followers,
                followings);
    }

    public static AccountResponse from(Account account) {
        return from(account, false, 0, 0);
    }
}
