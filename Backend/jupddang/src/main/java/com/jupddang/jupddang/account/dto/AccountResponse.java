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
    private String address;
    String profileImage;
    String intro;
    private long totalScore;
    private String tier;
    private LocalDateTime createdAt;

    public static AccountResponse from(Account account) {
        return new AccountResponse(
                account.getUserId(),
                account.getEmail(),
                account.getNickname(),
                account.getRegion(),
                account.getProfileImage(),
                account.getIntro(),
                account.getTotalScore(),
                account.getTier(),
                account.getCreatedAt()
        );
    }

}
