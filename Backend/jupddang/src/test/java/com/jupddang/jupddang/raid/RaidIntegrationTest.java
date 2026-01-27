package com.jupddang.jupddang.raid;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.storage.Storage;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.config.EmbeddedRedisConfig;
import com.jupddang.jupddang.raid.entity.RaidBoss;
import com.jupddang.jupddang.raid.entity.RaidRecord;
import com.jupddang.jupddang.raid.repository.RaidBossRepository;
import com.jupddang.jupddang.raid.repository.RaidRecordRepository;
import com.jupddang.jupddang.raid.service.RaidService;
import com.jupddang.jupddang.security.JwtTokenProvider;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@Slf4j
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Import(EmbeddedRedisConfig.class)
@TestPropertySource(properties = {
        "spring.cloud.gcp.core.enabled=false",
        "spring.cloud.gcp.storage.enabled=false",
        "spring.cloud.gcp.credentials.location=classpath:non-existent.json",
        "logging.level.org.hibernate.SQL=OFF",
        "spring.jpa.show-sql=false",
        "spring.data.redis.port=6379",
        "spring.data.redis.host=localhost"
})
class RaidIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private RaidService raidService;
    @Autowired private RaidBossRepository bossRepository;
    @Autowired private RaidRecordRepository recordRepository;
    @Autowired private AccountRepository accountRepository;

    @MockBean private GcsImageService gcsImageService;
    @MockBean private Storage storage;

    // [핵심] JWT Mocking (401 해결)
    @MockBean private JwtTokenProvider jwtTokenProvider;

    private RaidBoss bossSeoul;
    private Account user1;
    private Account user2;

    @BeforeEach
    void setUp() {
        // 데이터 초기화
        recordRepository.deleteAll();
        bossRepository.deleteAll();
        accountRepository.deleteAll();

        // 보스 생성
        bossSeoul = bossRepository.save(RaidBoss.builder()
                .h3Index("8930e128077ffff")
                .name("강남역 9번출구")
                .build());

        // 유저 생성
        user1 = accountRepository.save(Account.builder()
                .userId("user1").email("u1@test.com").nickname("지존파")
                .pw("pw").color("#FF0000").score(0).build());

        user2 = accountRepository.save(Account.builder()
                .userId("user2").email("u2@test.com").nickname("환경지킴이")
                .pw("pw").color("#00FF00").score(0).build());

        // [핵심] JWT 설정 호출
        setupJwtMock();
    }

    private void setupJwtMock() {
        given(jwtTokenProvider.validateToken(anyString())).willReturn(true);
        given(jwtTokenProvider.getUserIdFromToken(anyString())).willAnswer(invocation -> invocation.getArgument(0));
        given(jwtTokenProvider.getAuthentication(anyString())).willAnswer(invocation -> {
            String userId = invocation.getArgument(0);
            return new UsernamePasswordAuthenticationToken(
                    userId, "", List.of(new SimpleGrantedAuthority("ROLE_USER"))
            );
        });
    }

    // -------------------------------------------------------------------------
    // 1. 일반 통합 테스트 시나리오 (Happy Path)
    // -------------------------------------------------------------------------

    @Test
    @DisplayName("✅ 정상: 전체 구역 조회 (Read)")
    void getAllBosses_Success() throws Exception {
        mockMvc.perform(get("/api/raids")
                        // [핵심] 헤더 추가! (Security Filter 통과용)
                        .header("Authorization", "Bearer " + user1.getUserId()))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].name").exists());
    }

    @Test
    @DisplayName("✅ 상세 조회: 누적 점수 합계 및 랭킹 산정 (Aggregation)")
    void getBossDetail_Ranking() throws Exception {
        // given: 데이터 쌓기
        raidService.applyRaidScore(user1.getUserId(), Set.of(bossSeoul.getH3Index())); // 500
        raidService.applyRaidScore(user1.getUserId(), Set.of(bossSeoul.getH3Index())); // 1000
        raidService.applyRaidScore(user2.getUserId(), Set.of(bossSeoul.getH3Index())); // 500 (user2)

        // when: API 호출
        mockMvc.perform(get("/api/raids/{bossId}/detail", bossSeoul.getId())
                        // [핵심] 헤더 추가
                        .header("Authorization", "Bearer " + user1.getUserId()))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.bossName").value("강남역 9번출구"))
                .andExpect(jsonPath("$.totalAccumulatedScore").value(1500))
                // 랭킹 검증
                .andExpect(jsonPath("$.topRankers[0].nickname").value("지존파")) // 1등 (1000점)
                .andExpect(jsonPath("$.topRankers[0].score").value(1000))
                .andExpect(jsonPath("$.topRankers[1].nickname").value("환경지킴이")); // 2등 (500점)
    }

    @Test
    @DisplayName("✅ 점수 반영 로직: Insert & Update 검증 (Write)")
    void applyRaidScore_LogicCheck() {
        // given
        Set<String> visited = Set.of(bossSeoul.getH3Index());

        // when 1: 첫 방문
        int score1 = raidService.applyRaidScore(user1.getUserId(), visited);
        assertThat(score1).isEqualTo(500);

        // when 2: 재방문
        int score2 = raidService.applyRaidScore(user1.getUserId(), visited);
        assertThat(score2).isEqualTo(500);

        // then: DB 누적 확인
        RaidRecord record = recordRepository.findByRaidBossAndAccount(bossSeoul, user1).orElseThrow();
        assertThat(record.getTotalScore()).isEqualTo(1000);
    }

    // -------------------------------------------------------------------------
    // 2. 엣지 케이스 (Edge Cases)
    // -------------------------------------------------------------------------

    @Test
    @DisplayName("⚠️ 엣지: 존재하지 않는 보스 조회 -> 4xx 에러")
    void getBossDetail_NotFound() throws Exception {
        mockMvc.perform(get("/api/raids/{bossId}/detail", 999999L)
                        .header("Authorization", "Bearer " + user1.getUserId()))
                .andExpect(status().is4xxClientError());
    }

    @Test
    @DisplayName("⚠️ 엣지: 빈 방문 리스트 -> 0점")
    void applyRaidScore_Empty() {
        int score = raidService.applyRaidScore(user1.getUserId(), Collections.emptySet());
        assertThat(score).isEqualTo(0);
    }

    // -------------------------------------------------------------------------
    // 3. 동시성 테스트 (Concurrency)
    // -------------------------------------------------------------------------

    @Test
    @DisplayName("🔥 부하: 100명이 동시에 강남역 공격")
    void test100UsersAttackSameBoss() throws InterruptedException {
        int userCount = 100;
        ExecutorService executor = Executors.newFixedThreadPool(20);
        CountDownLatch latch = new CountDownLatch(userCount);
        AtomicInteger successCount = new AtomicInteger(0);

        // 유저 생성
        for (int i = 0; i < userCount; i++) {
            accountRepository.save(Account.builder()
                    .userId("attacker" + i)
                    .email("a" + i + "@test.com")
                    .nickname("용사" + i)
                    .pw("pw").color("#000000").score(0)
                    .build());
        }

        long start = System.currentTimeMillis();

        for (int i = 0; i < userCount; i++) {
            final int index = i;
            executor.submit(() -> {
                try {
                    String userId = "attacker" + index;
                    // Service 직접 호출 (Controller 거치지 않음 -> 401 걱정 없음)
                    int score = raidService.applyRaidScore(userId, Set.of(bossSeoul.getH3Index()));
                    if (score == 500) successCount.incrementAndGet();
                } catch (Exception e) {
                    log.error("Error", e);
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await(30, TimeUnit.SECONDS);
        long duration = System.currentTimeMillis() - start;

        log.info("📊 100명 공격 결과: 성공={}, 시간={}ms", successCount.get(), duration);

        assertThat(successCount.get()).isEqualTo(userCount);
        assertThat(recordRepository.count()).isEqualTo(userCount);
    }
}