package com.jupddang.jupddang.account.listener;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;

@Slf4j
@Component
@RequiredArgsConstructor
public class PloggingScoreListener {

    private final AccountRepository accountRepository;
    private final PloggingRepository ploggingRepository;

    /**
     * 플로깅 종료 후 점수 정산
     * AFTER_COMMIT: Plogging 정보가 DB에 커밋된 후 실행
     */
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void handlePloggingCompleted(PloggingCompletedEvent event) {
        log.info("점수 정산 Listener 시작 - user: {}", event.userId());

        try {
            // 1. 상세 정보를 위해 DB 조회 (Event에 없는 distance 등 필요 시)
            Plogging plogging = ploggingRepository.findById(String.valueOf(event.ploggingId()))
                    .orElseThrow(() -> new RuntimeException("Plogging info not found"));

            // 2. 점수 계산 로직
            int distanceScore = (int) (plogging.getDistance() * 100);
            int gridScore = event.occupiedGridCnt() * 500;
            int raidBonus = event.raidScore(); // 레이드 점수도 합산 가능

            int totalScore = distanceScore + gridScore + raidBonus;

            // 3. Account 업데이트 (String userId로 조회)
            Account account = accountRepository.findByUserId(event.userId())
                    .orElseThrow(() -> new RuntimeException("User Account not found: " + event.userId()));

            account.addScore(totalScore);
            // JPA 변경 감지에 의해 트랜잭션 종료 시 update 쿼리 발생 (REQUIRES_NEW가 필요할 수 있음)
            accountRepository.save(account);

            log.info("점수 반영 완료: total={}", totalScore);

        } catch (Exception e) {
            log.error("점수 정산 실패", e);
            // 비동기 처리 시 여기서 예외가 터져도 메인 로직(플로깅 종료)은 롤백되지 않음
        }
    }
}