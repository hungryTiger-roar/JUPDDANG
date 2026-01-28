package com.jupddang.jupddang.security;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.config.EmbeddedRedisConfig;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
@Import(EmbeddedRedisConfig.class)
@Transactional
class UserDetailsServiceImplTest {

    @Autowired
    private UserDetailsServiceImpl userDetailsService;

    @Autowired
    private AccountRepository accountRepository;

    private Account testAccount;


    @MockBean
    private GcsImageService gcsImageService;

    @BeforeEach
    void setUp() {
        testAccount = accountRepository.save(Account.builder()
                .userId("testUser")
                .email("test@test.com")
                .nickname("테스터")
                .pw("encodedPassword")
                .color("#000000")
                .build());
    }

    @Test
    @DisplayName("✅ 존재하는 사용자 로드 성공")
    void loadUserByUsername_Success() {
        // when
        UserDetails userDetails = userDetailsService.loadUserByUsername("testUser");

        // then
        assertThat(userDetails).isNotNull();
        assertThat(userDetails.getUsername()).isEqualTo("testUser");
        assertThat(userDetails.getPassword()).isEqualTo("encodedPassword");
        assertThat(userDetails.getAuthorities()).isNotEmpty();

        // Account 엔티티로 캐스팅 가능한지 확인
        assertThat(userDetails).isInstanceOf(Account.class);
        Account account = (Account) userDetails;
        assertThat(account.getEmail()).isEqualTo("test@test.com");
    }

    @Test
    @DisplayName("❌ 존재하지 않는 사용자 로드 시 예외 발생")
    void loadUserByUsername_NotFound() {
        // when & then
        assertThatThrownBy(() -> userDetailsService.loadUserByUsername("nonExistentUser"))
                .isInstanceOf(UsernameNotFoundException.class)
                .hasMessageContaining("User not found: nonExistentUser");
    }

    @Test
    @DisplayName("❌ null userId로 조회 시 예외 발생")
    void loadUserByUsername_Null() {
        // when & then
        assertThatThrownBy(() -> userDetailsService.loadUserByUsername(null))
                .isInstanceOf(Exception.class);
    }
}
