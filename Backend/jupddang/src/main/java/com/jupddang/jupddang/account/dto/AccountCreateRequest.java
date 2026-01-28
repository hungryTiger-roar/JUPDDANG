package com.jupddang.jupddang.account.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
public class AccountCreateRequest {

    @JsonAlias("id")
    private String userId;
    private String pw;
    private String email;
    private String nickname;
    private String color;
}
