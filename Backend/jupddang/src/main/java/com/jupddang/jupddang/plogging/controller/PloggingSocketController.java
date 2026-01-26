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
        Long userId = 1L; // TODO: principal.getName() 등으로 실제 ID 추출

        // 개인 모드이므로 partyId는 null로 명시
        request.setPartyId(null);

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
        Long userId = 1L; // TODO: principal.getName() 등으로 실제 ID 추출

        // 경로변수에서 받은 partyId 주입
        request.setPartyId(partyId);

        ploggingService.processLocation(userId, request);
    }
}