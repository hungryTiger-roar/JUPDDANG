package com.jupddang.jupddang.plogging.controller;

import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import com.jupddang.jupddang.plogging.service.PloggingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Controller;
import java.security.Principal;

@Slf4j
@Controller
@RequiredArgsConstructor
public class PloggingSocketController {

    private final PloggingService ploggingService;

    // 예시 1: Principal 사용 시
    @MessageMapping("/plogging/location")
    public void sendLocation(Principal principal, @Payload LocationRequest request) {
        // Principal.getName()은 보통 String ID를 반환합니다.
        String userId = principal.getName(); 
        ploggingService.processLocation(userId, request);
    }

    // 예시 2: DestinationVariable 사용 시 (경로에 ID가 있는 경우)
    // 기존: @DestinationVariable Long userId
    // 변경: @DestinationVariable String userId
    @MessageMapping("/plogging/{userId}/location")
    public void sendLocationWithId(@DestinationVariable String userId, @Payload LocationRequest request) {
        ploggingService.processLocation(userId, request);
    }
}