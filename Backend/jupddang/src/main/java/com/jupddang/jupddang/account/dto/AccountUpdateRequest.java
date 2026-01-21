package com.jupddang.jupddang.account.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class AccountUpdateRequest {

    private String pw;
    private String name;
    private String email;
    private String address;

}
