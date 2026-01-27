package com.jupddang.jupddang.account;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jupddang.jupddang.account.dto.*;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.config.EmbeddedRedisConfig;
import com.jupddang.jupddang.security.JwtTokenProvider;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.times;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Slf4j
@SpringBootTest(properties = {
        // [핵심] GCP 관련 자동 설정 비활성화 (JSON 파일 없어도 에러 안 나게 함)
        "spring.cloud.gcp.core.enabled=false",
        "spring.cloud.gcp.storage.enabled=false",
        "spring.cloud.gcp.credentials.location=classpath:non-existent.json" // 더미 경로
})
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Import(EmbeddedRedisConfig.class)
@Transactional
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@TestPropertySource(properties = {
        "spring.data.redis.host=localhost",
        "spring.data.redis.port=6379"
})
class AccountIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    // [Mock] 실제 GCS에 업로드하지 않고 흉내만 냄
    @MockBean
    private GcsImageService gcsImageService;

    private Instant testStartTime;

    // 테스트용 상수 데이터
    private static final String TEST_USER_ID = "testuser";
    private static final String TEST_PASSWORD = "test1234!";
    private static final String TEST_EMAIL = "test@test.com";
    private static final String TEST_NICKNAME = "테스터";
    private static final String TEST_REGION = "서울";
    private static final String MOCK_IMAGE_URL = "https://storage.googleapis.com/test-bucket/test-image.jpg";

    @BeforeEach
    void setUp() {
        testStartTime = Instant.now();
        log.info("=".repeat(80));
        log.info("📌 테스트 시작: {}", testStartTime);

        // GCS Mock 설정 (어떤 이미지가 들어오든 무조건 성공한 척 URL 반환)
        given(gcsImageService.uploadImage(any(), anyString())).willReturn(MOCK_IMAGE_URL);
        doNothing().when(gcsImageService).deleteImage(anyString());
    }

    @AfterEach
    void tearDown() {
        Instant testEndTime = Instant.now();
        Duration duration = Duration.between(testStartTime, testEndTime);
        log.info("⏱️  테스트 실행 시간: {}ms", duration.toMillis());
        log.info("=".repeat(80));
    }

    @Test
    @Order(1)
    @DisplayName("Scenario 1: 회원가입 → 조회 → 검증")
    void testSignupAndGetAccount() throws Exception {
        log.info(">>> [Scenario 1] 회원가입 및 조회 테스트 시작");

        // Step 1: 회원가입
        AccountCreateRequest signupRequest = new AccountCreateRequest(
                TEST_USER_ID, TEST_PASSWORD, TEST_EMAIL, TEST_NICKNAME, TEST_REGION
        );

        mockMvc.perform(post("/api/account/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(signupRequest)))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.userId").value(TEST_USER_ID));

        log.info("  ✅ 회원가입 API 호출 성공");

        // Step 2: DB 검증
        Account savedAccount = accountRepository.findByUserId(TEST_USER_ID).orElseThrow();
        assertThat(savedAccount.getUserId()).isEqualTo(TEST_USER_ID);
        assertThat(passwordEncoder.matches(TEST_PASSWORD, savedAccount.getPw())).isTrue();

        log.info("  ✅ DB 저장 데이터 검증 완료");
    }

    @Test
    @Order(2)
    @DisplayName("Scenario 2: 로그인 → JWT 토큰 검증")
    void testLoginAndTokenValidation() throws Exception {
        log.info(">>> [Scenario 2] 로그인 및 JWT 검증 테스트 시작");

        createTestAccount();

        AccountLoginRequest loginRequest = new AccountLoginRequest(TEST_USER_ID, TEST_PASSWORD);

        MvcResult loginResult = mockMvc.perform(post("/api/account/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.accessToken").exists())
                .andReturn();

        String responseBody = loginResult.getResponse().getContentAsString();
        AccountLoginResponse loginResponse = objectMapper.readValue(responseBody, AccountLoginResponse.class);
        String accessToken = loginResponse.getAccessToken();

        assertThat(jwtTokenProvider.validateToken(accessToken)).isTrue();
        assertThat(jwtTokenProvider.getUserIdFromToken(accessToken)).isEqualTo(TEST_USER_ID);

        log.info("  ✅ 로그인 및 토큰 검증 완료");
    }

    @Test
    @Order(3)
    @DisplayName("Scenario 3: 프로필 수정 (텍스트 + 이미지)")
    void testUpdateProfile() throws Exception {
        log.info(">>> [Scenario 3] 프로필 수정 테스트 시작");

        Account account = createTestAccount();
        String token = generateToken(account);

        String newNickname = "NewNick";
        String newIntro = "Hello World";
        AccountUpdateRequest updateRequest = new AccountUpdateRequest(
                null, newNickname, null, newIntro, null, null, "#FF5733"
        );

        MockMultipartFile dataPart = new MockMultipartFile(
                "data", "", "application/json",
                objectMapper.writeValueAsBytes(updateRequest)
        );
        MockMultipartFile imagePart = new MockMultipartFile(
                "image", "profile.jpg", "image/jpeg", "dummy".getBytes()
        );

        mockMvc.perform(multipart(HttpMethod.PATCH, "/api/account/myprofile")
                        .file(dataPart)
                        .file(imagePart)
                        .header("Authorization", "Bearer " + token))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nickname").value(newNickname))
                .andExpect(jsonPath("$.profileImage").value(MOCK_IMAGE_URL));

        // DB 검증
        Account updated = accountRepository.findByUserId(TEST_USER_ID).orElseThrow();
        assertThat(updated.getNickname()).isEqualTo(newNickname);
        assertThat(updated.getProfileImage()).isEqualTo(MOCK_IMAGE_URL);

        // GCS 호출 검증
        verify(gcsImageService, times(1)).uploadImage(any(), eq("profile"));
        log.info("  ✅ 프로필 수정 및 GCS Mock 호출 검증 완료");
    }

    @Test
    @Order(4)
    @DisplayName("Scenario 4: 회원 탈퇴")
    void testDeleteAccount() throws Exception {
        log.info(">>> [Scenario 4] 회원 탈퇴 테스트 시작");

        Account account = createTestAccount();
        // 이미지 삭제 검증을 위해 이미지 URL 세팅
        account.update(null, null, MOCK_IMAGE_URL, null, null, null, null);
        accountRepository.save(account);

        String token = generateToken(account);

        mockMvc.perform(delete("/api/account/delete")
                        .header("Authorization", "Bearer " + token))
                .andDo(print())
                .andExpect(status().isOk());

        assertThat(accountRepository.findByUserId(TEST_USER_ID)).isEmpty();
        verify(gcsImageService, times(1)).deleteImage(MOCK_IMAGE_URL);

        log.info("  ✅ 회원 탈퇴 및 이미지 삭제 검증 완료");
    }

    @Test
    @Order(5)
    @DisplayName("Scenario 5: [대용량] 100명 동시 회원가입")
    void testConcurrentSignups() throws InterruptedException {
        log.info(">>> [Scenario 5] 100명 동시 회원가입 테스트 시작");

        int userCount = 100;
        ExecutorService executor = Executors.newFixedThreadPool(32);
        CountDownLatch latch = new CountDownLatch(userCount);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failCount = new AtomicInteger(0);

        for (int i = 0; i < userCount; i++) {
            final int idx = i;
            executor.submit(() -> {
                try {
                    AccountCreateRequest request = new AccountCreateRequest(
                            "user" + idx, "pass" + idx, "user" + idx + "@test.com", "nick" + idx, "Seoul"
                    );

                    mockMvc.perform(post("/api/account/signup")
                                    .contentType(MediaType.APPLICATION_JSON)
                                    .content(objectMapper.writeValueAsString(request)))
                            .andExpect(status().isOk());

                    successCount.incrementAndGet();
                } catch (Exception e) {
                    failCount.incrementAndGet();
                    log.error("Fail: {}", e.getMessage());
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await(30, TimeUnit.SECONDS);
        executor.shutdown();

        log.info("  ✅ 성공: {}, ❌ 실패: {}", successCount.get(), failCount.get());

        assertThat(successCount.get()).isEqualTo(userCount);
        assertThat(accountRepository.count()).isEqualTo(userCount);
    }

    // --- Helper Methods ---

    private Account createTestAccount() {
        Account account = Account.builder()
                .userId(TEST_USER_ID)
                .pw(passwordEncoder.encode(TEST_PASSWORD))
                .email(TEST_EMAIL)
                .nickname(TEST_NICKNAME)
                .region(TEST_REGION)
                .color("#000000")
                .score(0)
                .build();
        return accountRepository.save(account);
    }

    private String generateToken(Account account) {
        return jwtTokenProvider.createAccessToken(
                account.getUserId(),
                List.of("ROLE_USER")
        );
    }
}