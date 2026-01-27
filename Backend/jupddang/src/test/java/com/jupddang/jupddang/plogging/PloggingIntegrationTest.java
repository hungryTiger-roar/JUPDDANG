package com.jupddang.jupddang.plogging;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.storage.Storage;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.config.EmbeddedRedisConfig;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.repository.PloggingRedisRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.raid.service.RaidService;
import com.jupddang.jupddang.security.JwtTokenProvider;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@Slf4j
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Import(EmbeddedRedisConfig.class)
// [중요] 멀티스레드 환경에서 DB 데이터를 공유하기 위해 @Transactional 제거
@TestPropertySource(properties = {
        "spring.cloud.gcp.core.enabled=false",
        "spring.cloud.gcp.storage.enabled=false",
        "spring.cloud.gcp.credentials.location=classpath:non-existent.json",
        "logging.level.org.hibernate.SQL=OFF",
        "spring.jpa.show-sql=false",
        "spring.data.redis.port=6379", // Embedded Redis 기본 포트
        "spring.data.redis.host=localhost"
})
class PloggingIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;
    @Autowired private AccountRepository accountRepository;
    @Autowired private PloggingRepository ploggingRepository;
    @Autowired private PloggingRedisRepository redisRepository;

    // --- Mock Beans ---
    @MockBean private GcsImageService gcsImageService;
    @MockBean private Storage storage; // GCP 에러 방지
    @MockBean private RaidService raidService;
    @MockBean private JwtTokenProvider jwtTokenProvider; // 인증 우회용

    private Account testUser;
    private final String MOCK_IMG_URL = "https://gcs/mock-image.jpg";

    @BeforeEach
    void setUp() {
        // 1. 데이터 초기화 (Transactional 없으므로 수동 관리)
        ploggingRepository.deleteAll();
        accountRepository.deleteAll();

        // 2. 메인 테스트 유저 생성 (address 제거, color 추가)
        testUser = accountRepository.save(Account.builder()
                .userId("plogger")
                .email("plog@test.com")
                .nickname("플로거")
                .pw("password")
                .color("#000000") // [필수] NOT NULL 제약조건 준수
                .score(0)
                .build());

        // 3. 외부 서비스 Mock
        given(gcsImageService.uploadImage(any(), anyString())).willReturn(MOCK_IMG_URL);
        given(raidService.applyRaidScore(anyString(), any())).willReturn(100);

        // 4. [핵심] JWT 인증 무조건 통과 설정
        setupJwtMock();
    }

    private void setupJwtMock() {
        // 유효성 검사 통과
        given(jwtTokenProvider.validateToken(anyString())).willReturn(true);

        // [수정] 메서드명 일치 (getUserIdFromToken)
        given(jwtTokenProvider.getUserIdFromToken(anyString())).willAnswer(invocation -> invocation.getArgument(0));

        // 인증 객체 생성 (입력된 토큰 문자열을 userId로 사용)
        given(jwtTokenProvider.getAuthentication(anyString())).willAnswer(invocation -> {
            String userId = invocation.getArgument(0);
            return new UsernamePasswordAuthenticationToken(
                    userId, "", List.of(new SimpleGrantedAuthority("ROLE_USER"))
            );
        });
    }

    @AfterEach
    void tearDown() {
        // 테스트 종료 후 정리
        ploggingRepository.deleteAll();
        accountRepository.deleteAll();
        try {
            redisRepository.deleteUserState("plogger");
        } catch (Exception e) { /* Redis 정리 실패 무시 */ }
    }

    // -------------------------------------------------------------------------
    // 1. 정상 흐름 테스트
    // -------------------------------------------------------------------------
    @Test
    @Order(1)
    @DisplayName("✅ 플로깅 종료: 정상 처리 (DB저장 + Redis정산 + 이미지업로드)")
    void endPlogging_Success() throws Exception {
        // given
        redisRepository.addCapturedGrid(testUser.getUserId(), "8930e128077ffff");

        PloggingEndRequest requestDto = new PloggingEndRequest(
                null, 5.5, List.of("line"), List.of("trash"), 3600
        );

        MockMultipartFile requestPart = new MockMultipartFile(
                "data", "", "application/json",
                objectMapper.writeValueAsString(requestDto).getBytes(StandardCharsets.UTF_8)
        );
        MockMultipartFile img = new MockMultipartFile("beforeImage", "b.jpg", "image/jpeg", "d".getBytes());
        MockMultipartFile img2 = new MockMultipartFile("afterImage", "a.jpg", "image/jpeg", "d".getBytes());
        MockMultipartFile img3 = new MockMultipartFile("mapImage", "m.jpg", "image/jpeg", "d".getBytes());

        // when
        mockMvc.perform(multipart("/api/v1/plogging/end")
                        .file(requestPart).file(img).file(img2).file(img3)
                        // [핵심] 헤더 2개 모두 필수
                        .header("Authorization", "Bearer " + testUser.getUserId()) // Security Filter용
                        .header("userId", testUser.getUserId())                    // Controller용
                        .contentType(MediaType.MULTIPART_FORM_DATA))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.distance").value(5.5))
                .andExpect(jsonPath("$.occupiedGridCnt").value(1));

        // then
        List<Plogging> logs = ploggingRepository.findAll();
        assertThat(logs).hasSize(1);
        assertThat(logs.get(0).getAccount().getUserId()).isEqualTo("plogger");

        // Redis 데이터 삭제 확인
        assertThat(redisRepository.getCapturedCount(testUser.getUserId())).isEqualTo(0);
    }

    // -------------------------------------------------------------------------
    // 2. 예외 케이스 테스트
    // -------------------------------------------------------------------------
    @Test
    @Order(2)
    @DisplayName("⚠️ 예외: 필수 이미지 누락 시 400 에러")
    void endPlogging_MissingImage() throws Exception {
        // given
        PloggingEndRequest requestDto = new PloggingEndRequest(null, 1.0, List.of(), List.of(), 100);
        MockMultipartFile requestPart = new MockMultipartFile(
                "data", "", "application/json",
                objectMapper.writeValueAsString(requestDto).getBytes(StandardCharsets.UTF_8)
        );
        MockMultipartFile img = new MockMultipartFile("beforeImage", "b.jpg", "image/jpeg", "d".getBytes());

        // when (afterImage, mapImage 누락)
        mockMvc.perform(multipart("/api/v1/plogging/end")
                        .file(requestPart).file(img)
                        .header("Authorization", "Bearer " + testUser.getUserId())
                        .header("userId", testUser.getUserId()))
                .andDo(print())
                .andExpect(status().isBadRequest()); // ExceptionHandler가 400 처리
    }

    // -------------------------------------------------------------------------
    // 3. 100명 동시 접속 테스트
    // -------------------------------------------------------------------------
    @Test
    @Order(3)
    @DisplayName("🔥 부하: 100명 동시 플로깅 종료")
    void test100ConcurrentPloggingEnd() throws InterruptedException {
        int userCount = 100;
        ExecutorService executor = Executors.newFixedThreadPool(20);
        CountDownLatch latch = new CountDownLatch(userCount);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failCount = new AtomicInteger(0);

        log.info("유저 100명 DB 생성 시작...");
        for (int i = 0; i < userCount; i++) {
            accountRepository.save(Account.builder()
                    .userId("user" + i)
                    .email("u" + i + "@test.com")
                    .nickname("n" + i)
                    .pw("pw")
                    .color("#FFFFFF") // [필수]
                    .score(0)
                    .build());
        }
        log.info("유저 100명 생성 완료.");

        long start = System.currentTimeMillis();

        for (int i = 0; i < userCount; i++) {
            final int index = i;
            executor.submit(() -> {
                try {
                    String userId = "user" + index;

                    PloggingEndRequest reqDto = new PloggingEndRequest(null, 10.0, List.of(), List.of(), 100);
                    MockMultipartFile reqPart = new MockMultipartFile("data", "", "application/json", objectMapper.writeValueAsString(reqDto).getBytes());
                    MockMultipartFile img = new MockMultipartFile("beforeImage", "i.jpg", "image/jpeg", "d".getBytes());
                    MockMultipartFile img2 = new MockMultipartFile("afterImage", "i.jpg", "image/jpeg", "d".getBytes());
                    MockMultipartFile img3 = new MockMultipartFile("mapImage", "i.jpg", "image/jpeg", "d".getBytes());

                    mockMvc.perform(multipart("/api/v1/plogging/end")
                                    .file(reqPart).file(img).file(img2).file(img3)
                                    // [핵심] 헤더 2개 모두 주입
                                    .header("Authorization", "Bearer " + userId) // Filter 통과
                                    .header("userId", userId)                    // Controller 파라미터
                                    .contentType(MediaType.MULTIPART_FORM_DATA))
                            .andExpect(status().isOk());

                    successCount.incrementAndGet();
                } catch (Throwable e) { // AssertionError 잡기 위해 Throwable 사용
                    log.error("❌ User-{} 실패 원인: {}", index, e.getMessage());
                    failCount.incrementAndGet();
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await(30, TimeUnit.SECONDS);
        long duration = System.currentTimeMillis() - start;

        log.info("📊 100명 결과: 성공={}, 실패={}, 시간={}ms", successCount.get(), failCount.get(), duration);

        // 검증
        assertThat(successCount.get()).isEqualTo(userCount);
        long dbCount = ploggingRepository.count();
        log.info("최종 DB Plogging Count: {}", dbCount); // 최소 100개 이상이어야 함
    }
}