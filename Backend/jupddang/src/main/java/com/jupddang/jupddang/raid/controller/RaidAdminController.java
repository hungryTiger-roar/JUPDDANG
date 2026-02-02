package com.jupddang.jupddang.raid.controller;

import com.jupddang.jupddang.raid.service.RaidAdminService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * 레이드 보스 관리자 컨트롤러
 * - 보스 생성/삭제는 관리자만 가능
 * - 테스트 및 운영 관리용
 */
@Slf4j
@RestController
@RequestMapping("/api/admin/raid")
@RequiredArgsConstructor
@Tag(name = "Raid Admin", description = "레이드 보스 관리 API (관리자 전용)")
public class RaidAdminController {

    private final RaidAdminService raidAdminService;

    /**
     * 레이드 보스 생성
     */
    @PostMapping("/boss")
    @Operation(summary = "레이드 보스 생성", description = "새로운 레이드 보스를 생성합니다")
    public ResponseEntity<String> createBoss(
            @RequestParam String h3Index,
            @RequestParam String name) {
        log.info("🎯 레이드 보스 생성 요청: h3Index={}, name={}", h3Index, name);

        Long bossId = raidAdminService.createBoss(h3Index, name);

        return ResponseEntity.ok("보스 생성 완료: ID=" + bossId);
    }

    /**
     * 레이드 보스 삭제
     */
    @DeleteMapping("/boss/{bossId}")
    @Operation(summary = "레이드 보스 삭제", description = "레이드 보스와 관련 기록을 모두 삭제합니다")
    public ResponseEntity<String> deleteBoss(@PathVariable Long bossId) {
        log.info("🗑️ 레이드 보스 삭제 요청: bossId={}", bossId);

        raidAdminService.deleteBoss(bossId);

        return ResponseEntity.ok("보스 삭제 완료: ID=" + bossId);
    }

    /**
     * 모든 레이드 보스 삭제 (테스트용)
     */
    @DeleteMapping("/boss/all")
    @Operation(summary = "모든 레이드 보스 삭제", description = "⚠️ 모든 레이드 보스와 기록을 삭제합니다 (테스트용)")
    public ResponseEntity<String> deleteAllBosses() {
        log.warn("⚠️ 모든 레이드 보스 삭제 요청");

        int deletedCount = raidAdminService.deleteAllBosses();

        return ResponseEntity.ok("모든 보스 삭제 완료: " + deletedCount + "개");
    }

    /**
     * 특정 보스의 모든 기록 초기화
     */
    @DeleteMapping("/boss/{bossId}/records")
    @Operation(summary = "보스 기록 초기화", description = "특정 보스의 모든 기여도 기록을 삭제합니다")
    public ResponseEntity<String> clearBossRecords(@PathVariable Long bossId) {
        log.info("🔄 보스 기록 초기화 요청: bossId={}", bossId);

        int deletedCount = raidAdminService.clearBossRecords(bossId);

        return ResponseEntity.ok("기록 초기화 완료: " + deletedCount + "개");
    }
}
