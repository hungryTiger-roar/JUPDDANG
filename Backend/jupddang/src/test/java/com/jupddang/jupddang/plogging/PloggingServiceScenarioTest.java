package com.jupddang.jupddang.plogging;

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
    @Mock private ApplicationEventPublisher eventPublisher;
    @Mock private SimpMessagingTemplate messagingTemplate;
    @Mock private H3Core h3Core;
    @Mock private RaidService raidService;

    private final String USER_ID_A = "100";
    private final String USER_ID_B = "200";
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
        log.info("  - 플로깅 요청: distance={}km, time={}초", request.distance(), request.endTime());

        Plogging savedPlogging = Plogging.builder()
                .id(999L)
                .userId(USER_ID_A)
                .distance(5.0)
                .times(3600)
                .build();
        given(ploggingRepository.save(any(Plogging.class))).willReturn(savedPlogging);

        Set<String> capturedGrids = Set.of(MOCK_H3_INDEX_1, MOCK_H3_INDEX_2, MOCK_H3_INDEX_3);
        given(redisRepository.getCapturedGrids(USER_ID_A)).willReturn(capturedGrids);
        log.info("  - 점령 그리드 수: {}", capturedGrids.size());

        given(raidService.applyRaidScore(eq(USER_ID_A), anySet())).willReturn(500);
        log.info("  - 예상 레이드 점수: 500");

        // when
        log.info("[WHEN] endPlogging 메서드 실행...");
        Instant executeStart = Instant.now();
        PloggingResultResponse response = ploggingService.endPlogging(USER_ID_A, request, image, image, image);
        Duration executionTime = Duration.between(executeStart, Instant.now());
        log.info("  - 실행 시간: {}ms", executionTime.toMillis());

        // then
        log.info("[THEN] 검증 시작...");
        log.info("  ✓ DB 저장 검증");
        verify(ploggingRepository).save(any(Plogging.class));

        log.info("  ✓ 이벤트 발행 검증");
        verify(eventPublisher).publishEvent(any(PloggingCompletedEvent.class));

        log.info("  ✓ 레이드 정산 검증");
        verify(raidService).applyRaidScore(eq(USER_ID_A), anySet());

        log.info("  ✓ Redis 정리 검증");
        verify(redisRepository).deleteUserState(USER_ID_A);

        log.info("  ✓ 응답 데이터 검증: raidScore={}, occupiedGridCnt={}",
                response.raidScore(), response.occupiedGridCnt());
        assertThat(response.raidScore()).isEqualTo(500);
        assertThat(response.occupiedGridCnt()).isEqualTo(3);

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

        log.info("  - 총 사용자 수: {}", userCount);
        log.info("  - 스레드 풀 크기: 32");

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
                    log.error("  ✗ 사용자 {} 처리 실패: {}", userId, e.getMessage());
                } finally {
                    latch.countDown();
                }
            });
        }

        log.info("  - 모든 요청 제출 완료, 대기 중...");
        latch.await();
        executorService.shutdown();

        Duration concurrencyTime = Duration.between(concurrencyStart, Instant.now());

        log.info("  ✓ 성공: {}/{}", successCount.get(), userCount);
        log.info("  ✗ 실패: {}/{}", failCount.get(), userCount);
        log.info("  - 총 실행 시간: {}ms", concurrencyTime.toMillis());
        log.info("  - 평균 처리 시간: {}ms/user", concurrencyTime.toMillis() / userCount);
        log.info("  - 처리량: {}/sec", (userCount * 1000.0) / concurrencyTime.toMillis());

        assertThat(successCount.get()).isEqualTo(userCount);
        log.info(">>> [Scenario 6] 테스트 완료");
    }
}
