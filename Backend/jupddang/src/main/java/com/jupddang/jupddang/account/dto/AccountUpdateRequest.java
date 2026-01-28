package com.jupddang.jupddang.account.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
public class AccountUpdateRequest {

    private String pw;
    private String nickname;
    private String intro;
    private String email;
    private String color;
}
