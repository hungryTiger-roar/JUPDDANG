package com.jupddang.jupddang.plogging.controller;

import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import com.jupddang.jupddang.plogging.service.PloggingService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;
import java.security.Principal;

@Slf4j
@Controller
@RequiredArgsConstructor
public class PloggingSocketController {

    private final PloggingService ploggingService;

    /**
     * 실시간 위치 추적 및 점령 로직 처리
     * 클라이언트 전송지: /pub/plogging/track
     */
    @MessageMapping("/plogging/track")
    public void trackLocation(LocationRequest request, SimpMessageHeaderAccessor accessor) {
        Principal user = accessor.getUser();
        if (user != null) {
            String userId = user.getName();
            // log.debug("Location received from {}: lat={}, lon={}", userId,
            // request.getLat(), request.getLon());
            ploggingService.processLocation(userId, request);
        } else {
            log.warn("Anonymous location tracking attempt.");
        }
    }
}