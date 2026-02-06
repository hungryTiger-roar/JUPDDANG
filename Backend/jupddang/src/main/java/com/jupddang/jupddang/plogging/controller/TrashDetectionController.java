package com.jupddang.jupddang.plogging.controller;

import com.jupddang.jupddang.plogging.dto.response.TrashDetectionResponse;
import com.jupddang.jupddang.plogging.service.TrashDetectionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * 플로깅 중 쓰레기 탐지 API
 */
@RestController
@RequestMapping("/api/v1/plogging/trash")
@RequiredArgsConstructor
@Tag(name = "쓰레기 탐지 API", description = "플로깅 중 촬영한 사진에서 쓰레기를 탐지합니다")
public class TrashDetectionController {

    private final TrashDetectionService trashDetectionService;

    /**
     * 쓰레기 탐지 API
     * POST /api/v1/plogging/trash/detect
     */
    @PostMapping(value = "/detect", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "쓰레기 탐지", description = "이미지에서 쓰레기를 탐지하고 Bounding Box 좌표를 반환합니다. " +
            "좌표는 0~1000 스케일로 정규화되어 있으며, [ymin, xmin, ymax, xmax] 형식입니다.")
    public ResponseEntity<TrashDetectionResponse> detectTrash(
            @RequestPart("image") @Parameter(description = "분석할 이미지 파일 (JPEG, PNG 등)", required = true) MultipartFile image) {
        TrashDetectionResponse response = trashDetectionService.detectTrash(image);

        if (response.success()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.internalServerError().body(response);
        }
    }
}
