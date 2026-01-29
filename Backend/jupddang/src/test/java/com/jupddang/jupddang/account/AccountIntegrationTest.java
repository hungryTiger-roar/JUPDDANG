package com.jupddang.jupddang.account;

import com.jupddang.jupddang.account.dto.AccountCreateRequest;
import com.jupddang.jupddang.account.dto.AccountResponse;
import com.jupddang.jupddang.account.dto.AccountUpdateRequest;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.account.service.AccountService;
import com.jupddang.jupddang.common.enums.PloggingLevel;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AccountIntegrationTest {

    @Autowired private AccountService accountService;
    @Autowired private AccountRepository accountRepository;
    @Autowired private BCryptPasswordEncoder passwordEncoder;
    @Autowired private ApplicationEventPublisher eventPublisher;
    @Autowired private TransactionTemplate transactionTemplate;

    @MockBean private GcsImageService gcsImageService;
    @MockBean private PloggingRepository ploggingRepository;

    private Account savedAccount;

    @BeforeEach
    void setUp() {
        accountRepository.deleteAll();

        Account account = Account.builder()
                .userId("testUser")
                .pw(passwordEncoder.encode("password123"))
                .email("test@example.com")
                .nickname("테스터")
                .color("#000000")
                .build();

        savedAccount = accountRepository.save(account);
    }

    @Test
    @DisplayName("✅ 회원가입: 비밀번호 암호화 및 초기 데이터(티어, 점수, 기본값) 설정 확인")
    void createAccount_Success() {
        // given
        AccountCreateRequest request = AccountCreateRequest.builder()
                .userId("newUser")
                .pw("password123")
                .email("new@test.com")
                .nickname("뉴비")
                .color("#FF5733")
                .build();

        // when
        AccountResponse response = accountService.createAccount(request);

        // then
        Account found = accountRepository.findByUserId("newUser").orElseThrow();

        assertThat(found.getUserId()).isEqualTo("newUser");
        assertThat(found.getNickname()).isEqualTo("뉴비");
        assertThat(found.getEmail()).isEqualTo("new@test.com");
        assertThat(found.getColor()).isEqualTo("#FF5733");
        assertThat(passwordEncoder.matches("password123", found.getPw())).isTrue();

        // 초기값 검증
        assertThat(found.getTier()).isEqualTo(PloggingLevel.BRONZE_5.getLabel());
        assertThat(found.getTotalScore()).isEqualTo(0);
        assertThat(found.getProfileImage()).isEqualTo("https://storage.googleapis.com/jupddang-images/default/default-profile.png");
        assertThat(found.getIntro()).isEqualTo("안녕하세요!");
    }

    @Test
    @DisplayName("✅ 회원가입: color가 null일 때 기본값(#111111) 설정 확인")
    void createAccount_WithNullColor_UsesDefault() {
        // given
        AccountCreateRequest request = AccountCreateRequest.builder()
                .userId("colorTestUser")
                .pw("password123")
                .email("color@test.com")
                .nickname("컬러테스터")
                .color(null)  // null 명시
                .build();

        // when
        AccountResponse response = accountService.createAccount(request);

        // then
        Account found = accountRepository.findByUserId("colorTestUser").orElseThrow();
        assertThat(found.getColor()).isEqualTo("#111111");
    }

    @Test
    @DisplayName("✅ 회원가입: color 미지정 시 기본값(#111111) 설정 확인")
    void createAccount_WithoutColor_UsesDefault() {
        // given - color 필드를 아예 설정하지 않음
        AccountCreateRequest request = AccountCreateRequest.builder()
                .userId("colorTestUser2")
                .pw("password123")
                .email("color2@test.com")
                .nickname("컬러테스터2")
                .build();  // color 미지정

        // when
        AccountResponse response = accountService.createAccount(request);

        // then
        Account found = accountRepository.findByUserId("colorTestUser2").orElseThrow();
        assertThat(found.getColor()).isEqualTo("#111111");
    }

    @Test
    @DisplayName("❌ 회원가입: 중복 userId 예외 발생 확인")
    void createAccount_DuplicateUserId_ThrowsException() {
        // given
        AccountCreateRequest request = AccountCreateRequest.builder()
                .userId("testUser")  // 이미 존재
                .pw("password123")
                .email("duplicate@test.com")
                .nickname("중복유저")
                .color("#000000")
                .build();

        // when & then
        assertThatThrownBy(() -> accountService.createAccount(request))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("이미 존재하는 아이디입니다.");
    }

    @Test
    @DisplayName("❌ 회원가입: 중복 이메일 예외 발생 확인")
    void createAccount_DuplicateEmail_ThrowsException() {
        // given
        AccountCreateRequest request = AccountCreateRequest.builder()
                .userId("anotherUser")
                .pw("password123")
                .email("test@example.com")  // 이미 존재
                .nickname("다른유저")
                .color("#000000")
                .build();

        // when & then
        assertThatThrownBy(() -> accountService.createAccount(request))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("이미 존재하는 이메일입니다.");
    }

    @Test
    @DisplayName("✅ 정보 수정: 프로필 이미지 변경 시 GCS 업로드 및 Account 업데이트 확인")
    void updateAccount_WithImage() {
        // given
        AccountUpdateRequest updateRequest = AccountUpdateRequest.builder()
                .pw("newPw123")
                .nickname("변경된닉네임")
                .intro("New Intro")
                .email("new@email.com")
                .color("#FFFFFF")
                .build();

        MockMultipartFile newImageFile = new MockMultipartFile(
                "image",
                "profile.jpg",
                "image/jpeg",
                "dummy image data".getBytes()
        );

        String mockImageUrl = "https://storage.googleapis.com/jupddang-images/profile/profile.jpg";
        given(gcsImageService.uploadImage(any(), eq("profile"))).willReturn(mockImageUrl);

        // when
        AccountResponse response = accountService.updateAccount(
                savedAccount.getUserId(),
                updateRequest,
                newImageFile
        );

        // then
        Account updatedAccount = accountRepository.findByUserId(savedAccount.getUserId()).orElseThrow();

        assertThat(updatedAccount.getNickname()).isEqualTo("변경된닉네임");
        assertThat(updatedAccount.getIntro()).isEqualTo("New Intro");
        assertThat(updatedAccount.getEmail()).isEqualTo("new@email.com");
        assertThat(updatedAccount.getColor()).isEqualTo("#FFFFFF");
        assertThat(updatedAccount.getProfileImage()).isEqualTo(mockImageUrl);
        assertThat(passwordEncoder.matches("newPw123", updatedAccount.getPw())).isTrue();

        verify(gcsImageService, times(1)).uploadImage(any(), eq("profile"));
    }

    @Test
    @DisplayName("✅ 정보 수정: 이미지 없이 정보만 수정")
    void updateAccount_WithoutImage() {
        // given
        AccountUpdateRequest updateRequest = AccountUpdateRequest.builder()
                .nickname("새닉네임")
                .intro("새로운 소개")
                .email("updated@email.com")
                .color("#AABBCC")
                .build();  // pw는 설정하지 않음

        // when
        AccountResponse response = accountService.updateAccount(
                savedAccount.getUserId(),
                updateRequest,
                null  // 이미지 없음
        );

        // then
        Account updatedAccount = accountRepository.findByUserId(savedAccount.getUserId()).orElseThrow();

        assertThat(updatedAccount.getNickname()).isEqualTo("새닉네임");
        assertThat(updatedAccount.getIntro()).isEqualTo("새로운 소개");
        assertThat(updatedAccount.getEmail()).isEqualTo("updated@email.com");
        assertThat(updatedAccount.getColor()).isEqualTo("#AABBCC");

        // 비밀번호는 변경되지 않음
        assertThat(passwordEncoder.matches("password123", updatedAccount.getPw())).isTrue();

        // 프로필 이미지는 기본값 유지
        assertThat(updatedAccount.getProfileImage())
                .isEqualTo("https://storage.googleapis.com/jupddang-images/default/default-profile.png");

        verify(gcsImageService, never()).uploadImage(any(), anyString());
    }

    @Test
    @DisplayName("✅ 정보 수정: 특정 필드만 선택적으로 수정")
    void updateAccount_PartialUpdate() {
        // given - nickname만 수정
        AccountUpdateRequest updateRequest = AccountUpdateRequest.builder()
                .nickname("닉네임만변경")
                .build();

        // when
        accountService.updateAccount(savedAccount.getUserId(), updateRequest, null);

        // then
        Account updated = accountRepository.findByUserId(savedAccount.getUserId()).orElseThrow();

        assertThat(updated.getNickname()).isEqualTo("닉네임만변경");
        // 나머지 필드는 원본 유지
        assertThat(updated.getEmail()).isEqualTo("test@example.com");
        assertThat(updated.getColor()).isEqualTo("#000000");
        assertThat(updated.getIntro()).isEqualTo("안녕하세요!");
    }

    @Test
    @DisplayName("✅ 정보 수정: 기존 커스텀 이미지 삭제 후 새 이미지 업로드")
    void updateAccount_ReplaceCustomImage() {
        // given
        String oldCustomImage = "https://storage.googleapis.com/jupddang-images/profile/old.jpg";
        savedAccount.update(null, null, oldCustomImage, null, null, null);
        accountRepository.save(savedAccount);

        String newImageUrl = "https://storage.googleapis.com/jupddang-images/profile/new.jpg";
        given(gcsImageService.uploadImage(any(), eq("profile"))).willReturn(newImageUrl);
        doNothing().when(gcsImageService).deleteImage(oldCustomImage);

        MockMultipartFile newImage = new MockMultipartFile(
                "image", "new.jpg", "image/jpeg", "new data".getBytes()
        );

        AccountUpdateRequest updateRequest = AccountUpdateRequest.builder()
                .nickname("이미지교체")
                .build();

        // when
        accountService.updateAccount(savedAccount.getUserId(), updateRequest, newImage);

        // then
        Account updated = accountRepository.findByUserId(savedAccount.getUserId()).orElseThrow();
        assertThat(updated.getProfileImage()).isEqualTo(newImageUrl);
        assertThat(updated.getNickname()).isEqualTo("이미지교체");

        verify(gcsImageService, times(1)).deleteImage(oldCustomImage);
        verify(gcsImageService, times(1)).uploadImage(any(), eq("profile"));
    }

    @Test
    @DisplayName("✅ 회원 탈퇴: 계정 삭제 및 커스텀 프로필 이미지 삭제 로직 호출 확인")
    void deleteAccount_WithCustomImage() {
        // given
        String customImageUrl = "https://storage.googleapis.com/jupddang-images/profile/custom.jpg";
        savedAccount.update(null, null, customImageUrl, null, null, null);
        accountRepository.save(savedAccount);

        doNothing().when(gcsImageService).deleteImage(customImageUrl);

        // when
        AccountResponse response = accountService.deleteAccount(savedAccount.getUserId());

        // then
        Optional<Account> deletedAccount = accountRepository.findByUserId(savedAccount.getUserId());
        assertThat(deletedAccount).isEmpty();

        verify(gcsImageService, times(1)).deleteImage(customImageUrl);
    }

    @Test
    @DisplayName("✅ 회원 탈퇴: 기본 프로필 이미지는 삭제하지 않음")
    void deleteAccount_WithDefaultImage() {
        // given - savedAccount는 기본 이미지를 사용 중

        // when
        accountService.deleteAccount(savedAccount.getUserId());

        // then
        Optional<Account> deletedAccount = accountRepository.findByUserId(savedAccount.getUserId());
        assertThat(deletedAccount).isEmpty();

        // 기본 이미지는 삭제하지 않음
        verify(gcsImageService, never()).deleteImage(anyString());
    }

    @Test
    @DisplayName("❌ 정보 조회: 존재하지 않는 userId로 조회 시 예외 발생")
    void getAccount_NotFound_ThrowsException() {
        // when & then
        assertThatThrownBy(() -> accountService.getAccount("nonExistentUser"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("사용자를 찾을 수 없습니다.");
    }

    @Test
    @DisplayName("✅ 정보 조회: 성공")
    void getAccount_Success() {
        // when
        AccountResponse response = accountService.getAccount(savedAccount.getUserId());

        // then
        assertThat(response.getUserId()).isEqualTo("testUser");
        assertThat(response.getNickname()).isEqualTo("테스터");
        assertThat(response.getEmail()).isEqualTo("test@example.com");
    }

    @Test
    @DisplayName("✅ 점수 정산 리스너: 플로깅 종료 시 점수 계산 및 Account 반영 확인")
    void handlePloggingCompleted_ScoreUpdate() {
        // given
        Long ploggingId = 100L;
        double distance = 2.5;       // 2.5km -> 250점
        int occupiedGridCnt = 2;     // 2개 -> 1000점
        int raidScore = 100;         // 100점
        // 예상 총점: 250 + 1000 + 100 = 1350점

        Plogging mockPlogging = Plogging.builder()
                .id(ploggingId)
                .account(savedAccount)
                .distance(distance)
                .score(0)
                .times(3600)
                .createdAt(LocalDateTime.now())
                .build();

        given(ploggingRepository.findById(ploggingId)).willReturn(Optional.of(mockPlogging));

        PloggingCompletedEvent event = PloggingCompletedEvent.builder()
                .ploggingId(ploggingId)
                .userId(savedAccount.getUserId())
                .occupiedGridCnt(occupiedGridCnt)
                .raidScore(raidScore)
                .beforeImage(null)
                .afterImage(null)
                .mapImage(null)
                .build();

        // when
        transactionTemplate.executeWithoutResult(status -> {
            eventPublisher.publishEvent(event);
        });

        // then
        Account updatedAccount = accountRepository.findByUserId(savedAccount.getUserId()).orElseThrow();

        assertThat(updatedAccount.getTotalScore()).isEqualTo(1350);

        // 티어가 변경되었는지 확인
        String expectedTier = PloggingLevel.findByScore(1350L).getLabel();
        assertThat(updatedAccount.getTier()).isEqualTo(expectedTier);
    }

    @Test
    @DisplayName("✅ addScore: 점수 증가 및 티어 자동 업데이트 확인")
    void addScore_UpdatesTierAutomatically() {
        // given
        assertThat(savedAccount.getTotalScore()).isEqualTo(0);
        assertThat(savedAccount.getTier()).isEqualTo(PloggingLevel.BRONZE_5.getLabel());

        // when
        savedAccount.addScore(5000);
        accountRepository.save(savedAccount);

        // then
        Account updated = accountRepository.findByUserId(savedAccount.getUserId()).orElseThrow();
        assertThat(updated.getTotalScore()).isEqualTo(5000);

        String expectedTier = PloggingLevel.findByScore(5000L).getLabel();
        assertThat(updated.getTier()).isEqualTo(expectedTier);
    }

    @Test
    @DisplayName("✅ addScore: 여러 번 점수 추가 시 누적 및 티어 업데이트")
    void addScore_MultipleAdditions() {
        // when
        savedAccount.addScore(1000);
        savedAccount.addScore(2000);
        savedAccount.addScore(500);
        accountRepository.save(savedAccount);

        // then
        Account updated = accountRepository.findByUserId(savedAccount.getUserId()).orElseThrow();
        assertThat(updated.getTotalScore()).isEqualTo(3500);

        String expectedTier = PloggingLevel.findByScore(3500L).getLabel();
        assertThat(updated.getTier()).isEqualTo(expectedTier);
    }

    @Test
    @DisplayName("✅ 전체 계정 조회")
    void getAllAccounts_Success() {
        // given
        Account account2 = Account.builder()
                .userId("user2")
                .pw(passwordEncoder.encode("pw2"))
                .email("user2@test.com")
                .nickname("유저2")
                .color("#AAAAAA")
                .build();
        accountRepository.save(account2);

        // when
        var accounts = accountService.getAllAccounts();

        // then
        assertThat(accounts).hasSize(2);
        assertThat(accounts)
                .extracting(AccountResponse::getUserId)
                .containsExactlyInAnyOrder("testUser", "user2");
    }

    @Test
    @DisplayName("✅ 전체 계정 조회: 빈 리스트")
    void getAllAccounts_EmptyList() {
        // given
        accountRepository.deleteAll();

        // when
        var accounts = accountService.getAllAccounts();

        // then
        assertThat(accounts).isEmpty();
    }
}
