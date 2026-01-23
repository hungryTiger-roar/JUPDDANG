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
