package com.jupddang.jupddang.account.controller;

import com.jupddang.jupddang.account.dto.AccountCreateRequest;
import com.jupddang.jupddang.account.dto.AccountLoginRequest;
import com.jupddang.jupddang.account.dto.AccountLoginResponse;
import com.jupddang.jupddang.account.dto.AccountResponse;
import com.jupddang.jupddang.account.dto.AccountUpdateRequest;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.service.AccountService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.http.MediaType;

import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/account")
@Tag(name = "account api", description = "계정 관련 API")
public class AccountController {

    private final AccountService accountService;

    // 회원가입
    @PostMapping("/signup")
    @Operation(summary = "회원가입")
    public ResponseEntity<AccountResponse> signup(@RequestBody AccountCreateRequest request) {

        AccountResponse account = accountService.createAccount(request);

        return ResponseEntity.ok(account);

    }

    // 로그인
    @PostMapping("/login")
    @Operation(summary = "로그인")
    public ResponseEntity<AccountLoginResponse> login(@RequestBody AccountLoginRequest request) {

        AccountLoginResponse login = accountService.login(request);

        return ResponseEntity.ok(login);
    }

    // 전체 계정 정보 조회
    @GetMapping
    @Operation(summary = "전체 계정 목록 조회")
    public ResponseEntity<?> getAccounts() {
        try {
            System.out.println("============== [DEBUG] 요청 도착: /api/account ==============");
            List<AccountResponse> allAccounts = accountService.getAllAccounts();
            System.out.println("============== [DEBUG] 조회 성공: " + allAccounts.size() + "건 ==============");
            return ResponseEntity.ok(allAccounts);
        } catch (Exception e) {
            // 🚨 여기가 핵심! 에러가 나면 무조건 로그에 찍히게 만듭니다.
            System.out.println("============== [ERROR] 에러 발생 ==============");
            e.printStackTrace(); // 에러 내용을 콘솔에 강제로 출력
            return ResponseEntity.internalServerError().body("서버 에러: " + e.getMessage());
        }
    }

    // 내 프로필 조회
    @GetMapping("/myprofile")
    @Operation(summary = "내 프로필 조회")
    public ResponseEntity<AccountResponse> getAccount(@AuthenticationPrincipal Account account) {

        log.info("userId = {}", account.getUserId());
        log.info("pw = {}", account.getPw());
        log.info("nickname = {}", account.getNickname());
        log.info("intro = {}", account.getIntro());

        AccountResponse getAccount = accountService.getAccount(account.getUserId());

        return ResponseEntity.ok(getAccount);
    }

    // 내 프로필 수정
    @PatchMapping("/myprofile")
    @Operation(summary = "내 프로필 수정")
    public ResponseEntity<AccountResponse> updateAccount(
            @RequestPart(value = "data", required = false) AccountUpdateRequest request,  // ← JSON
            @RequestPart(value = "image", required = false) MultipartFile image,  // ← 파일
            @AuthenticationPrincipal Account account
    ) {

        AccountResponse accountResponse = accountService.updateAccount(account.getUserId(), request, image);

        return ResponseEntity.ok(accountResponse);
    }

    // 회원 탈퇴
    @DeleteMapping("/delete")
    @Operation(summary = "회원 탈퇴")
    public ResponseEntity<AccountResponse> deleteAccount(@AuthenticationPrincipal Account account) {

        AccountResponse accountResponse = accountService.deleteAccount(account.getUserId());

        return ResponseEntity.ok(accountResponse);

    }

    // 프로필 이미지 업로드
    @PostMapping(value = "/profile-image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "프로필 이미지 업로드", description = "인증된 사용자의 프로필 이미지를 GCS에 업로드")
    public ResponseEntity<AccountResponse> uploadProfileImage(
            @RequestParam("image") MultipartFile image,
            @AuthenticationPrincipal Account account
    ) {
        log.info("프로필 이미지 업로드 요청 - userId: {}, 파일명: {}, 파일크기: {}bytes",
                account.getUserId(),
                image.getOriginalFilename(),
                image.getSize());

        AccountResponse response = accountService.uploadProfileImage(
                account.getUserId(),
                image
        );

        return ResponseEntity.ok(response);
    }
}
