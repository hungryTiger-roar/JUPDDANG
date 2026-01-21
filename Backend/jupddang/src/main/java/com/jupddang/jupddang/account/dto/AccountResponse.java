package com.jupddang.jupddang.account.dto;

import com.jupddang.jupddang.account.entity.Account;

import java.time.LocalDateTime;

public class AccountResponse {

    private String userId;
    private String email;
    private String name;
    private String address;
    private LocalDateTime createdAt;

    public AccountResponse(String userId, String email, String name, String address, LocalDateTime createdAt) {
        this.userId = userId;
        this.email = email;
        this.name = name;
        this.address = address;
        this.createdAt = createdAt;
    }

    public String getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }

    public String getName() {
        return name;
    }

    public String getAddress() {
        return address;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

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
