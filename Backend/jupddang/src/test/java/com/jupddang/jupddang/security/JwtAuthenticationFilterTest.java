package com.jupddang.jupddang.security;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.config.EmbeddedRedisConfig;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Import(EmbeddedRedisConfig.class)
@Transactional
class JwtAuthenticationFilterTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Autowired
    private AccountRepository accountRepository;


    @MockBean
    private GcsImageService gcsImageService;
    private String validToken;

    @BeforeEach
    void setUp() {
        Account account = accountRepository.save(Account.builder()
                .userId("filterTestUser")
                .email("filter@test.com")
                .nickname("필터테스터")
                .pw("password")
                .color("#000000")
                .build());

        validToken = jwtTokenProvider.createAccessToken(
                account.getUserId(),
                List.of("ROLE_USER")
        );
    }

    @Test
    @DisplayName("✅ 유효한 JWT 토큰으로 인증된 요청")
    void authenticatedRequest_WithValidToken() throws Exception {
        // when & then
        mockMvc.perform(get("/api/ranking/total")
                        .param("userId", "filterTestUser")
                        .header("Authorization", "Bearer " + validToken))
                .andDo(print())
                .andExpect(status().isOk());
    }

    @Test
    @DisplayName("❌ 토큰 없이 요청 시 401 Unauthorized")
    void unauthenticatedRequest_WithoutToken() throws Exception {
        // when & then
        mockMvc.perform(get("/api/ranking/total")
                        .param("userId", "filterTestUser"))
                .andDo(print())
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("❌ 잘못된 토큰으로 요청 시 401 Unauthorized")
    void unauthenticatedRequest_WithInvalidToken() throws Exception {
        // when & then
        mockMvc.perform(get("/api/ranking/total")
                        .param("userId", "filterTestUser")
                        .header("Authorization", "Bearer invalid.token.here"))
                .andDo(print())
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("❌ Bearer 없이 토큰만 전송 시 401 Unauthorized")
    void unauthenticatedRequest_WithoutBearer() throws Exception {
        // when & then
        mockMvc.perform(get("/api/ranking/total")
                        .param("userId", "filterTestUser")
                        .header("Authorization", validToken))
                .andDo(print())
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("✅ 공개 API는 토큰 없이 접근 가능")
    void publicEndpoint_WithoutToken() throws Exception {
        // when & then
        mockMvc.perform(get("/api/v1/healthcheck"))
                .andDo(print())
                .andExpect(status().isOk());
    }
}
