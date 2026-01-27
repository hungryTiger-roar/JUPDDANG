package com.jupddang.jupddang.party.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.party.dto.request.PartyCreateRequest;
import com.jupddang.jupddang.party.dto.request.PartyJoinRequest;
import com.jupddang.jupddang.party.dto.response.*;
import com.jupddang.jupddang.party.service.PartyService;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/party")
@Tag(name = "party api", description = "파티 관련 API")
public class PartyController {

    private final PartyService partyService;
    private final ObjectMapper objectMapper;

    public PartyController(PartyService partyService, ObjectMapper objectMapper) {
        this.partyService = partyService;
        this.objectMapper = objectMapper;
    }

    @GetMapping("/id")
    @Operation(summary = "초대 코드 생성")
    public ResponseEntity<InviteCodeResponse> createInviteCode() {
        String inviteCode = partyService.generateUniqueInviteCode();
        InviteCodeResponse response = InviteCodeResponse.of(inviteCode);
        return ResponseEntity.ok(response);
    }

    @PostMapping
    @Operation(summary = "파티 생성")
    public ResponseEntity<PartyCreateResponse> createParty(
            @RequestBody PartyCreateRequest request,
            @AuthenticationPrincipal Account account
    ) {
        String userId = account.getUserId();
        PartyCreateResponse response = partyService.createParty(request, userId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/join")
    @Operation(summary = "파티 참여")
    public ResponseEntity<PartyJoinResponse> joinParty(
            @RequestBody PartyJoinRequest request,
            @AuthenticationPrincipal Account account
    ) {
        String userId = account.getUserId();
        PartyJoinResponse response = partyService.joinParty(request, userId);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{partyId}")
    @Operation(summary = "파티 상세 조회")
    public ResponseEntity<PartyDetailResponse> getPartyDetail(
            @PathVariable Long partyId,
            @AuthenticationPrincipal Account account
    ) {
        String userId = account.getUserId();
        PartyDetailResponse response = partyService.getPartyDetail(partyId, userId);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{partyId}/start")
    @Operation(summary = "파티 시작 (방장 전용)")
    public ResponseEntity<PartyStartResponse> startParty(
            @PathVariable Long partyId,
            @AuthenticationPrincipal Account account
    ) {
        String userId = account.getUserId();
        PartyStartResponse response = partyService.startParty(partyId, userId);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{partyId}/activities")
    @Operation(summary = "실시간 활동 상태 조회")
    public ResponseEntity<PartyActivityStatusResponse> getActivityStatus(
            @PathVariable Long partyId,
            @AuthenticationPrincipal Account account
    ) {
        String userId = account.getUserId();
        PartyActivityStatusResponse response = partyService.getActivityStatus(partyId, userId);
        return ResponseEntity.ok(response);
    }

    @PostMapping(value = "/{partyId}/activities/complete",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "개별 활동 완료")
    public ResponseEntity<ActivityCompleteResponse> completeActivity(
            @PathVariable Long partyId,
            @RequestPart("data") String dataJson,
            @RequestPart("beforeImage") MultipartFile beforeImage,
            @RequestPart("afterImage") MultipartFile afterImage,
            @RequestPart("mapImage") MultipartFile mapImage,
            @AuthenticationPrincipal Account account
    ) throws Exception {
        String userId = account.getUserId();

        // JSON String을 객체로 변환
        PloggingEndRequest request = objectMapper.readValue(dataJson, PloggingEndRequest.class);

        ActivityCompleteResponse response = partyService.completeActivity(
                partyId, userId, request, beforeImage, afterImage, mapImage
        );
        return ResponseEntity.ok(response);
    }
}