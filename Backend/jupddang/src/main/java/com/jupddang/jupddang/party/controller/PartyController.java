package com.jupddang.jupddang.party.controller;

import com.jupddang.jupddang.party.dto.*;
import com.jupddang.jupddang.party.service.PartyService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/party")
@Tag(name = "party api", description = "파티 관련 API")
public class PartyController {

    private final PartyService partyService;

    public PartyController(PartyService partyService) {
        this.partyService = partyService;
    }

    // === 기존 엔드포인트 유지 ===

    /**
     * 초대 코드 생성 API
     * GET /api/party/id
     *
     * @return 200 OK - 생성된 초대 코드 및 메시지
     */
    @GetMapping("/id")
    @Operation(summary = "초대 코드 생성")
    public ResponseEntity<InviteCodeResponse> createInviteCode() {
        String inviteCode = partyService.generateUniqueInviteCode();
        InviteCodeResponse response = InviteCodeResponse.of(inviteCode);
        return ResponseEntity.ok(response);
    }

    // === 새로운 엔드포인트 추가 ===

    /**
     * 파티 생성
     * POST /api/party
     */
    @PostMapping
    @Operation(summary = "파티 생성")
    public ResponseEntity<PartyCreateResponse> createParty(
            @RequestBody PartyCreateRequest request,
            @RequestHeader("User-Id") Long userId
    ) {
        PartyCreateResponse response = partyService.createParty(request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * 파티 참여
     * POST /api/party/join
     */
    @PostMapping("/join")
    @Operation(summary = "파티 참여")
    public ResponseEntity<PartyJoinResponse> joinParty(
            @RequestBody PartyJoinRequest request,
            @RequestHeader("User-Id") Long userId
    ) {
        PartyJoinResponse response = partyService.joinParty(request, userId);
        return ResponseEntity.ok(response);
    }

    // 새로 추가
    @GetMapping("/{partyId}")
    @Operation(summary = "파티 상세 조회")
    public ResponseEntity<PartyDetailResponse> getPartyDetail(
            @PathVariable Long partyId,
            @RequestHeader("User-Id") Long userId
    ) {
        PartyDetailResponse response = partyService.getPartyDetail(partyId, userId);
        return ResponseEntity.ok(response);
    }
}