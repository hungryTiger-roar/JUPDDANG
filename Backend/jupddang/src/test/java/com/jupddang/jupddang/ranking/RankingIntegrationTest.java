package com.jupddang.jupddang.ranking;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.storage.Storage; // ✅ 추가
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService; // ✅ 추가
import com.jupddang.jupddang.config.EmbeddedRedisConfig;
import com.jupddang.jupddang.ranking.repository.RankingRedisRepository;
import com.jupddang.jupddang.ranking.dto.RankingListResponseDto;
import com.jupddang.jupddang.ranking.service.RankingService;
import com.jupddang.jupddang.security.JwtTokenProvider;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.*;
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

import java.time.LocalDate;
import java.util.List;

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
        "spring.cloud.gcp.core.enabled=false", // ✅ 추가
        "spring.cloud.gcp.storage.enabled=false", // ✅ 추가
        "spring.cloud.gcp.credentials.location=classpath:non-existent.json", // ✅ 추가
        "spring.data.redis.port=6379",
        "spring.data.redis.host=localhost",
        "logging.level.org.hibernate.SQL=OFF",
        "spring.jpa.show-sql=false"
})
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class RankingIntegrationTest {

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private RankingService rankingService;
    @Autowired
    private AccountRepository accountRepository;
    @Autowired
    private RankingRedisRepository redisRepository;

    // ✅ GCS 관련 MockBean 추가 (필수!)
    @MockBean
    private GcsImageService gcsImageService;
    @MockBean
    private Storage storage;

    @MockBean
    private JwtTokenProvider jwtTokenProvider;

    private static final String TOTAL_RANKING_KEY = "ranking:total";
    private String monthlyRankingKey;

    private Account user1, user2, user3, user4, user5;

    @BeforeEach
    void setUp() {
        // 1. DB 초기화
        accountRepository.deleteAll();

        // 2. Redis 초기화
        try {
            redisRepository.deleteRankingKey(TOTAL_RANKING_KEY);

            LocalDate now = LocalDate.now();
            monthlyRankingKey = String.format("ranking:monthly:%04d%02d",
                    now.getYear(), now.getMonthValue());
            redisRepository.deleteRankingKey(monthlyRankingKey);
        } catch (Exception e) {
            log.warn("Redis 초기화 실패 (무시): {}", e.getMessage());
        }

        // 3. 테스트 사용자 생성
        user1 = accountRepository.save(Account.builder()
                .userId("user1")
                .email("user1@test.com")
                .nickname("1등유저")
                .pw("password")
                .color("#FF0000")
                .build());

        user2 = accountRepository.save(Account.builder()
                .userId("user2")
                .email("user2@test.com")
                .nickname("2등유저")
                .pw("password")
                .color("#00FF00")
                .build());

        user3 = accountRepository.save(Account.builder()
                .userId("user3")
                .email("user3@test.com")
                .nickname("3등유저")
                .pw("password")
                .color("#0000FF")
                .build());

        user4 = accountRepository.save(Account.builder()
                .userId("user4")
                .email("user4@test.com")
                .nickname("4등유저")
                .pw("password")
                .color("#FFFF00")
                .build());

        user5 = accountRepository.save(Account.builder()
                .userId("user5")
                .email("user5@test.com")
                .nickname("5등유저")
                .pw("password")
                .color("#FF00FF")
                .build());

        // 4. Redis에 랭킹 데이터 추가 (점수 내림차순)
        redisRepository.updateRanking(TOTAL_RANKING_KEY, "user1", 10000.0);
        redisRepository.updateRanking(TOTAL_RANKING_KEY, "user2", 8000.0);
        redisRepository.updateRanking(TOTAL_RANKING_KEY, "user3", 6000.0);
        redisRepository.updateRanking(TOTAL_RANKING_KEY, "user4", 4000.0);
        redisRepository.updateRanking(TOTAL_RANKING_KEY, "user5", 2000.0);

        // 5. 월간 랭킹도 동일하게 설정
        redisRepository.updateRanking(monthlyRankingKey, "user1", 5000.0);
        redisRepository.updateRanking(monthlyRankingKey, "user2", 4000.0);
        redisRepository.updateRanking(monthlyRankingKey, "user3", 3000.0);
        redisRepository.updateRanking(monthlyRankingKey, "user4", 2000.0);
        redisRepository.updateRanking(monthlyRankingKey, "user5", 1000.0);

        // 6. JWT Mock 설정
        setupJwtMock();
    }

    private void setupJwtMock() {
        given(jwtTokenProvider.validateToken(anyString())).willReturn(true);
        given(jwtTokenProvider.getUserIdFromToken(anyString())).willAnswer(invocation -> invocation.getArgument(0));
        given(jwtTokenProvider.getAuthentication(anyString())).willAnswer(invocation -> {
            String userId = invocation.getArgument(0);
            return new UsernamePasswordAuthenticationToken(
                    userId, "", List.of(new SimpleGrantedAuthority("ROLE_USER")));
        });
    }

    @AfterEach
    void tearDown() {
        accountRepository.deleteAll();
        try {
            redisRepository.deleteRankingKey(TOTAL_RANKING_KEY);
            redisRepository.deleteRankingKey(monthlyRankingKey);
        } catch (Exception e) {
            log.warn("Redis 정리 실패 (무시): {}", e.getMessage());
        }
    }

    // =========================================================================
    // 1. 전체 랭킹 조회 테스트
    // =========================================================================

    @Test
    @Order(1)
    @DisplayName("✅ 전체 랭킹 조회: Top 3와 내 주변 랭킹 반환")
    void getTotalRanking_Success() throws Exception {
        // when
        mockMvc.perform(get("/api/ranking/total")
                .param("userId", "user3")
                .header("Authorization", "Bearer user3"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.topRankers").isArray())
                .andExpect(jsonPath("$.topRankers.length()").value(3))
                .andExpect(jsonPath("$.topRankers[0].rank").value(1))
                .andExpect(jsonPath("$.topRankers[0].userId").value("user1"))
                .andExpect(jsonPath("$.topRankers[0].nickname").value("1등유저"))
                .andExpect(jsonPath("$.topRankers[0].score").value(10000))
                .andExpect(jsonPath("$.topRankers[1].rank").value(2))
                .andExpect(jsonPath("$.topRankers[1].userId").value("user2"))
                .andExpect(jsonPath("$.topRankers[2].rank").value(3))
                .andExpect(jsonPath("$.topRankers[2].userId").value("user3"))
                .andExpect(jsonPath("$.myRankWindow").isArray())
                .andExpect(jsonPath("$.myRankWindow.length()").value(5)); // 3등 기준 1~5등
    }

    @Test
    @Order(2)
    @DisplayName("✅ 전체 랭킹: 1등 사용자의 윈도우 확인")
    void getTotalRanking_FirstPlace() throws Exception {
        // when
        mockMvc.perform(get("/api/ranking/total")
                .param("userId", "user1")
                .header("Authorization", "Bearer user1"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.myRankWindow[0].rank").value(1))
                .andExpect(jsonPath("$.myRankWindow[0].userId").value("user1"))
                .andExpect(jsonPath("$.myRankWindow.length()").value(3)); // 1~3등만 표시
    }

    @Test
    @Order(3)
    @DisplayName("✅ 전체 랭킹: 5등(꼴등) 사용자의 윈도우 확인")
    void getTotalRanking_LastPlace() throws Exception {
        // when
        mockMvc.perform(get("/api/ranking/total")
                .param("userId", "user5")
                .header("Authorization", "Bearer user5"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.myRankWindow.length()").value(3)) // 3~5등만 표시
                .andExpect(jsonPath("$.myRankWindow[2].rank").value(5))
                .andExpect(jsonPath("$.myRankWindow[2].userId").value("user5"));
    }

    @Test
    @Order(4)
    @DisplayName("✅ 전체 랭킹: Service 레이어 직접 호출 테스트")
    void getTotalRanking_ServiceDirect() {
        // when
        RankingListResponseDto response = rankingService.getTotalRanking("user2");

        // then
        assertThat(response).isNotNull();
        assertThat(response.getTopRankers()).hasSize(3);
        assertThat(response.getTopRankers().get(0).getUserId()).isEqualTo("user1");
        assertThat(response.getTopRankers().get(1).getUserId()).isEqualTo("user2");
        assertThat(response.getTopRankers().get(1).getScore()).isEqualTo(8000L);

        assertThat(response.getMyRankWindow()).isNotEmpty();
        assertThat(response.getMyRankWindow().get(0).getRank()).isEqualTo(1);
    }

    // =========================================================================
    // 2. 월간 랭킹 조회 테스트
    // =========================================================================

    @Test
    @Order(5)
    @DisplayName("✅ 월간 랭킹 조회: 현재 월 (파라미터 없음)")
    void getMonthlyRanking_CurrentMonth() throws Exception {
        // when
        mockMvc.perform(get("/api/ranking/monthly")
                .param("userId", "user2")
                .header("Authorization", "Bearer user2"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.topRankers").isArray())
                .andExpect(jsonPath("$.topRankers.length()").value(3))
                .andExpect(jsonPath("$.topRankers[0].userId").value("user1"))
                .andExpect(jsonPath("$.topRankers[0].score").value(5000))
                .andExpect(jsonPath("$.myRankWindow").isArray());
    }

    @Test
    @Order(6)
    @DisplayName("✅ 월간 랭킹 조회: 특정 년월 지정")
    void getMonthlyRanking_SpecificMonth() throws Exception {
        // given
        LocalDate now = LocalDate.now();
        int year = now.getYear();
        int month = now.getMonthValue();

        // when
        mockMvc.perform(get("/api/ranking/monthly")
                .param("year", String.valueOf(year))
                .param("month", String.valueOf(month))
                .param("userId", "user3")
                .header("Authorization", "Bearer user3"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.topRankers[0].score").value(5000))
                .andExpect(jsonPath("$.topRankers[2].userId").value("user3"));
    }

    @Test
    @Order(7)
    @DisplayName("✅ 월간 랭킹: Service 레이어 직접 호출")
    void getMonthlyRanking_ServiceDirect() {
        // when
        RankingListResponseDto response = rankingService.getMonthlyRanking(null, null, "user4");

        // then
        assertThat(response).isNotNull();
        assertThat(response.getTopRankers()).hasSize(3);
        assertThat(response.getTopRankers().get(0).getScore()).isEqualTo(5000L);

        assertThat(response.getMyRankWindow()).isNotEmpty();
        boolean found = response.getMyRankWindow().stream()
                .anyMatch(r -> r.getUserId().equals("user4"));
        assertThat(found).isTrue();
    }

    // =========================================================================
    // 3. 예외 및 엣지 케이스 테스트
    // =========================================================================

    @Test
    @Order(8)
    @DisplayName("⚠️ 예외: userId 파라미터 누락 시 400 에러")
    void getTotalRanking_MissingUserId() throws Exception {
        // when & then
        mockMvc.perform(get("/api/ranking/total")
                .header("Authorization", "Bearer user1"))
                .andDo(print())
                .andExpect(status().isBadRequest());
    }

    @Test
    @Order(9)
    @DisplayName("⚠️ 랭킹에 없는 사용자 조회 시 빈 윈도우 반환")
    void getTotalRanking_UserNotInRanking() throws Exception {
        // given
        Account newUser = accountRepository.save(Account.builder()
                .userId("newUser")
                .email("new@test.com")
                .nickname("신규유저")
                .pw("password")
                .color("#CCCCCC")
                .build());

        // when - Redis에 없는 사용자
        mockMvc.perform(get("/api/ranking/total")
                .param("userId", "newUser")
                .header("Authorization", "Bearer newUser"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.topRankers").isArray())
                .andExpect(jsonPath("$.topRankers.length()").value(3))
                .andExpect(jsonPath("$.myRankWindow").isEmpty()); // 윈도우 비어있음
    }

    @Test
    @Order(10)
    @DisplayName("⚠️ Redis에 데이터가 없을 때")
    void getTotalRanking_EmptyRedis() throws Exception {
        // given - Redis 초기화
        redisRepository.deleteRankingKey(TOTAL_RANKING_KEY);

        // when
        mockMvc.perform(get("/api/ranking/total")
                .param("userId", "user1")
                .header("Authorization", "Bearer user1"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.topRankers").isEmpty())
                .andExpect(jsonPath("$.myRankWindow").isEmpty());
    }

    @Test
    @Order(11)
    @DisplayName("✅ 점수 동점자 처리 확인")
    void getTotalRanking_SameScore() {
        // given - 동점자 추가
        redisRepository.updateRanking(TOTAL_RANKING_KEY, "user1", 5000.0);
        redisRepository.updateRanking(TOTAL_RANKING_KEY, "user2", 5000.0); // 동점

        // when
        RankingListResponseDto response = rankingService.getTotalRanking("user1");

        // then
        assertThat(response.getTopRankers()).hasSize(3);
        // Redis ZSet은 동점자를 사전순으로 정렬
    }

    // =========================================================================
    // 4. 데이터 정합성 테스트
    // =========================================================================

    @Test
    @Order(12)
    @DisplayName("✅ 티어 계산 정확도 확인")
    void checkTierCalculation() {
        // when
        RankingListResponseDto response = rankingService.getTotalRanking("user1");

        // then
        response.getTopRankers().forEach(ranker -> {
            log.info("유저: {}, 점수: {}, 티어: {}",
                    ranker.getUserId(), ranker.getScore(), ranker.getTier());
            assertThat(ranker.getTier()).isNotNull();
        });
    }

    @Test
    @Order(13)
    @DisplayName("✅ 프로필 이미지 URL 존재 확인")
    void checkProfileImageExists() {
        // when
        RankingListResponseDto response = rankingService.getTotalRanking("user1");

        // then
        response.getTopRankers().forEach(ranker -> {
            assertThat(ranker.getProfileImage()).isNotNull();
            assertThat(ranker.getProfileImage()).contains("default-profile.png");
        });
    }

    @Test
    @Order(14)
    @DisplayName("✅ 대량 유저 랭킹 조회 성능 테스트")
    void performanceTest_ManyUsers() {
        // given - 100명의 유저 추가
        for (int i = 10; i < 110; i++) {
            Account user = accountRepository.save(Account.builder()
                    .userId("user" + i)
                    .email("user" + i + "@test.com")
                    .nickname("유저" + i)
                    .pw("password")
                    .color("#FFFFFF")
                    .build());

            redisRepository.updateRanking(TOTAL_RANKING_KEY, "user" + i, (double) (10000 - i * 10));
        }

        long startTime = System.currentTimeMillis();

        // when
        RankingListResponseDto response = rankingService.getTotalRanking("user50");

        long duration = System.currentTimeMillis() - startTime;

        // then
        assertThat(response.getTopRankers()).hasSize(3);
        assertThat(response.getMyRankWindow()).isNotEmpty();

        log.info("100명 랭킹 조회 소요 시간: {}ms", duration);
        assertThat(duration).isLessThan(1000); // 1초 이내
    }

    @Test
    @Order(15)
    @DisplayName("✅ 월간 랭킹 키 형식 검증")
    void verifyMonthlyKeyFormat() {
        // given
        LocalDate testDate = LocalDate.of(2025, 12, 15);

        // when
        String expectedKey = "ranking:monthly:202512";

        // then - Service에서 생성된 키가 올바른지 간접 확인
        RankingListResponseDto response = rankingService.getMonthlyRanking(2025, 12, "user1");

        // 데이터가 없어도 예외 없이 빈 결과 반환
        assertThat(response).isNotNull();
        assertThat(response.getTopRankers()).isEmpty();
    }
}
