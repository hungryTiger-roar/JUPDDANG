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
import org.springframework.data.domain.Pageable;
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
        public RaidGroupInfoResponse getBossDetail(Long bossId, String userId) {
                RaidBoss boss = bossRepository.findById(bossId)
                                .orElseThrow(() -> new IllegalArgumentException("Target zone not found"));

                // A. 이 구역의 총 정화량 계산 (SUM)
                long totalScore = recordRepository.sumTotalScoreByBossId(bossId);

                // B. 전체 랭킹 조회 (모든 참여자)
                List<RaidRecord> allRecords = recordRepository.findTopRankers(bossId, Pageable.unpaged());

                // C. Top 10 랭커 추출
                List<RaidGroupInfoResponse.RankInfo> topRankers = allRecords.stream()
                                .limit(10)
                                .map(record -> RaidGroupInfoResponse.RankInfo.builder()
                                                .rank(allRecords.indexOf(record) + 1)
                                                .nickname(record.getAccount().getNickname())
                                                .tier(record.getAccount().getTier())
                                                .score(record.getTotalScore())
                                                .userId(record.getAccount().getUserId())
                                                .build())
                                .collect(Collectors.toList());

                // D. 본인 랭킹 및 주변 랭커 계산
                RaidGroupInfoResponse.RankInfo myRanking = null;
                List<RaidGroupInfoResponse.RankInfo> nearbyRankers = new ArrayList<>();

                if (userId != null) {
                        // 본인 레코드 찾기
                        int myIndex = -1;
                        for (int i = 0; i < allRecords.size(); i++) {
                                if (allRecords.get(i).getAccount().getUserId().equals(userId)) {
                                        myIndex = i;
                                        break;
                                }
                        }

                        if (myIndex >= 0) {
                                // 본인 랭킹 정보
                                RaidRecord myRecord = allRecords.get(myIndex);
                                myRanking = RaidGroupInfoResponse.RankInfo.builder()
                                                .rank(myIndex + 1)
                                                .nickname(myRecord.getAccount().getNickname())
                                                .tier(myRecord.getAccount().getTier())
                                                .score(myRecord.getTotalScore())
                                                .userId(myRecord.getAccount().getUserId())
                                                .build();

                                // 본인 ± 2명 추출 (총 5명)
                                int startIndex = Math.max(0, myIndex - 2);
                                int endIndex = Math.min(allRecords.size(), myIndex + 3);

                                nearbyRankers = allRecords.subList(startIndex, endIndex).stream()
                                                .map(record -> RaidGroupInfoResponse.RankInfo.builder()
                                                                .rank(allRecords.indexOf(record) + 1)
                                                                .nickname(record.getAccount().getNickname())
                                                                .tier(record.getAccount().getTier())
                                                                .score(record.getTotalScore())
                                                                .userId(record.getAccount().getUserId())
                                                                .build())
                                                .collect(Collectors.toList());
                        }
                }

                return RaidGroupInfoResponse.builder()
                                .bossId(boss.getId())
                                .bossName(boss.getName())
                                .totalAccumulatedScore(totalScore)
                                .topRankers(topRankers)
                                .myRanking(myRanking)
                                .nearbyRankers(nearbyRankers)
                                .build();
        }

        // 3. 점수 반영 로직 (PloggingService에서 호출)
        @Transactional
        public int applyRaidScore(String userId, Set<String> visitedH3Indices) {
                if (visitedH3Indices == null || visitedH3Indices.isEmpty())
                        return 0;

                List<RaidBoss> targets = bossRepository.findAll().stream()
                                .filter(boss -> visitedH3Indices.contains(boss.getH3Index()))
                                .collect(Collectors.toList());

                if (targets.isEmpty())
                        return 0;

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