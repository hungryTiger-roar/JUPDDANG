package com.jupddang.jupddang.account.dto;

public class AccountUpdateRequest {

    private String pw;
    private String name;
    private String email;
    private String address;

    public String getPw() { return pw; }

    public String getAddress() {
        return address;
    }

    public String getEmail() {
        return email;
    }

    public String getName() {
        return name;
    }

}
