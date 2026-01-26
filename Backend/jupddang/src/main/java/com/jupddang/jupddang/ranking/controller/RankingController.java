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

    // 1. 전체(누적) 랭킹 조회 API
    // URL: /api/ranking/total?userId=...
    @GetMapping("/total")
    public ResponseEntity<RankingListResponseDto> getTotalRanking(
            @RequestParam String userId // 시큐리티 없이 직접 받기
    ) {
        // 서비스에 "TOTAL"이라고 명확하게 넘겨줌
        RankingListResponseDto response = rankingService.getRankingList("TOTAL", userId);
        return ResponseEntity.ok(response);
    }

    // 2. 월간 랭킹 조회 API
    // URL: /api/ranking/monthly?userId=...
    @GetMapping("/monthly")
    public ResponseEntity<RankingListResponseDto> getMonthlyRanking(
            @RequestParam String userId // 시큐리티 없이 직접 받기
    ) {
        // 서비스에 "MONTHLY"라고 명확하게 넘겨줌
        RankingListResponseDto response = rankingService.getRankingList("MONTHLY", userId);
        return ResponseEntity.ok(response);
    }
}