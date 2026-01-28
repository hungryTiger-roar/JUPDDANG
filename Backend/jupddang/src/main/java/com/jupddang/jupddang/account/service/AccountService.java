package com.jupddang.jupddang.account.service;

import com.jupddang.jupddang.account.dto.*;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

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
            throw new IllegalArgumentException("이미 존재하는 아이디입니다.");
        }

        // [추가] 이메일 중복 체크 (Repository에 existsByEmail 메서드 필요)
        if (accountRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("이미 존재하는 이메일입니다.");
        }


        Account account = Account.builder()
                .userId(request.getUserId())
                .pw(bCryptPasswordEncoder.encode(request.getPw()))
                .email(request.getEmail())
                .nickname(request.getNickname())
                .color(request.getColor())
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

        Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUserId(),
                        request.getPw()
                )
        );

        Account account = (Account) auth.getPrincipal();

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
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        return AccountResponse.from(account);
    }

    @Transactional
    public AccountResponse updateAccount(String userId, AccountUpdateRequest request, MultipartFile image) {

        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        String encodedPw = null;
        String imageUrl = null;

        // 1. 비밀번호 암호화
        if (request != null && request.getPw() != null && !request.getPw().isBlank()) {
            encodedPw = bCryptPasswordEncoder.encode(request.getPw());
        }

        // 2. 이미지 업로드 처리
        if (image != null && !image.isEmpty()) {
            // 기존 이미지가 기본 이미지가 아니면 삭제
            if (account.getProfileImage() != null &&
                    !account.getProfileImage().contains("default-profile.png")) {
                try {
                    gcsImageService.deleteImage(account.getProfileImage());
                } catch (Exception e) {
                    log.warn("기존 이미지 삭제 실패 (계속 진행): {}", e.getMessage());
                }
            }
            imageUrl = gcsImageService.uploadImage(image, "profile");
        }

        // 3. 업데이트 (region 삭제됨, 순서: pw, nickname, profileImage, intro, email, color)
        account.update(
                encodedPw,
                request != null ? request.getNickname() : null,
                imageUrl,
                request != null ? request.getIntro() : null,
                request != null ? request.getEmail() : null,
                request != null ? request.getColor() : null
        );

        return AccountResponse.from(account);
    }

    @Transactional
    public AccountResponse deleteAccount(String userId) {

        Account account = accountRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        if (account.getProfileImage() != null &&
                !account.getProfileImage().contains("default-profile.png")) {
            try {
                gcsImageService.deleteImage(account.getProfileImage());
            } catch (Exception e) {
                log.error("이미지 삭제 실패 (탈퇴 진행): {}", e.getMessage());
            }
        }

        accountRepository.delete(account);
        return AccountResponse.from(account);
    }
}