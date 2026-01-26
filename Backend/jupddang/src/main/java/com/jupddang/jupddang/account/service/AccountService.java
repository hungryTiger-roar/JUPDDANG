package com.jupddang.jupddang.account.service;

import com.jupddang.jupddang.account.dto.AccountCreateRequest;
import com.jupddang.jupddang.account.dto.AccountLoginRequest;
import com.jupddang.jupddang.account.dto.AccountLoginResponse;
import com.jupddang.jupddang.account.dto.AccountResponse;
import com.jupddang.jupddang.account.dto.AccountUpdateRequest;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class AccountService {

    private final AccountRepository accountRepository;
    private final AuthenticationManager authenticationManager;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final GcsImageService gcsImageService;

    @Transactional
    public AccountResponse createAccount(AccountCreateRequest request) {

        if (accountRepository.existsById(request.getUserId())) {
            throw new IllegalArgumentException("UserId already exists.");
        }

        Account account = Account.builder()
                .userId(request.getUserId())
                .pw(bCryptPasswordEncoder.encode(request.getPw()))
                .email(request.getEmail())
                .nickname(request.getNickname())
                .region(request.getRegion())
                .color("#111111")
                .score(0)
                .build();

        return AccountResponse.from(accountRepository.save(account));
    }

    @Transactional(readOnly = true)
    public List<AccountResponse> getAllAccounts() {
        return accountRepository.findAll().stream()
                .map(AccountResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public AccountLoginResponse login(AccountLoginRequest request) {

        // 입력 받은 로그인 정보로 인증 시도
        // 내부적으로 loadUserbyUsername 호출과 비밀번호를 검증함
        // 성공시 사용자 정보가 담긴 인증 객체 생성
        Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUserId(),
                        request.getPw()
                )
        );

        // 로그인 성공한 사용자 정보 (Account) 가져오기
        Account account = (Account) auth.getPrincipal();

        // 가져온 객체로 JWT 생성
        String accessToken = jwtTokenProvider.createAccessToken(
                account.getUserId(),
                account.getAuthorities().stream()
                        .map(grantedAuthority -> grantedAuthority.getAuthority())
                        .toList()
        );

        return AccountLoginResponse.of(
                accessToken,
                jwtTokenProvider.getAccessTokenExpiresInSeconds(),
                AccountResponse.from(account)
        );
    }

    @Transactional(readOnly = true)
    public AccountResponse getAccount(String userId) {

        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found."));

        return AccountResponse.from(account);
    }

    @Transactional
    public AccountResponse updateAccount(String userId, AccountUpdateRequest request) {

        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found."));

        String encodedPw = null;

        if (request.getPw() != null) {
            encodedPw = bCryptPasswordEncoder.encode(request.getPw());
        }

        account.update(
                encodedPw,
                request.getNickname(),
                request.getProfileImage(),
                request.getIntro(),
                request.getRegion(),
                request.getEmail(),
                request.getColor()
        );

        return AccountResponse.from(account);
    }

    @Transactional
    public AccountResponse deleteAccount(String userId) {
        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found."));

        accountRepository.delete(account);

        return AccountResponse.from(account);
    }

    @Transactional
    public AccountResponse uploadProfileImage(String userId, MultipartFile image) {

        // 1. 계정 조회
        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found."));

        // 2. 기존 프로필 이미지가 있으면 GCS에서 삭제
        if (account.getProfileImage() != null &&
                !account.getProfileImage().isEmpty() &&
                !account.getProfileImage().contains("default-profile.png")) {

            try {
                gcsImageService.deleteImage(account.getProfileImage());
                log.info("기존 프로필 이미지 삭제 완료: {}", account.getProfileImage());
            } catch (Exception e) {
                log.warn("기존 프로필 이미지 삭제 실패 (계속 진행): {}", e.getMessage());
            }
        }

        // 3. 새 이미지를 GCS에 업로드
        String imageUrl = gcsImageService.uploadImage(image, "profile");
        log.info("새 프로필 이미지 업로드 완료: {}", imageUrl);

        // 4. Account 엔티티의 profileImage 필드만 업데이트
        account.update(
                null,       // pw
                null,       // nickname
                imageUrl,   // profileImage
                null,       // intro
                null,       // region
                null,       // email
                null        // color
        );

        return AccountResponse.from(account);
    }

}
