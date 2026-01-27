package com.jupddang.jupddang.trashcan;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.storage.Storage;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.config.EmbeddedRedisConfig;
import com.jupddang.jupddang.raid.service.RaidService;
import com.jupddang.jupddang.security.JwtTokenProvider;
import com.jupddang.jupddang.trashcan.dto.TrashcanCreateRequest;
import com.jupddang.jupddang.trashcan.dto.TrashcanDetailDto;
import com.jupddang.jupddang.trashcan.entity.Trashcan;
import com.jupddang.jupddang.trashcan.entity.TrashcanStatus;
import com.jupddang.jupddang.trashcan.repository.TrashcanRepository;
import com.jupddang.jupddang.trashcan.repository.TrashcanVerificationRepository;
import com.jupddang.jupddang.trashcan.service.TrashcanService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
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
class TrashcanIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;

    @Autowired private TrashcanRepository trashcanRepository;
    @Autowired private TrashcanVerificationRepository verificationRepository;
    @Autowired private AccountRepository accountRepository;
    @Autowired private TrashcanService trashcanService;

    @MockBean private GcsImageService gcsImageService;
    @MockBean private Storage storage;
    @MockBean private RaidService raidService;
    @MockBean private JwtTokenProvider jwtTokenProvider;

    private Account reporter;
    private Account verifier1;
    private Account verifier2;

    @BeforeEach
    void setUp() {
        verificationRepository.deleteAll();
        trashcanRepository.deleteAll();
        accountRepository.deleteAll();

        reporter = createAccount("reporter", "제안자");
        verifier1 = createAccount("verifier1", "검증자1");
        verifier2 = createAccount("verifier2", "검증자2");

        setupJwtMock();
    }

    @AfterEach
    void tearDown() {
        verificationRepository.deleteAll();
        trashcanRepository.deleteAll();
        accountRepository.deleteAll();
    }

    private Account createAccount(String userId, String nickname) {
        return accountRepository.save(Account.builder()
                .userId(userId)
                .email(userId + "@test.com")
                .nickname(nickname)
                .pw("password")
                .color("#000000")
                .score(0)
                .build());
    }

    private void setupJwtMock() {
        given(jwtTokenProvider.validateToken(anyString())).willReturn(true);
        given(jwtTokenProvider.getUserIdFromToken(anyString())).willAnswer(invocation -> invocation.getArgument(0));

        // [NPE 해결] Principal에 실제 Account 객체 주입
        given(jwtTokenProvider.getAuthentication(anyString())).willAnswer(invocation -> {
            String userId = invocation.getArgument(0);
            Account account = accountRepository.findById(userId)
                    .orElse(Account.builder().userId(userId).build());
            return new UsernamePasswordAuthenticationToken(account, "", List.of(new SimpleGrantedAuthority("ROLE_USER")));
        });
    }

    @Test
    @DisplayName("✅ 정상 흐름: 등록 -> 검증(x3) -> 상태 변경(VERIFIED) 확인")
    void lifecycleTest() throws Exception {
        TrashcanCreateRequest req = new TrashcanCreateRequest(37.5, 127.0, "서울 강남구");
        mockMvc.perform(post("/api/v1/trashcans")
                        .header("Authorization", "Bearer " + reporter.getUserId())
                        .header("userId", reporter.getUserId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated());

        Trashcan trashcan = trashcanRepository.findByReportedByOrderByIdDesc(reporter).get(0);
        Long tId = trashcan.getId();

        verifyApi(tId, verifier1, 1);
        verifyApi(tId, verifier2, 2);
        verifyApi(tId, reporter, 3); // 3회 달성 시 VERIFIED 변경

        Trashcan result = trashcanRepository.findById(tId).orElseThrow();
        assertThat(result.getStatus()).isEqualTo(TrashcanStatus.VERIFIED);
    }

    private void verifyApi(Long trashcanId, Account user, int expectedCount) throws Exception {
        mockMvc.perform(post("/api/v1/trashcans/{id}/verify", trashcanId)
                        .header("Authorization", "Bearer " + user.getUserId())
                        .header("userId", user.getUserId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.verificationCount").value(expectedCount));
    }

    @Test
    @DisplayName("🔥 단일 타겟 경쟁: 100명이 동시에 인증 -> 선착순 성공 및 마감 확인")
    void testSingleTargetRaceCondition() throws InterruptedException {
        int userCount = 100;
        ExecutorService executor = Executors.newFixedThreadPool(32);
        CountDownLatch latch = new CountDownLatch(userCount);

        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger rejectedCount = new AtomicInteger(0); // 이미 완료되어 실패한 경우

        TrashcanDetailDto target = trashcanService.createTrashcan(
                new TrashcanCreateRequest(37.5, 127.0, "핫플"), reporter.getUserId());

        for (int i = 0; i < userCount; i++) {
            accountRepository.save(Account.builder().userId("u" + i).email("u" + i + "@t.c").nickname("u" + i).pw("pw").color("#0").score(0).build());
        }

        long start = System.currentTimeMillis();

        for (int i = 0; i < userCount; i++) {
            final int idx = i;
            executor.submit(() -> {
                try {
                    String uId = "u" + idx;
                    mockMvc.perform(post("/api/v1/trashcans/{id}/verify", target.id())
                                    .header("Authorization", "Bearer " + uId)
                                    .header("userId", uId))
                            .andExpect(status().isOk());
                    successCount.incrementAndGet();
                } catch (AssertionError | Exception e) {
                    // 400 Bad Request(이미 인증됨)가 오면 정상적으로 거절된 것임
                    rejectedCount.incrementAndGet();
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await(30, TimeUnit.SECONDS);
        long duration = System.currentTimeMillis() - start;

        log.info("📊 단일 경쟁 결과: 성공={}명, 마감(거절)={}명, 총={}명, 시간={}ms",
                successCount.get(), rejectedCount.get(), successCount.get() + rejectedCount.get(), duration);

        // 검증
        assertThat(successCount.get() + rejectedCount.get()).isEqualTo(userCount);
        // 최소 3명 이상 성공해야 상태가 바뀜
        assertThat(successCount.get()).isGreaterThanOrEqualTo(3);

        Trashcan result = trashcanRepository.findById(target.id()).orElseThrow();
        assertThat(result.getStatus()).isEqualTo(TrashcanStatus.VERIFIED);
        // DB의 카운트는 성공한 사람 수와 정확히 일치해야 함 (Lost Update 방지 확인)
        assertThat(result.getVerificationCount()).isEqualTo(successCount.get());
    }

    @Test
    @DisplayName("🌍 멀티 리전 부하: 10개 지역 동시 인증 -> 분산 처리 및 상태 변경 검증")
    void testMultiRegionConcurrency() throws InterruptedException {
        int regionCount = 10;
        int userCount = 100;
        ExecutorService executor = Executors.newFixedThreadPool(32);
        CountDownLatch latch = new CountDownLatch(userCount);
        AtomicInteger globalSuccess = new AtomicInteger(0);
        AtomicInteger globalReject = new AtomicInteger(0);

        List<Long> trashcanIds = new ArrayList<>();
        for (int i = 0; i < regionCount; i++) {
            // [수정] 위도/경도 범위 안의 값으로 생성 (37.0 ~ 37.9)
            TrashcanDetailDto t = trashcanService.createTrashcan(
                    new TrashcanCreateRequest(37.0 + (i * 0.1), 127.0, "Region-" + i), reporter.getUserId());
            trashcanIds.add(t.id());
        }

        for (int i = 0; i < userCount; i++) {
            accountRepository.save(Account.builder().userId("m" + i).email("m" + i + "@t.c").nickname("m" + i).pw("pw").color("#0").score(0).build());
        }

        for (int i = 0; i < userCount; i++) {
            final int idx = i;
            final Long targetId = trashcanIds.get(idx % regionCount); // 라운드 로빈

            executor.submit(() -> {
                try {
                    String uId = "m" + idx;
                    mockMvc.perform(post("/api/v1/trashcans/{id}/verify", targetId)
                                    .header("Authorization", "Bearer " + uId)
                                    .header("userId", uId))
                            .andExpect(status().isOk());
                    globalSuccess.incrementAndGet();
                } catch (AssertionError | Exception e) {
                    globalReject.incrementAndGet();
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await(30, TimeUnit.SECONDS);

        log.info("🌍 멀티 리전 결과: 성공={}, 마감(거절)={}, 총={}",
                globalSuccess.get(), globalReject.get(), userCount);

        assertThat(globalSuccess.get() + globalReject.get()).isEqualTo(userCount);

        for (Long tId : trashcanIds) {
            Trashcan t = trashcanRepository.findById(tId).orElseThrow();
            assertThat(t.getStatus()).isEqualTo(TrashcanStatus.VERIFIED);
            assertThat(t.getVerificationCount()).isGreaterThanOrEqualTo(3);
        }
    }
}