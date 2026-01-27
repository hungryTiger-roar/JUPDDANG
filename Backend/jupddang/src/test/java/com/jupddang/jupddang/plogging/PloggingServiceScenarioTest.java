package com.jupddang.jupddang.plogging;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.repository.GridRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRedisRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.plogging.service.impls.PloggingServiceImpl;
import com.jupddang.jupddang.raid.service.RaidService;
import com.uber.h3core.H3Core;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.mock.web.MockMultipartFile;

import java.io.IOException;
import java.time.Duration;
import java.time.Instant;
import java.util.Collections;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.*;

@Slf4j
@ExtendWith(MockitoExtension.class)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class PloggingServiceScenarioTest {

    @InjectMocks
    private PloggingServiceImpl ploggingService;

    @Mock private PloggingRepository ploggingRepository;
    @Mock private PloggingRedisRepository redisRepository;
    @Mock private GridRepository gridRepository;
    @Mock private AccountRepository accountRepository;
    @Mock private ApplicationEventPublisher eventPublisher;
    @Mock private SimpMessagingTemplate messagingTemplate;
    @Mock private H3Core h3Core;
    @Mock private RaidService raidService;

    private final String USER_ID_A = "100";
    private final String MOCK_H3_INDEX_1 = "8928308280fffff";
    private final String MOCK_H3_INDEX_2 = "8928308281fffff";
    private final String MOCK_H3_INDEX_3 = "8928308282fffff";
    private final double LAT = 37.5;
    private final double LON = 127.0;

    private Instant testStartTime;

    @BeforeEach
    void setUp() throws IOException {
        testStartTime = Instant.now();
        log.info("=".repeat(80));
        log.info("테스트 시작 시각: {}", testStartTime);

        lenient().when(h3Core.latLngToCellAddress(anyDouble(), anyDouble(), anyInt()))
                .thenReturn(MOCK_H3_INDEX_1);
    }

    @AfterEach
    void tearDown() {
        Instant testEndTime = Instant.now();
        Duration duration = Duration.between(testStartTime, testEndTime);
        log.info("테스트 종료 시각: {}", testEndTime);
        log.info("테스트 실행 시간: {}ms", duration.toMillis());
        log.info("=".repeat(80));
    }

    @Test
    @Order(1)
    @DisplayName("Scenario 5: 플로깅 종료 시 DB 저장, 레이드 정산, 이벤트 발행, Redis 정리 수행")
    void testEndPlogging() {
        log.info(">>> [Scenario 5] 플로깅 종료 통합 테스트 시작");
        Instant stepStart = Instant.now();

        // given
        log.info("[GIVEN] Mock 데이터 준비 중...");
        PloggingEndRequest request = new PloggingEndRequest(
                null, 5.0, Collections.emptyList(), Collections.emptyList(), 3600
        );
        MockMultipartFile image = new MockMultipartFile("img", "test.jpg", "image/jpeg", "byte".getBytes());

        // 1. Account Mocking
        Account mockAccount = Account.builder()
                .userId(USER_ID_A)
                .nickname("TestUser")
                .build();
        given(accountRepository.getReferenceById(USER_ID_A)).willReturn(mockAccount);

        // 2. Plogging Save Mocking
        Plogging savedPlogging = Plogging.builder()
                .id(999L)
                .account(mockAccount)
                .distance(5.0)
                .times(3600)
                .score(0)
                .build();
        given(ploggingRepository.save(any(Plogging.class))).willReturn(savedPlogging);

        // 3. Redis Mocking
        Set<String> capturedGrids = Set.of(MOCK_H3_INDEX_1, MOCK_H3_INDEX_2, MOCK_H3_INDEX_3);
        given(redisRepository.getCapturedGrids(USER_ID_A)).willReturn(capturedGrids);
        log.info("  - 점령 그리드 수: {}", capturedGrids.size());

        // 4. RaidService Mocking
        given(raidService.applyRaidScore(eq(USER_ID_A), anySet())).willReturn(500);

        // when
        log.info("[WHEN] endPlogging 메서드 실행...");
        PloggingResultResponse response = ploggingService.endPlogging(USER_ID_A, request, image, image, image);

        // then
        log.info("[THEN] 검증 시작...");

        verify(accountRepository).getReferenceById(USER_ID_A);
        verify(ploggingRepository).save(any(Plogging.class));
        verify(eventPublisher).publishEvent(any(PloggingCompletedEvent.class));
        verify(raidService).applyRaidScore(eq(USER_ID_A), anySet());
        verify(redisRepository).deleteUserState(USER_ID_A);

        // [수정 완료] Record 타입이므로 getter 없이 필드명()으로 호출
        log.info("  ✓ 응답 데이터 검증: raidScore={}, occupiedGridCnt={}",
                response.raidScore(), response.occupiedGridCnt());

        assertThat(response.raidScore()).isEqualTo(500);       // .getRaidScore() (X) -> .raidScore() (O)
        assertThat(response.occupiedGridCnt()).isEqualTo(3);   // .getOccupiedGridCnt() (X) -> .occupiedGridCnt() (O)

        Duration totalTime = Duration.between(stepStart, Instant.now());
        log.info(">>> [Scenario 5] 테스트 완료 (총 {}ms)", totalTime.toMillis());
    }

    @Test
    @Order(2)
    @DisplayName("Scenario 6: [부하 테스트] 사용자 100명 동시 요청")
    void testConcurrency100Users() throws InterruptedException {
        log.info(">>> [Scenario 6] 동시성 테스트 시작");

        int userCount = 100;
        ExecutorService executorService = Executors.newFixedThreadPool(32);
        CountDownLatch latch = new CountDownLatch(userCount);
        AtomicInteger successCount = new AtomicInteger();
        AtomicInteger failCount = new AtomicInteger();

        given(redisRepository.getUserState(anyString())).willReturn(null);

        Instant concurrencyStart = Instant.now();

        for (int i = 0; i < userCount; i++) {
            final String userId = String.valueOf(i + 1000);
            executorService.submit(() -> {
                try {
                    LocationRequest req = new LocationRequest();
                    req.setLat(LAT + (Math.random() * 0.01));
                    req.setLon(LON + (Math.random() * 0.01));
                    ploggingService.processLocation(userId, req);
                    successCount.incrementAndGet();
                } catch (Exception e) {
                    failCount.incrementAndGet();
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await();
        executorService.shutdown();

        Duration concurrencyTime = Duration.between(concurrencyStart, Instant.now());

        log.info("  ✓ 성공: {}/{}", successCount.get(), userCount);
        log.info("  - 총 실행 시간: {}ms", concurrencyTime.toMillis());

        assertThat(successCount.get()).isEqualTo(userCount);
        log.info(">>> [Scenario 6] 테스트 완료");
    }
}