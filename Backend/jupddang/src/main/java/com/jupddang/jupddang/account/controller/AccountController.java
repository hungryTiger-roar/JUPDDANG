package com.jupddang.jupddang.account.controller;

import com.jupddang.jupddang.account.dto.AccountCreateRequest;
import com.jupddang.jupddang.account.dto.AccountLoginRequest;
import com.jupddang.jupddang.account.dto.AccountResponse;
import com.jupddang.jupddang.account.dto.AccountUpdateRequest;
import com.jupddang.jupddang.account.service.AccountService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/account")
public class AccountController {

    private final AccountService accountService;

    public AccountController(AccountService accountService) {
        this.accountService = accountService;
    }

    // 회원가입
    @PostMapping("/signup")
    @ResponseStatus(HttpStatus.CREATED)
    public AccountResponse signup(@RequestBody AccountCreateRequest request) {
        return accountService.createAccount(request);
    }

    // 로그인
    @PostMapping("/login")
    public AccountResponse login(@RequestBody AccountLoginRequest request) {
        return accountService.login(request);
    }

    // 전체 계정 정보 조회
    @GetMapping
    public List<AccountResponse> getAccounts() {
        return accountService.getAllAccounts();
    }

    // 내 프로필 조회
    @GetMapping("myprofile/{userId}")
    public AccountResponse getAccount(@PathVariable String userId) {
        return accountService.getAccount(userId);
    }

    // 내 프로필 수정
    @PatchMapping("myprofile/{userId}")
    public AccountResponse updateAccount(@PathVariable String userId, @RequestBody AccountUpdateRequest request) {
        return accountService.updateAccount(userId, request);
    }

    // 회원 탈퇴
    @DeleteMapping("/{userId}")
    public AccountResponse deleteAccount(@PathVariable String userId) {
        return accountService.deleteAccount(userId);
    }
}
