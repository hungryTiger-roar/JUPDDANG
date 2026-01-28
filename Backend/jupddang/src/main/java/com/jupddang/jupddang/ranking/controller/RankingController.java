package com.jupddang.jupddang.ranking.controller;

import com.jupddang.jupddang.ranking.dto.RankingListResponseDto;
import com.jupddang.jupddang.ranking.service.RankingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/ranking")
@RequiredArgsConstructor
public class RankingController {

    private final RankingService rankingService;

    /**
     * 전체(누적) 랭킹 조회
     * @param userId 사용자 ID
     * @return 랭킹 리스트 (Top 3 + 내 주변)
     */
    @GetMapping("/total")
    public ResponseEntity<RankingListResponseDto> getTotalRanking(
            @RequestParam("userId") String userId
    ) {
        RankingListResponseDto response = rankingService.getTotalRanking(userId);
        return ResponseEntity.ok(response);
    }

    /**
     * 월간 랭킹 조회
     * @param year 년도 (선택)
     * @param month 월 (선택)
     * @param userId 사용자 ID
     * @return 랭킹 리스트 (Top 3 + 내 주변)
     */
    @GetMapping("/monthly")
    public ResponseEntity<RankingListResponseDto> getMonthlyRanking(
            @RequestParam(value = "year", required = false) Integer year,
            @RequestParam(value = "month", required = false) Integer month,
            @RequestParam("userId") String userId
    ) {
        RankingListResponseDto response = rankingService.getMonthlyRanking(year, month, userId);
        return ResponseEntity.ok(response);
    }
}
