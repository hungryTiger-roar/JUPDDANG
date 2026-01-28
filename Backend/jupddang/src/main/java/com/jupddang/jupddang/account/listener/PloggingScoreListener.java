package com.jupddang.jupddang.account.listener;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

@Slf4j
@Component
@RequiredArgsConstructor
public class PloggingScoreListener {

    private final PloggingRepository ploggingRepository;
    private final AccountRepository accountRepository; // save를 위해 필요

    /**
     * 플로깅 종료 후 점수 정산 및 티어 업데이트
     * AFTER_COMMIT: Plogging 저장이 확실히 끝난 후 실행
     */
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    @Transactional(propagation = Propagation.REQUIRES_NEW) // 새 트랜잭션으로 Account 업데이트 보장
    public void handlePloggingCompleted(PloggingCompletedEvent event) {
        log.info("🎯 점수 정산 시작 - ploggingId: {}, userId: {}", event.ploggingId(), event.userId());

        try {
            // 1. Plogging 조회 (Long ID 사용)
            Plogging plogging = ploggingRepository.findById(event.ploggingId())
                    .orElseThrow(() -> new RuntimeException("Plogging info not found: " + event.ploggingId()));


            // 2. Account 조회 (Plogging 엔티티의 연관관계 활용)
            // FetchType.LAZY여도 @Transactional 안이므로 접근 가능
            Account account = plogging.getAccount();

            if (account == null) {
                throw new RuntimeException("Plogging record has no associated account.");
            }

            // 3. 점수 계산 로직
            // 거리 점수: 1km당 100점 (예시)
            int distanceScore = (int) (plogging.getDistance() * 100);

            // 그리드 점수: 점유한 땅 개수 * 500점
            int gridScore = event.occupiedGridCnt() * 500;

            // 레이드 점수: 이벤트에서 전달받은 기여도 점수
            int raidBonus = event.raidScore();

            int totalAddedScore = distanceScore + gridScore + raidBonus;

            // 4. Account 업데이트 (점수 누적 & 티어 갱신)
            account.addScore(totalAddedScore);

            // 명시적 저장 (Dirty Checking이 리스너 트랜잭션 범위에 따라 안 될 수도 있어서 안전하게 save)
            accountRepository.save(account);

            log.info("✅ 점수 반영 완료: User={}, Added={}, Total={}",
                    account.getNickname(), totalAddedScore, account.getTotalScore());

        } catch (Exception e) {
            log.error("❌ 점수 정산 실패 - ploggingId: {}", event.ploggingId(), e);
            // 필요 시 알림 전송 로직 추가 (사용자에게 "점수 반영 실패" 알림 등)
        }
    }
}