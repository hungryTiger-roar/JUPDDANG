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
    private List<RankingResponseDto> topRankings; // 1등부터 설정한 등수까지 리스트
    private RankingResponseDto myRanking; // 내 등수
}