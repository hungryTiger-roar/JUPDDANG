package com.jupddang.jupddang.account.controller;

import com.jupddang.jupddang.account.dto.AccountCreateRequest;
import com.jupddang.jupddang.account.dto.AccountLoginRequest;
import com.jupddang.jupddang.account.dto.AccountResponse;
import com.jupddang.jupddang.account.dto.AccountUpdateRequest;
import com.jupddang.jupddang.account.service.AccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
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
    public ResponseEntity<AccountResponse> login(@RequestBody AccountLoginRequest request) {

        AccountResponse login = accountService.login(request);

        return ResponseEntity.ok(login);
    }

    // 전체 계정 정보 조회
    @GetMapping
    public ResponseEntity<List<AccountResponse>> getAccounts() {

        List<AccountResponse> allAccounts = accountService.getAllAccounts();

        return ResponseEntity.ok(allAccounts);
    }

    // 내 프로필 조회
    @GetMapping("myprofile/{userId}")
    public ResponseEntity<AccountResponse> getAccount(@PathVariable String userId) {

        AccountResponse account = accountService.getAccount(userId);

        return ResponseEntity.ok(account);
    }

    // 내 프로필 수정
    @PatchMapping("myprofile/{userId}")
    public ResponseEntity<AccountResponse> updateAccount(@PathVariable String userId, @RequestBody AccountUpdateRequest request) {

        AccountResponse accountResponse = accountService.updateAccount(userId, request);

        return ResponseEntity.ok(accountResponse);
    }

    // 회원 탈퇴
    @DeleteMapping("/{userId}")
    public ResponseEntity<AccountResponse> deleteAccount(@PathVariable String userId) {

        AccountResponse accountResponse = accountService.deleteAccount(userId);

        return ResponseEntity.ok(accountResponse);

    }
}
