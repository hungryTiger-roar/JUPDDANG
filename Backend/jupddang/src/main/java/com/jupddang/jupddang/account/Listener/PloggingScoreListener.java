package com.jupddang.jupddang.account.Listener;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Component
@RequiredArgsConstructor
public class PloggingScoreListener {

    private final AccountRepository accountRepository;
    private final PloggingRepository ploggingRepository;

    @EventListener
    @Transactional
    public void handlePloggingCompleted(PloggingCompletedEvent event) {
        // 1. 점수 계산을 위해 저장된 플로깅 정보 조회
        // (Event 객체에 distance/times가 없어서 DB 조회를 이용하는 방식)
        Plogging plogging = ploggingRepository.findById(event.getPloggingId())
                .orElseThrow(() -> new RuntimeException("Plogging info not found"));

        // 2. 점수 계산 (임시 로직 - 팀원 로직이 들어올 자리)
        // 거리(km) * 100 + 점령수 * 500
        int distanceScore = (int) (plogging.getDistance() * 100);
        int gridScore = event.getOccupiedGridCnt() * 500;
        int totalScore = distanceScore + gridScore;

        log.info("점수 정산: user={} distance={} grid={} total={}",
                event.getUserId(), plogging.getDistance(), event.getOccupiedGridCnt(), totalScore);

        // 3. Account 점수 반영
        // PloggingService에서는 Long userId를 쓰지만, Account는 String userId를 쓰므로 변환 주의
        Account account = accountRepository.findByUserId(event.getUserId())
                .orElseThrow(() -> new RuntimeException("User Account not found"));

        account.addScore(totalScore);
    }
}