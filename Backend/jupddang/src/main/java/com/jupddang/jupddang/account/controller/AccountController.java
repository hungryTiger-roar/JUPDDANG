package com.jupddang.jupddang.account.controller;

import com.jupddang.jupddang.account.dto.*;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.service.AccountService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter; // [필수] 이거 없으면 에러남
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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
    public ResponseEntity<List<AccountResponse>> getAccounts() {
        List<AccountResponse> allAccounts = accountService.getAllAccounts();
        return ResponseEntity.ok(allAccounts);
    }

    // 내 프로필 조회
    @GetMapping("/myprofile")
    @Operation(summary = "내 프로필 조회")
    public ResponseEntity<AccountResponse> getAccount(
            @Parameter(hidden = true) @AuthenticationPrincipal Account account
    ) {
        // [수정] 본인 프로필 조회 시에도 팔로워/팔로잉 숫자를 가져오기 위해 account 객체 전달
        AccountResponse myAccount = accountService.getAccount(account.getUserId(), account);
        return ResponseEntity.ok(myAccount);
    }

    // 상대방 프로필 조회 (신규 추가 추천)
    @GetMapping("/profile/{targetId}")
    @Operation(summary = "상대 프로필 조회")
    public ResponseEntity<AccountResponse> getOtherAccount(
            @PathVariable String targetId,
            @Parameter(hidden = true) @AuthenticationPrincipal Account loginUser
    ) {
        // [수정] 대상 ID와 내 로그인 정보를 함께 넘겨 팔로우 여부(isFollowing) 판단
        AccountResponse profile = accountService.getAccount(targetId, loginUser);
        return ResponseEntity.ok(profile);
    }

    // 내 프로필 수정 (텍스트 + 이미지 동시 처리)
    @PatchMapping("/myprofile")
    @Operation(summary = "내 프로필 수정", description = "data(JSON)와 image(File)를 함께 전송합니다.")
    public ResponseEntity<AccountResponse> updateAccount(
            @RequestPart(value = "data", required = false) AccountUpdateRequest request,
            @RequestPart(value = "image", required = false) MultipartFile image,
            // [수정] Swagger 숨김 처리
            @Parameter(hidden = true) @AuthenticationPrincipal Account account
    ) {
        AccountResponse accountResponse = accountService.updateAccount(account.getUserId(), request, image);
        return ResponseEntity.ok(accountResponse);
    }

    // 회원 탈퇴
    @DeleteMapping("/delete")
    @Operation(summary = "회원 탈퇴")
    public ResponseEntity<AccountResponse> deleteAccount(
            // [수정] Swagger 숨김 처리
            @Parameter(hidden = true) @AuthenticationPrincipal Account account
    ) {
        AccountResponse accountResponse = accountService.deleteAccount(account.getUserId());
        return ResponseEntity.ok(accountResponse);
    }
}