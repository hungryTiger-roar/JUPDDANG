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

    /**
     * Case 1: 개인(Solo) 플로깅
     * URL: /app/plogging/location/solo
     */
    @MessageMapping("/plogging/location/solo")
    public void sendSoloLocation(
            @Payload LocationRequest request,
            Principal principal
    ) {
        // 1. 인증 정보 검증
        if (principal == null) {
            log.warn("Unauthenticated user attempted to send location.");
            return;
        }

        // 2. 실제 ID 추출 (Spring Security 설정에 따라 String 형태의 PK 반환)
        String userId = principal.getName();

        // 3. 개인 모드 설정
        request.setPartyId(null);

        // 4. 서비스 호출
        log.debug("Solo Location Update: User={}, Lat={}, Lon={}", userId, request.getLat(), request.getLon());
        ploggingService.processLocation(userId, request);
    }

    /**
     * Case 2: 파티(Party) 플로깅
     * URL: /app/plogging/location/party/{partyId}
     */
    @MessageMapping("/plogging/location/party/{partyId}")
    public void sendPartyLocation(
            @DestinationVariable Long partyId,
            @Payload LocationRequest request,
            Principal principal
    ) {
        // 1. 인증 정보 검증
        if (principal == null) {
            log.warn("Unauthenticated user attempted to send party location.");
            return;
        }

        // 2. 실제 ID 추출
        String userId = principal.getName();

        // 3. 파티 ID 주입
        request.setPartyId(partyId);

        // 4. 서비스 호출
        log.debug("Party Location Update: User={}, Party={}, Lat={}, Lon={}", userId, partyId, request.getLat(), request.getLon());

        ploggingService.processLocation(userId, request);
    }
}