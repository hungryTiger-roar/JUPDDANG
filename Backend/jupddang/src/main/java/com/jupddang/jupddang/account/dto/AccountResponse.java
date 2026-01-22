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
    private String name;
    private String address;
    private LocalDateTime createdAt;

    public static AccountResponse from(Account account) {
        return new AccountResponse(
                account.getUserId(),
                account.getEmail(),
                account.getName(),
                account.getAddress(),
                account.getCreatedAt()
        );
    }


}
