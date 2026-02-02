package com.jupddang.jupddang.plogging.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.service.PloggingService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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

            @RequestHeader("userId") String userId) throws Exception {
        // JSON String을 객체로 변환
        PloggingEndRequest request = objectMapper.readValue(dataJson, PloggingEndRequest.class);

        // 서비스 호출
        PloggingResultResponse response = ploggingService.endPlogging(
                userId,
                request,
                beforeImage,
                afterImage,
                mapImage);

        // 결과 반환
        return ResponseEntity.ok(response);
    }
}