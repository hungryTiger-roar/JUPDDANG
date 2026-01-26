package com.jupddang.jupddang.plogging.controller;

import com.jupddang.jupddang.plogging.service.impls.GridStatusService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/plogging/grid")
@RequiredArgsConstructor
public class GridStatusController {

    private final GridStatusService gridStatusService;

    /**
     * 하트비트: 현재 위치의 땅 점령 가능 여부 확인
     * Front: 1분 주기 or H3 인덱스 변경 시 호출
     */
    @GetMapping("/status")
    public ResponseEntity<GridStatusResponse> checkGridStatus(
            @RequestParam String h3Index,
            @RequestHeader("userId") Long userId
    ) {
        boolean isClaimable = gridStatusService.checkClaimability(userId, h3Index);
        return ResponseEntity.ok(new GridStatusResponse(h3Index, isClaimable));
    }

    public record GridStatusResponse(String h3Index, boolean isClaimable) {}
}
