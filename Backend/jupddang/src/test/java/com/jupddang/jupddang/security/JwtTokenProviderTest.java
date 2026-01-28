package com.jupddang.jupddang.security;

import com.google.cloud.storage.Storage; // ✅ 추가
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService; // ✅ 추가
import com.jupddang.jupddang.config.EmbeddedRedisConfig;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean; // ✅ 추가
import org.springframework.context.annotation.Import;
import org.springframework.security.core.Authentication;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
@Import(EmbeddedRedisConfig.class)
@TestPropertySource(properties = {
        // JWT 설정
        "jwt.secret=test-secret-key-must-be-at-least-32-bytes-long-for-HS256",
        "jwt.access-exp-min=30",
        "jwt.issuer=jupddang-test",
        "spring.cloud.gcp.core.enabled=false",
        "spring.cloud.gcp.storage.enabled=false",
        "spring.cloud.gcp.credentials.location=classpath:non-existent.json",
        "spring.data.redis.port=6379",
        "spring.data.redis.host=localhost"
})
@Transactional
class JwtTokenProviderTest {

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Autowired
    private AccountRepository accountRepository;

    // ✅ GCS MockBean 추가 (필수!)
    @MockBean
    private GcsImageService gcsImageService;

    @MockBean
    private Storage storage;

    private Account testAccount;
    private String validToken;

    @BeforeEach
    void setUp() {
        accountRepository.deleteAll();

        testAccount = accountRepository.save(Account.builder()
                .userId("jwtTestUser")
                .email("jwt@test.com")
                .nickname("JWT테스터")
                .pw("encodedPassword")
                .color("#000000")
                .build());

        validToken = jwtTokenProvider.createAccessToken(
                testAccount.getUserId(),
                List.of("ROLE_USER")
        );
    }

    // =========================================================================
    // 1. 토큰 생성 테스트
    // =========================================================================

    @Test
    @DisplayName("✅ Access Token 생성 성공")
    void createAccessToken_Success() {
        // when
        String token = jwtTokenProvider.createAccessToken("testUser", List.of("ROLE_USER"));

        // then
        assertThat(token).isNotNull();
        assertThat(token).isNotEmpty();
        assertThat(token.split("\\.")).hasSize(3);
    }

    @Test
    @DisplayName("✅ Access Token 생성: 여러 권한")
    void createAccessToken_MultipleRoles() {
        // when
        String token = jwtTokenProvider.createAccessToken(
                "adminUser",
                List.of("ROLE_USER", "ROLE_ADMIN")
        );

        // then
        List<String> roles = jwtTokenProvider.getRolesFromToken(token);
        assertThat(roles).hasSize(2);
        assertThat(roles).containsExactlyInAnyOrder("ROLE_USER", "ROLE_ADMIN");
    }

    // =========================================================================
    // 2. 토큰 파싱 및 정보 추출 테스트
    // =========================================================================

    @Test
    @DisplayName("✅ 토큰에서 userId 추출")
    void getUserIdFromToken_Success() {
        // when
        String userId = jwtTokenProvider.getUserIdFromToken(validToken);

        // then
        assertThat(userId).isEqualTo("jwtTestUser");
    }

    @Test
    @DisplayName("✅ 토큰에서 권한(roles) 추출")
    void getRolesFromToken_Success() {
        // when
        List<String> roles = jwtTokenProvider.getRolesFromToken(validToken);

        // then
        assertThat(roles).hasSize(1);
        assertThat(roles).contains("ROLE_USER");
    }

    @Test
    @DisplayName("✅ 토큰에서 만료 시간 추출")
    void getExpirationFromToken_Success() {
        // when
        Date expiration = jwtTokenProvider.getExpirationFromToken(validToken);

        // then
        assertThat(expiration).isNotNull();
        assertThat(expiration).isAfter(new Date());
    }

    @Test
    @DisplayName("✅ 토큰에서 발급 시간 추출")
    void getIssuedAtFromToken_Success() {
        // when
        Date issuedAt = jwtTokenProvider.getIssuedAtFromToken(validToken);

        // then
        assertThat(issuedAt).isNotNull();
        assertThat(issuedAt).isBefore(new Date(System.currentTimeMillis() + 1000));
    }

    // =========================================================================
    // 3. 토큰 유효성 검증 테스트
    // =========================================================================

    @Test
    @DisplayName("✅ 유효한 토큰 검증 성공")
    void validateToken_Valid() {
        // when
        boolean isValid = jwtTokenProvider.validateToken(validToken);

        // then
        assertThat(isValid).isTrue();
    }

    @Test
    @DisplayName("❌ 잘못된 토큰 형식 검증 실패")
    void validateToken_InvalidFormat() {
        // given
        String invalidToken = "invalid.token.format";

        // when
        boolean isValid = jwtTokenProvider.validateToken(invalidToken);

        // then
        assertThat(isValid).isFalse();
    }

    @Test
    @DisplayName("❌ 서명이 잘못된 토큰 검증 실패")
    void validateToken_InvalidSignature() {
        // given
        String tokenWithWrongSignature = validToken.substring(0, validToken.length() - 10) + "wrongsign";

        // when
        boolean isValid = jwtTokenProvider.validateToken(tokenWithWrongSignature);

        // then
        assertThat(isValid).isFalse();
    }

    @Test
    @DisplayName("❌ null 토큰 검증 실패")
    void validateToken_Null() {
        // when
        boolean isValid = jwtTokenProvider.validateToken(null);

        // then
        assertThat(isValid).isFalse();
    }

    @Test
    @DisplayName("❌ 빈 문자열 토큰 검증 실패")
    void validateToken_Empty() {
        // when
        boolean isValid = jwtTokenProvider.validateToken("");

        // then
        assertThat(isValid).isFalse();
    }

    // =========================================================================
    // 4. 토큰 만료 테스트
    // =========================================================================

    @Test
    @DisplayName("✅ 유효한 토큰은 만료되지 않음")
    void isTokenExpired_NotExpired() {
        // when
        boolean isExpired = jwtTokenProvider.isTokenExpired(validToken);

        // then
        assertThat(isExpired).isFalse();
    }

    @Test
    @DisplayName("❌ 잘못된 토큰은 만료된 것으로 간주")
    void isTokenExpired_InvalidToken() {
        // given
        String invalidToken = "invalid.token";

        // when
        boolean isExpired = jwtTokenProvider.isTokenExpired(invalidToken);

        // then
        assertThat(isExpired).isTrue();
    }

    // =========================================================================
    // 5. Authentication 객체 생성 테스트
    // =========================================================================

    @Test
    @DisplayName("✅ 토큰으로 Authentication 객체 생성")
    void getAuthentication_Success() {
        // when
        Authentication authentication = jwtTokenProvider.getAuthentication(validToken);

        // then
        assertThat(authentication).isNotNull();
        assertThat(authentication.isAuthenticated()).isTrue();
        assertThat(authentication.getName()).isEqualTo("jwtTestUser");

        Object principal = authentication.getPrincipal();
        assertThat(principal).isInstanceOf(Account.class);

        Account account = (Account) principal;
        assertThat(account.getUserId()).isEqualTo("jwtTestUser");
        assertThat(account.getEmail()).isEqualTo("jwt@test.com");

        assertThat(authentication.getAuthorities()).isNotEmpty();
        assertThat(authentication.getAuthorities().stream()
                .anyMatch(auth -> auth.getAuthority().equals("ROLE_USER")))
                .isTrue();
    }

    @Test
    @DisplayName("❌ 존재하지 않는 사용자 토큰으로 Authentication 생성 시 예외")
    void getAuthentication_UserNotFound() {
        // given
        String tokenWithNonExistentUser = jwtTokenProvider.createAccessToken(
                "nonExistentUser",
                List.of("ROLE_USER")
        );

        // when & then
        assertThatThrownBy(() -> jwtTokenProvider.getAuthentication(tokenWithNonExistentUser))
                .isInstanceOf(Exception.class);
    }

    // =========================================================================
    // 6. 토큰 만료 시간 설정 테스트
    // =========================================================================

    @Test
    @DisplayName("✅ Access Token 만료 시간 설정 확인")
    void getAccessTokenExpiresInSeconds() {
        // when
        long expiresIn = jwtTokenProvider.getAccessTokenExpiresInSeconds();

        // then
        assertThat(expiresIn).isEqualTo(30 * 60);
    }

    @Test
    @DisplayName("✅ 생성된 토큰의 실제 만료 시간 확인")
    void checkActualTokenExpiration() {
        // given
        long beforeCreation = System.currentTimeMillis();

        // when
        String token = jwtTokenProvider.createAccessToken("user", List.of("ROLE_USER"));
        Date expiration = jwtTokenProvider.getExpirationFromToken(token);

        long afterCreation = System.currentTimeMillis();

        // then
        long expectedExpiryMillis = 30 * 60 * 1000;
        long actualDiff = expiration.getTime() - beforeCreation;

        assertThat(actualDiff).isBetween(
                expectedExpiryMillis - 2000,
                expectedExpiryMillis + 2000
        );
    }

    // =========================================================================
    // 7. 엣지 케이스 테스트
    // =========================================================================

    @Test
    @DisplayName("✅ 빈 권한 목록으로 토큰 생성")
    void createAccessToken_EmptyRoles() {
        // when
        String token = jwtTokenProvider.createAccessToken("user", List.of());

        // then
        assertThat(token).isNotNull();
        List<String> roles = jwtTokenProvider.getRolesFromToken(token);
        assertThat(roles).isEmpty();
    }

    @Test
    @DisplayName("✅ 특수문자 포함 userId로 토큰 생성")
    void createAccessToken_SpecialCharacters() {
        // given
        String specialUserId = "user@test.com";

        // when
        String token = jwtTokenProvider.createAccessToken(specialUserId, List.of("ROLE_USER"));

        // then
        assertThat(token).isNotNull();
        String extractedUserId = jwtTokenProvider.getUserIdFromToken(token);
        assertThat(extractedUserId).isEqualTo(specialUserId);
    }

    @Test
    @DisplayName("✅ 긴 userId로 토큰 생성")
    void createAccessToken_LongUserId() {
        // given
        String longUserId = "a".repeat(100);

        // when
        String token = jwtTokenProvider.createAccessToken(longUserId, List.of("ROLE_USER"));

        // then
        assertThat(token).isNotNull();
        String extractedUserId = jwtTokenProvider.getUserIdFromToken(token);
        assertThat(extractedUserId).isEqualTo(longUserId);
    }
}
