package com.jupddang.jupddang.fcm;

import com.jupddang.jupddang.account.entity.Account;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/fcm")
public class FcmController {

    private final FcmService fcmService;

    /**
     * FCM 토큰 등록
     */
    @PostMapping("/token")
    public ResponseEntity<String> registerToken(@RequestBody FcmTokenRequest request, @AuthenticationPrincipal Account account) {

        fcmService.saveToken(request, account.getUserId());

        return ResponseEntity.ok(account.getUserId() + "님 Fcm 토큰 저장 완료");
    }

    @DeleteMapping("/delete")
    public ResponseEntity<String> logout(
            @AuthenticationPrincipal Account account
    ) {
        fcmService.logout(account.getUserId());

        return ResponseEntity.ok(account.getUserId() + "님 Fcm 토큰 삭제 완료");
    }

}
