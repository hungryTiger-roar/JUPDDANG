package com.jupddang.jupddang.raid.service;

import com.jupddang.jupddang.raid.entity.RaidBoss;
import com.jupddang.jupddang.raid.repository.RaidBossRepository;
import com.jupddang.jupddang.raid.repository.RaidRecordRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 레이드 보스 관리 서비스 (관리자 전용)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RaidAdminService {

    private final RaidBossRepository bossRepository;
    private final RaidRecordRepository recordRepository;

    /**
     * 레이드 보스 생성
     */
    @Transactional
    public Long createBoss(String h3Index, String name) {
        // 중복 체크
        if (bossRepository.findByH3Index(h3Index).isPresent()) {
            throw new IllegalArgumentException("이미 해당 위치에 보스가 존재합니다: " + h3Index);
        }

        RaidBoss boss = RaidBoss.builder()
                .h3Index(h3Index)
                .name(name)
                .build();

        RaidBoss saved = bossRepository.save(boss);

        log.info("✅ 레이드 보스 생성: id={}, name={}, h3Index={}",
                saved.getId(), saved.getName(), saved.getH3Index());

        return saved.getId();
    }

    /**
     * 레이드 보스 삭제 (관련 기록도 함께 삭제)
     */
    @Transactional
    public void deleteBoss(Long bossId) {
        RaidBoss boss = bossRepository.findById(bossId)
                .orElseThrow(() -> new IllegalArgumentException("보스를 찾을 수 없습니다: " + bossId));

        // 1. 관련 기록 먼저 삭제
        int recordCount = recordRepository.deleteByRaidBossId(bossId);
        log.info("🗑️ 보스 기록 삭제: {}개", recordCount);

        // 2. 보스 삭제
        bossRepository.delete(boss);
        log.info("✅ 레이드 보스 삭제 완료: id={}, name={}", bossId, boss.getName());
    }

    /**
     * 모든 레이드 보스 삭제 (테스트용)
     */
    @Transactional
    public int deleteAllBosses() {
        // 1. 모든 기록 삭제
        recordRepository.deleteAll();
        log.info("🗑️ 모든 레이드 기록 삭제");

        // 2. 모든 보스 삭제
        long count = bossRepository.count();
        bossRepository.deleteAll();
        log.warn("⚠️ 모든 레이드 보스 삭제: {}개", count);

        return (int) count;
    }

    /**
     * 특정 보스의 모든 기록 초기화
     */
    @Transactional
    public int clearBossRecords(Long bossId) {
        // 보스 존재 확인
        if (!bossRepository.existsById(bossId)) {
            throw new IllegalArgumentException("보스를 찾을 수 없습니다: " + bossId);
        }

        int deletedCount = recordRepository.deleteByRaidBossId(bossId);
        log.info("🔄 보스 기록 초기화: bossId={}, 삭제된 기록={}개", bossId, deletedCount);

        return deletedCount;
    }
}
