package com.jupddang.jupddang.account.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class AccountLoginResponse {

    private String accessToken;
    private String tokenType;
    private long expiresInSeconds;
    private AccountResponse account;

    public static AccountLoginResponse of(String accessToken, long expiresInSeconds, AccountResponse account) {
        return new AccountLoginResponse(accessToken, "Bearer", expiresInSeconds, account);
    }
}
