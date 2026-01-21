package com.jupddang.jupddang.account.dto;

import com.fasterxml.jackson.annotation.JsonAlias;

public class AccountCreateRequest {

    @JsonAlias("id")
    private String userId;
    private String pw;
    private String email;
    private String name;
    private String address;

    public AccountCreateRequest() {
    }

    public AccountCreateRequest(String userId, String pw, String email, String name, String address) {
        this.userId = userId;
        this.pw = pw;
        this.email = email;
        this.name = name;
        this.address = address;
    }

    public String getUserId() {
        return userId;
    }

    public String getPw() {
        return pw;
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
}
