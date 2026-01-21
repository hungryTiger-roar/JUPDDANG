package com.jupddang.jupddang.account.dto;

import com.fasterxml.jackson.annotation.JsonAlias;

public class AccountLoginRequest {

    @JsonAlias("id")
    private String userId;
    private String pw;

    public AccountLoginRequest() {
    }

    public AccountLoginRequest(String userId, String pw) {
        this.userId = userId;
        this.pw = pw;
    }

    public String getUserId() {
        return userId;
    }

    public String getPw() {
        return pw;
    }


}
