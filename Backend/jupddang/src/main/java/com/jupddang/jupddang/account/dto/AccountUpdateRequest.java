package com.jupddang.jupddang.account.dto;

import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class AccountUpdateRequest {

    private String pw;
    private String nickname;
    private String profileImage;
    private String intro;
    private String region;
    private String email;
    private String color;

}
