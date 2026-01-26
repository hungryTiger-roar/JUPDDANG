package com.jupddang.jupddang.ranking.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RankingResponseDto {

    private int rank; // 등수 (계산해서 넣어줌)
    private String userId;
    private String nickname;
    private String profileImage;
    private Long score;
    private String tier;
}
