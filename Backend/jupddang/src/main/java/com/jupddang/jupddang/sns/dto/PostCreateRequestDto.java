package com.jupddang.jupddang.sns.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class PostCreateRequestDto {
    private String userId;
    private String content;
    private String beforeImageUrl;
    private String afterImageUrl;
    private String mapImageUrl;
}
