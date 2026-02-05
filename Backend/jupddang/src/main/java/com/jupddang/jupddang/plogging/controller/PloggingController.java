package com.jupddang.jupddang.plogging.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.dto.response.PloggingTempDetailResponse;
import com.jupddang.jupddang.plogging.dto.response.PloggingTempSaveResponse;
import com.jupddang.jupddang.plogging.service.PloggingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/v1/plogging")
@RequiredArgsConstructor
@Tag(name = "plogging api", description = "플로깅 관련 API")
public class PloggingController {

        private final PloggingService ploggingService;
        private final ObjectMapper objectMapper;

        /**
         * 플로깅 종료 + 피드 생성
         * POST /api/v1/plogging/end
         */

        @PostMapping(value = "/end", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
        @Operation(summary = "플로깅 종료 및 결과 생성", description = "플로깅 활동을 종료하고 결과를 저장합니다. data 파라미터는 반드시 유효한 JSON 문자열이어야 합니다.")
        public ResponseEntity<PloggingResultResponse> endPlogging(
                        @RequestPart("data") @io.swagger.v3.oas.annotations.Parameter(description = "플로깅 종료 데이터 (JSON 문자열)", required = true, schema = @Schema(type = "string", example = "{\"ploggingId\":1,\"content\":\"오늘 플로깅 완료!\",\"distance\":2.5,\"LineString\":[\"37.5665,126.9780\",\"37.5675,126.9790\"],\"trashImages\":[\"https://example.com/trash1.jpg\"],\"endTime\":3600}")) String dataJson,

                        @RequestPart("beforeImage") @io.swagger.v3.oas.annotations.Parameter(description = "플로깅 시작 전 사진") MultipartFile beforeImage,

                        @RequestPart("afterImage") @io.swagger.v3.oas.annotations.Parameter(description = "플로깅 완료 후 사진") MultipartFile afterImage,

                        @RequestPart("mapImage") @io.swagger.v3.oas.annotations.Parameter(description = "경로 지도 이미지") MultipartFile mapImage,

                        @AuthenticationPrincipal Account account) throws Exception {
                // JSON String을 객체로 변환
                PloggingEndRequest request = objectMapper.readValue(dataJson, PloggingEndRequest.class);

                // 서비스 호출
                PloggingResultResponse response = ploggingService.endPlogging(
                                account.getUserId(),
                                request,
                                beforeImage,
                                afterImage,
                                mapImage);

                // 결과 반환
                return ResponseEntity.ok(response);
        }

        @PostMapping(value = "/temp", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
        @Operation(summary = "플로깅 결과 임시 저장", description = "플로깅 결과 화면에서 작성 중인 내용을 임시 저장합니다. "
                        + "data 파라미터는 PloggingEndRequest JSON 문자열이어야 합니다.")
        public ResponseEntity<PloggingTempSaveResponse> savePloggingTemp(
                        @RequestPart("data") String dataJson,
                        @RequestPart(value = "beforeImage", required = false) MultipartFile beforeImage,
                        @RequestPart(value = "afterImage", required = false) MultipartFile afterImage,
                        @RequestPart(value = "mapImage", required = false) MultipartFile mapImage,
                        @AuthenticationPrincipal Account account) throws Exception {

                // JSON → DTO 변환
                PloggingEndRequest request = objectMapper.readValue(dataJson, PloggingEndRequest.class);

                // 서비스 호출
                PloggingTempSaveResponse response = ploggingService.savePloggingTemp(
                                account.getUserId(),
                                request,
                                beforeImage,
                                afterImage,
                                mapImage);

                return ResponseEntity.ok(response);
        }

    /**
     * 임시 저장 목록 조회
     */
    @GetMapping("/temp")
    public ResponseEntity<List<PloggingTempDetailResponse>> getTempPloggings(
            @AuthenticationPrincipal Account account) {

        List<PloggingTempDetailResponse> temps = ploggingService.getTempPloggings(account.getUserId());
        return ResponseEntity.ok(temps);
    }

    /**
     * 임시 저장 상세 조회 (게시글 폼에 채우기)
     */
    @GetMapping("/temp/{ploggingId}")
    public ResponseEntity<PloggingTempDetailResponse> getTempPloggingDetail(
            @AuthenticationPrincipal Account account,
            @PathVariable Long ploggingId) {

        PloggingTempDetailResponse detail = ploggingService.getTempPloggingDetail(account.getUserId(), ploggingId);
        return ResponseEntity.ok(detail);
    }

}