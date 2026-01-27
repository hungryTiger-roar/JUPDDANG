package com.jupddang.jupddang.trashcan.controller;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.trashcan.dto.TrashcanCreateRequest;
import com.jupddang.jupddang.trashcan.dto.TrashcanDetailDto;
import com.jupddang.jupddang.trashcan.dto.TrashcanListResponse;
import com.jupddang.jupddang.trashcan.entity.TrashcanStatus;
import com.jupddang.jupddang.trashcan.service.TrashcanService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/api/v1/trashcans")
@RequiredArgsConstructor
public class TrashcanController {

    private final TrashcanService trashcanService;

    /**
     * 지도 영역 내 쓰레기통 조회
     */
    @GetMapping
    public ResponseEntity<TrashcanListResponse> getTrashcans(
            @RequestParam(name = "minLatitude") Double minLatitude,
            @RequestParam(name = "maxLatitude") Double maxLatitude,
            @RequestParam(name = "minLongitude") Double minLongitude,
            @RequestParam(name = "maxLongitude") Double maxLongitude) {

        log.info("쓰레기통 조회 요청 - 위도: [{}, {}], 경도: [{}, {}]",
                minLatitude, maxLatitude, minLongitude, maxLongitude);

        TrashcanListResponse response = trashcanService.getTrashcansInArea(
                minLatitude, maxLatitude, minLongitude, maxLongitude
        );

        return ResponseEntity.ok(response);
    }

    /**
     * 새로운 쓰레기통 위치 추가
     */
    @PostMapping
    public ResponseEntity<TrashcanDetailDto> createTrashcan(
            @RequestBody TrashcanCreateRequest request,
            @AuthenticationPrincipal Account account) {

        String userId = account.getUserId();

        log.info("쓰레기통 위치 추가 요청 - userId: {}, lat: {}, lng: {}",
                userId, request.latitude(), request.longitude());

        TrashcanDetailDto response = trashcanService.createTrashcan(request, userId);

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * 쓰레기통 검증
     */
    @PostMapping("/{trashcanId}/verify")
    public ResponseEntity<TrashcanDetailDto> verifyTrashcan(
            @PathVariable(name = "trashcanId") Long trashcanId,
            @AuthenticationPrincipal Account account) {

        log.info("쓰레기통 검증 요청 - trashcanId: {}, userId: {}",
                trashcanId, account.getUserId());

        TrashcanDetailDto response = trashcanService.verifyTrashcan(trashcanId, account);

        return ResponseEntity.ok(response);
    }

    /**
     * 내가 제안한 쓰레기통 목록 조회
     */
    @GetMapping("/my")
    public ResponseEntity<TrashcanListResponse> getMyTrashcans(
            @RequestParam(name = "status", required = false) TrashcanStatus status,
            @AuthenticationPrincipal Account account) {

        log.info("내가 제안한 쓰레기통 조회 - userId: {}, status: {}",
                account.getUserId(), status);

        TrashcanListResponse response = trashcanService.getMyTrashcans(account, status);

        return ResponseEntity.ok(response);
    }
}