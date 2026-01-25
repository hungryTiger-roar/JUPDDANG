package com.jupddang.jupddang.account.controller;

import com.jupddang.jupddang.account.dto.AccountCreateRequest;
import com.jupddang.jupddang.account.dto.AccountLoginRequest;
import com.jupddang.jupddang.account.dto.AccountLoginResponse;
import com.jupddang.jupddang.account.dto.AccountResponse;
import com.jupddang.jupddang.account.dto.AccountUpdateRequest;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.service.AccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/account")
public class AccountController {

    private final AccountService accountService;

    // 회원가입
    @PostMapping("/signup")
    public ResponseEntity<AccountResponse> signup(@RequestBody AccountCreateRequest request) {

        AccountResponse account = accountService.createAccount(request);

        return ResponseEntity.ok(account);

    }

    // 로그인
    @PostMapping("/login")
    public ResponseEntity<AccountLoginResponse> login(@RequestBody AccountLoginRequest request) {

        AccountLoginResponse login = accountService.login(request);

        return ResponseEntity.ok(login);
    }

    // 전체 계정 정보 조회
    @GetMapping
    public ResponseEntity<List<AccountResponse>> getAccounts() {

        List<AccountResponse> allAccounts = accountService.getAllAccounts();

        return ResponseEntity.ok(allAccounts);
    }

    // 내 프로필 조회
    @GetMapping("/myprofile")
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
    public ResponseEntity<AccountResponse> updateAccount(@RequestBody AccountUpdateRequest request, @AuthenticationPrincipal Account account) {

        AccountResponse accountResponse = accountService.updateAccount(account.getUserId(), request);

        return ResponseEntity.ok(accountResponse);
    }

    // 회원 탈퇴
    @DeleteMapping("/delete")
    public ResponseEntity<AccountResponse> deleteAccount(@AuthenticationPrincipal Account account) {

        AccountResponse accountResponse = accountService.deleteAccount(account.getUserId());

        return ResponseEntity.ok(accountResponse);

    }

}
