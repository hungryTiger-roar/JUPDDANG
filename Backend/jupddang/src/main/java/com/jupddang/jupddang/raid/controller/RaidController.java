package com.jupddang.jupddang.raid.controller;

import com.jupddang.jupddang.raid.dto.RaidBossResponse;
import com.jupddang.jupddang.raid.dto.RaidGroupInfoResponse;
import com.jupddang.jupddang.raid.service.RaidService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/raids")
@RequiredArgsConstructor
public class RaidController {

    private final RaidService raidService;

    @GetMapping
    @Operation(summary = "전체 구역 마커 위치 조회")
    public ResponseEntity<List<RaidBossResponse>> getAllBosses() {
        return ResponseEntity.ok(raidService.getAllBosses());
    }

    @GetMapping("/{bossId}/detail")
    @Operation(summary = "특정 구역 누적 현황 및 랭킹 조회")
    public ResponseEntity<RaidGroupInfoResponse> getBossDetail(
            @PathVariable("bossId") Long bossId,
            @RequestParam(value = "userId", required = false) String userId) {
        return ResponseEntity.ok(raidService.getBossDetail(bossId, userId));
    }
}