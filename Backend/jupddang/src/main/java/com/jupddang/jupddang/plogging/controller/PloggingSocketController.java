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
     * URL: /pub/plogging/location/solo
     */
    @MessageMapping("/plogging/location/solo")
    public void sendSoloLocation(@Payload LocationRequest request, Principal principal) {
        if (principal == null) {
            log.warn("인증되지 않은 사용자의 위치 전송 시도");
            return;
        }

        try {
            String userId = principal.getName();
            request.setPartyId(null); // 개인 모드 강제 설정

            // log.debug("Solo Location: User={}, Lat={}, Lon={}", userId, request.getLat(), request.getLon());
            ploggingService.processLocation(userId, request);

        } catch (Exception e) {
            log.error("개인 플로깅 위치 처리 실패: {}", e.getMessage());
        }
    }

    /**
     * Case 2: 파티(Party) 플로깅
     * URL: /pub/plogging/location/party/{partyId}
     */
    @MessageMapping("/plogging/location/party/{partyId}")
    public void sendPartyLocation(
            @DestinationVariable("partyId") Long partyId, // [Fix] 이름 명시
            @Payload LocationRequest request,
            Principal principal
    ) {
        if (principal == null) return;

        try {
            String userId = principal.getName();
            request.setPartyId(partyId);
            ploggingService.processLocation(userId, request);
        } catch (Exception e) {
            log.error("파티 플로깅 위치 처리 실패: {}", e.getMessage());
        }
    }
}