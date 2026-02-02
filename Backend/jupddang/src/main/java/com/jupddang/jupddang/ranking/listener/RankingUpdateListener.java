package com.jupddang.jupddang.ranking.listener;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.ranking.repository.RankingRedisRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

import java.time.LocalDate;

/**
 * 랭킹 업데이트 리스너
 * - 플로깅 종료 후 Redis 랭킹 실시간 업데이트
 * - PloggingScoreListener 이후 실행 (Account.totalScore 업데이트 완료 후)
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class RankingUpdateListener {

    private final RankingRedisRepository rankingRedisRepository;
    private final AccountRepository accountRepository;

    /**
     * 플로깅 종료 후 Redis 랭킹 업데이트
     * PloggingScoreListener 이후 실행 (Account.totalScore 업데이트 완료 후)
     */
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void updateRanking(PloggingCompletedEvent event) {
        log.info("📊 랭킹 업데이트 시작 - userId: {}", event.userId());

        try {
            // Account에서 최신 totalScore 조회
            Account account = accountRepository.findById(event.userId())
                    .orElseThrow(() -> new RuntimeException("Account not found: " + event.userId()));

            // 월간 랭킹 키 생성
            String monthlyKey = String.format("ranking:monthly:%04d%02d",
                    LocalDate.now().getYear(),
                    LocalDate.now().getMonthValue());

            // Redis 랭킹 업데이트
            // - totalScore: Account의 누적 총점
            // - monthlyScore: 이번 플로깅에서 획득한 점수 (플로깅 점수 + 레이드 점수)
            int totalAddedScore = event.ploggingScore() + event.raidScore();

            rankingRedisRepository.updateRankScore(
                    event.userId(),
                    account.getTotalScore(), // 누적 총점
                    monthlyKey,
                    totalAddedScore // 이번 플로깅 점수
            );

            log.info("✅ 랭킹 업데이트 완료: User={}, TotalScore={}, MonthlyAdded={}",
                    event.userId(), account.getTotalScore(), totalAddedScore);

        } catch (Exception e) {
            log.error("❌ 랭킹 업데이트 실패 - userId: {}", event.userId(), e);
            // Redis 실패는 치명적이지 않으므로 예외를 던지지 않음
            // 랭킹 조회 시 DB에서 재구성 가능
        }
    }
}
