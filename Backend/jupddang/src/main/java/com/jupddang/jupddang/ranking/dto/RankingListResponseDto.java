package com.jupddang.jupddang.ranking.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RankingListResponseDto {
    // 상단에 고정으로 보여줄 1,2,3등
    private List<RankingResponseDto> topRankers;
    // 하단에 보여줄 내 주변 랭킹 (나 ± 2명)
    private List<RankingResponseDto> myRankWindow; // 내 등수
}