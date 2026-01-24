package com.jupddang.jupddang.plogging.controller;

import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.service.PloggingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/v1/plogging")
@RequiredArgsConstructor
public class PloggingController {

    private final PloggingService ploggingService;
    /**
     * 플로깅 종료 + 피드 생성
     * POST /api/v1/plogging/end
     */
    @PostMapping(value ="/end", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<PloggingResultResponse> endPlogging(
            @RequestPart("data") @Valid PloggingEndRequest request,
            @RequestPart("beforeImage") MultipartFile beforeImage,
            @RequestPart("afterImage") MultipartFile afterImage,
            @RequestPart("mapImage") MultipartFile mapImage,
            @RequestHeader("userId") Long userId
    ) {
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
