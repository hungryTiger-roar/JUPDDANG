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

    // 1. 전체(누적) 랭킹 조회
    // 예: /api/ranking/total?page=0&size=20&userId=test
    @GetMapping("/total")
    public ResponseEntity<RankingListResponseDto> getTotalRanking(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam String userId
    ) {
        RankingListResponseDto response = rankingService.getTotalRanking(page, size, userId);
        return ResponseEntity.ok(response);
    }

    // 2. 월간 랭킹 조회
    // 예: /api/ranking/monthly?userId=test (자동으로 이번 달)
    // 예: /api/ranking/monthly?year=2025&month=12&userId=test (특정 달)
    @GetMapping("/monthly")
    public ResponseEntity<RankingListResponseDto> getMonthlyRanking(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            @RequestParam String userId
    ) {
        RankingListResponseDto response = rankingService.getMonthlyRanking(year, month, userId);
        return ResponseEntity.ok(response);
    }
}