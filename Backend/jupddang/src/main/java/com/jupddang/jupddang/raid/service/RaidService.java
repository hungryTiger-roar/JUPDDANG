package com.jupddang.jupddang.raid.service;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.raid.dto.RaidBossResponse;
import com.jupddang.jupddang.raid.dto.RaidGroupInfoResponse;
import com.jupddang.jupddang.raid.entity.RaidBoss;
import com.jupddang.jupddang.raid.entity.RaidRecord;
import com.jupddang.jupddang.raid.repository.RaidBossRepository;
import com.jupddang.jupddang.raid.repository.RaidRecordRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
public class RaidService {

    private final RaidBossRepository bossRepository;
    private final RaidRecordRepository recordRepository;
    private final AccountRepository accountRepository;

    private static final int SCORE_PER_VISIT = 500; // 방문당 점수

    // 1. 지도용 (가볍게)
    @Transactional(readOnly = true)
    public List<RaidBossResponse> getAllBosses() {
        return bossRepository.findAll().stream()
                .map(RaidBossResponse::from)
                .collect(Collectors.toList());
    }

    // 2. 상세 조회 (누적 합계 + 랭킹)
    @Transactional(readOnly = true)
    public RaidGroupInfoResponse getBossDetail(Long bossId) {
        RaidBoss boss = bossRepository.findById(bossId)
                .orElseThrow(() -> new IllegalArgumentException("Target zone not found"));

        // A. 이 구역의 총 정화량 계산 (SUM)
        long totalScore = recordRepository.sumTotalScoreByBossId(bossId);

        // B. 랭킹 조회 (Top 10)
        List<RaidRecord> topRecords = recordRepository.findTopRankers(bossId, PageRequest.of(0, 10));

        List<RaidGroupInfoResponse.RankInfo> rankInfos = topRecords.stream()
                .map(record -> RaidGroupInfoResponse.RankInfo.builder()
                        .rank(topRecords.indexOf(record) + 1) // 0부터 시작하므로 +1
                        .nickname(record.getAccount().getNickname())
                        .score(record.getTotalScore())
                        .build())
                .collect(Collectors.toList());

        return RaidGroupInfoResponse.builder()
                .bossId(boss.getId())
                .bossName(boss.getName())
                .totalAccumulatedScore(totalScore) // 누적 점수 반환
                .topRankers(rankInfos)
                .build();
    }

    // 3. 점수 반영 로직 (PloggingService에서 호출)
    @Transactional
    public int applyRaidScore(String userId, Set<String> visitedH3Indices) {
        if (visitedH3Indices == null || visitedH3Indices.isEmpty()) return 0;

        List<RaidBoss> targets = bossRepository.findAll().stream()
                .filter(boss -> visitedH3Indices.contains(boss.getH3Index()))
                .collect(Collectors.toList());

        if (targets.isEmpty()) return 0;

        Account account = accountRepository.getReferenceById(userId);
        int totalScoreAdded = 0;

        for (RaidBoss boss : targets) {
            // Write-Optimization: Boss 테이블 건드리지 않고 Record만 업데이트
            int updated = recordRepository.addDamage(boss.getId(), userId, SCORE_PER_VISIT);

            if (updated == 0) {
                recordRepository.save(RaidRecord.builder()
                        .raidBoss(boss)
                        .account(account)
                        .totalScore(SCORE_PER_VISIT)
                        .build());
            }
            totalScoreAdded += SCORE_PER_VISIT;
        }
        return totalScoreAdded;
    }
}