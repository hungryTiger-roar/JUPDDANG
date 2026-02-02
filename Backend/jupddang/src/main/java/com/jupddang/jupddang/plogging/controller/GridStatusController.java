package com.jupddang.jupddang.plogging.controller;

import com.jupddang.jupddang.plogging.service.impls.GridStatusService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

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
            // [수정 1] Long -> String 변경 (단순 타입 불일치 해결)
            @RequestHeader("userId") String userId) {
        // Service 메서드가 이제 (String, String)을 받으므로 타입이 일치합니다.
        boolean isClaimable = gridStatusService.checkClaimability(userId, h3Index);
        return ResponseEntity.ok(new GridStatusResponse(h3Index, isClaimable));
    }

    public record GridStatusResponse(String h3Index, boolean isClaimable) {
    }

    @GetMapping("/all")
    public ResponseEntity<java.util.List<com.jupddang.jupddang.plogging.domain.Grids>> getAllGrids() {
        return ResponseEntity.ok(gridStatusService.getAllGrids());
    }
}
