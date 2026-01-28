package com.jupddang.jupddang.ranking.controller;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRedisRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping; // ★ Post -> Get 변경
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/ranking/test") // ★ 1. 주소 변경! (/test/ranking -> /api/ranking/test)
@RequiredArgsConstructor
@Tag(name = "랭킹 테스트용 API", description = "랭킹 데이터를 Redis에 세팅하는 API")
public class RankingTestController {

    private final AccountRepository accountRepository;
    private final PloggingRedisRepository ploggingRedisRepository;

    @GetMapping("/init") // ★ 2. 방식 변경! (@PostMapping -> @GetMapping, /setup -> /init)
    @Transactional
    @Operation(summary = "랭킹 테스트 데이터 생성", description = "테스트 유저를 생성하고 Redis 랭킹 점수를 초기화합니다.")
    public ResponseEntity<String> setupRankingData() {
        // 1. 테스트용 계정 생성
        setupTestAccounts();

        // 2. 랭킹 데이터 키 정의
        String totalKey = "ranking:total";
        String monthlyKey = String.format("ranking:monthly:%04d%02d", LocalDate.now().getYear(), LocalDate.now().getMonthValue());

        // 3. 기존 랭킹 데이터 삭제
        ploggingRedisRepository.deleteRankingKey(totalKey);
        ploggingRedisRepository.deleteRankingKey(monthlyKey);

        // 4. 테스트 데이터 (userId, totalScore, monthlyScore)
        // ★ 주의: 실제 랭킹 조회할 때 이 아이디(testuser1 등)로 조회해야 나와요!
        Map<String, List<Integer>> testData = Map.of(
                "testuser1", List.of(1500, 500),
                "testuser2", List.of(2200, 800),
                "testuser3", List.of(800, 150),
                "testuser4", List.of(3100, 1200),
                "testuser5", List.of(1800, 700)
        );

        // 5. Redis에 랭킹 데이터 추가
        testData.forEach((userId, scores) -> {
            ploggingRedisRepository.updateRanking(totalKey, userId, scores.get(0));
            ploggingRedisRepository.updateRanking(monthlyKey, userId, scores.get(1));
        });

        return ResponseEntity.ok("랭킹 테스트 데이터 생성 완료! (testuser1~5)");
    }

    private void setupTestAccounts() {
        List<String> userIds = List.of("testuser1", "testuser2", "testuser3", "testuser4", "testuser5");
        for (String userId : userIds) {
            Optional<Account> existingAccount = accountRepository.findByUserId(userId);
            if (existingAccount.isEmpty()) {
                Account account = Account.builder()
                        .userId(userId)
                        .nickname("닉네임_" + userId)
                        .pw("password")
                        .email(userId + "@example.com")
                        .color("#FFFFFF")
                        .build();
                accountRepository.save(account);
            }
        }
    }
}