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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AccountIntegrationTest {

    @Autowired private AccountService accountService;
    @Autowired private AccountRepository accountRepository;
    @Autowired private BCryptPasswordEncoder passwordEncoder;

    // 리스너 테스트용
    @Autowired private ApplicationEventPublisher eventPublisher;
    @Autowired private TransactionTemplate transactionTemplate;

    // --- Mocks ---
    @MockBean private GcsImageService gcsImageService;
    @MockBean private PloggingRepository ploggingRepository;

    private Account savedAccount;

    @BeforeEach
    void setUp() {
        // 테스트용 계정 생성
        // 엔티티 생성자에는 region 파라미터가 있으므로 "Seoul"을 넘기지만,
        // 엔티티 내부에 필드가 없으므로 실제로는 저장되지 않음을 인지하고 테스트 작성
        Account account = Account.builder()
                .userId("testUser")
                .pw(passwordEncoder.encode("password123"))
                .email("test@example.com")
                .nickname("테스터")
                .region("Seoul")
                .color("#000000")
                .build();

        savedAccount = accountRepository.save(account);
    }

    @Test
    @DisplayName("✅ 회원가입: 비밀번호 암호화 및 초기 데이터(티어, 점수) 설정 확인")
    void createAccount_Success() {
        // given
        AccountCreateRequest request = new AccountCreateRequest(
                "newUser", "password123", "new@test.com", "뉴비", "Busan"
        );

        // when
        AccountResponse response = accountService.createAccount(request);

        // then
        Account found = accountRepository.findByUserId("newUser").orElseThrow();

        assertThat(found.getUserId()).isEqualTo("newUser");
        assertThat(found.getNickname()).isEqualTo("뉴비");
        assertThat(passwordEncoder.matches("password123", found.getPw())).isTrue(); // 암호화 검증
        assertThat(found.getTier()).isEqualTo(PloggingLevel.BRONZE_5.getLabel()); // 초기 티어
        assertThat(found.getTotalScore()).isEqualTo(0);

        // [수정 반영] region 필드가 엔티티에 없으므로 검증 제외
        // assertThat(found.getRegion()).isEqualTo("Busan");
    }

    @Test
    @DisplayName("✅ 정보 수정: 프로필 이미지 변경 시 GCS 업로드 및 Account 업데이트 확인")
    void updateAccount_WithImage() {
        // given
        String newNickname = "변경된닉네임";
        AccountUpdateRequest updateRequest = new AccountUpdateRequest(
                "newPw123", newNickname, null, "New Intro", "Incheon", "new@email.com", "#FFFFFF"
        );

        MockMultipartFile newImageFile = new MockMultipartFile(
                "image", "profile.jpg", "image/jpeg", "dummy data".getBytes()
        );

        // GCS Mock 설정
        String mockImageUrl = "https://storage.googleapis.com/fake-url/profile.jpg";
        given(gcsImageService.uploadImage(any(), anyString())).willReturn(mockImageUrl);

        // when
        accountService.updateAccount(savedAccount.getUserId(), updateRequest, newImageFile);

        // then
        Account updatedAccount = accountRepository.findByUserId(savedAccount.getUserId()).orElseThrow();

        assertThat(updatedAccount.getNickname()).isEqualTo(newNickname);
        assertThat(updatedAccount.getProfileImage()).isEqualTo(mockImageUrl);
        assertThat(passwordEncoder.matches("newPw123", updatedAccount.getPw())).isTrue();

        // [수정 반영] region 필드가 엔티티에 없으므로 검증 제외
        // assertThat(updatedAccount.getRegion()).isEqualTo("Incheon");

        // GCS 메서드 호출 여부 검증
        verify(gcsImageService, times(1)).uploadImage(any(), anyString());
    }

    @Test
    @DisplayName("✅ 회원 탈퇴: 계정 삭제 및 프로필 이미지 삭제 로직 호출 확인")
    void deleteAccount_Success() {
        // given: 프로필 이미지가 있는 상태로 변경 (삭제 로직 검증용)
        // update 메서드 호출 (region 파라미터는 전달하지만 엔티티에 반영 안 됨)
        savedAccount.update(null, null, "https://custom-image.url", null, null, null, null);
        accountRepository.save(savedAccount);

        // when
        accountService.deleteAccount(savedAccount.getUserId());

        // then
        Optional<Account> deletedAccount = accountRepository.findByUserId(savedAccount.getUserId());
        assertThat(deletedAccount).isEmpty();

        // GCS 삭제 메서드 호출 검증
        verify(gcsImageService, times(1)).deleteImage("https://custom-image.url");
    }

    @Test
    @DisplayName("✅ 점수 정산 리스너: 플로깅 종료 시 점수 계산 및 Account 반영 확인")
    void handlePloggingCompleted_ScoreUpdate() {
        // given
        Long ploggingId = 100L;
        double distance = 2.5;  // 2.5km -> 250점
        int occupiedGridCnt = 2; // 2개 -> 1000점
        int raidScore = 100;     // 100점
        // 예상 총점: 250 + 1000 + 100 = 1350점

        // 1. Plogging 객체 Mocking
        Plogging mockPlogging = Plogging.builder()
                .id(ploggingId)
                .account(savedAccount) // DB에 저장된 Account 사용
                .distance(distance)
                .score(0)
                .times(3600)
                .createdAt(LocalDateTime.now())
                .build();

        // Repository Mocking (Long 타입 ID 대응)
        given(ploggingRepository.findById(ploggingId)).willReturn(Optional.of(mockPlogging));

        // 2. 이벤트 생성
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
        // TransactionPhase.AFTER_COMMIT 리스너 실행을 위해 트랜잭션 템플릿 사용
        transactionTemplate.executeWithoutResult(status -> {
            eventPublisher.publishEvent(event);
        });

        // then
        Account updatedAccount = accountRepository.findByUserId(savedAccount.getUserId()).orElseThrow();

        // 점수 검증
        assertThat(updatedAccount.getTotalScore()).isEqualTo(1350);

        // 티어 변경 검증 (로직에 따라)
        // assertThat(updatedAccount.getTier()).isNotEqualTo(PloggingLevel.BRONZE_5.getLabel());
    }
}