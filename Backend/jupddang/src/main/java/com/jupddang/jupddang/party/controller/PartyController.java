package com.jupddang.jupddang.party.controller;

import com.jupddang.jupddang.party.dto.InviteCodeResponse;
import com.jupddang.jupddang.party.service.PartyService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/party")
public class PartyController {

    private final PartyService partyService;

    public PartyController(PartyService partyService) {
        this.partyService = partyService;
    }

    /**
     * 초대 코드 생성 API
     * GET /api/party/id
     *
     * @return 200 OK - 생성된 초대 코드 및 메시지
     */
    @GetMapping("/id")
    public ResponseEntity<InviteCodeResponse> createInviteCode() {
        String inviteCode = partyService.generateUniqueInviteCode();
        InviteCodeResponse response = InviteCodeResponse.of(inviteCode);

        return ResponseEntity.ok(response);
    }
}
