package com.jupddang.jupddang.account.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class AccountCreateRequest {

    @JsonAlias("id")
    private String userId;
    private String pw;
    private String email;
    private String name;
    private String address;


}
