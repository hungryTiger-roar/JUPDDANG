package com.jupddang.jupddang.trashcan.controller;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.trashcan.dto.TrashcanCreateRequest;
import com.jupddang.jupddang.trashcan.dto.TrashcanDetailDto;
import com.jupddang.jupddang.trashcan.dto.TrashcanListResponse;
import com.jupddang.jupddang.trashcan.entity.TrashcanStatus;
import com.jupddang.jupddang.trashcan.service.TrashcanService;
import io.swagger.v3.oas.annotations.Operation; // 추가됨
import io.swagger.v3.oas.annotations.Parameter; // [필수] 추가됨
import io.swagger.v3.oas.annotations.tags.Tag; // 추가됨
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
@Tag(name = "trashcan api", description = "쓰레기통 관련 API") // Swagger 태그 추가
public class TrashcanController {

        private final TrashcanService trashcanService;

        /**
         * 지도 영역 내 쓰레기통 조회
         */
        @GetMapping
        @Operation(summary = "영역 내 쓰레기통 조회", description = "지도 화면의 위경도 범위를 기반으로 쓰레기통을 조회합니다.")
        public ResponseEntity<TrashcanListResponse> getTrashcans(
                        @RequestParam(name = "minLatitude") Double minLatitude,
                        @RequestParam(name = "maxLatitude") Double maxLatitude,
                        @RequestParam(name = "minLongitude") Double minLongitude,
                        @RequestParam(name = "maxLongitude") Double maxLongitude) {

                log.info("쓰레기통 조회 요청 - 위도: [{}, {}], 경도: [{}, {}]",
                                minLatitude, maxLatitude, minLongitude, maxLongitude);

                try {
                        TrashcanListResponse response = trashcanService.getTrashcansInArea(
                                        minLatitude, maxLatitude, minLongitude, maxLongitude);

                        return ResponseEntity.ok(response);
                } catch (IllegalArgumentException e) {
                        log.error("Invalid parameters: {}", e.getMessage());
                        return ResponseEntity.badRequest().build();
                } catch (Exception e) {
                        log.error("Unexpected error in getTrashcans", e);
                        return ResponseEntity.internalServerError().build();
                }
        }

        /**
         * 새로운 쓰레기통 위치 추가
         */
        @PostMapping
        @Operation(summary = "쓰레기통 위치 제보/추가")
        public ResponseEntity<TrashcanDetailDto> createTrashcan(
                        @RequestBody TrashcanCreateRequest request,
                        // [수정] Swagger 숨김 처리
                        @Parameter(hidden = true) @AuthenticationPrincipal Account account) {

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
        @Operation(summary = "쓰레기통 검증(좋아요/인증)")
        public ResponseEntity<TrashcanDetailDto> verifyTrashcan(
                        @PathVariable(name = "trashcanId") Long trashcanId,
                        // [수정] Swagger 숨김 처리
                        @Parameter(hidden = true) @AuthenticationPrincipal Account account) {

                log.info("쓰레기통 검증 요청 - trashcanId: {}, userId: {}",
                                trashcanId, account.getUserId());

                TrashcanDetailDto response = trashcanService.verifyTrashcan(trashcanId, account);

                return ResponseEntity.ok(response);
        }

        /**
         * 내가 제안한 쓰레기통 목록 조회
         */
        @GetMapping("/my")
        @Operation(summary = "내가 제안한 쓰레기통 목록 조회")
        public ResponseEntity<TrashcanListResponse> getMyTrashcans(
                        @RequestParam(name = "status", required = false) TrashcanStatus status,
                        // [수정] Swagger 숨김 처리
                        @Parameter(hidden = true) @AuthenticationPrincipal Account account) {

                log.info("내가 제안한 쓰레기통 조회 - userId: {}, status: {}",
                                account.getUserId(), status);

                TrashcanListResponse response = trashcanService.getMyTrashcans(account, status);

                return ResponseEntity.ok(response);
        }
}