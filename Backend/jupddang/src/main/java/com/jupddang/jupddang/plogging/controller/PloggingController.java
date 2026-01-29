package com.jupddang.jupddang.plogging.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.service.PloggingService;
import io.swagger.v3.oas.annotations.Operation;
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
    @PostMapping(value ="/end", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "플로깅 종료 및 결과 생성")
    public ResponseEntity<PloggingResultResponse> endPlogging(
            @RequestPart("data") String dataJson,
            @RequestPart("beforeImage") MultipartFile beforeImage,
            @RequestPart("afterImage") MultipartFile afterImage,
            @RequestPart("mapImage") MultipartFile mapImage,
            @RequestHeader("userId") String userId
    ) throws Exception {
        // JSON String을 객체로 변환
        PloggingEndRequest request = objectMapper.readValue(dataJson, PloggingEndRequest.class);

        // 서비스 호출
        PloggingResultResponse response = ploggingService.endPlogging(
                userId,
                request,
                beforeImage,
                afterImage,
                mapImage
        );

        // 결과 반환
        return ResponseEntity.ok(response);
    }
}