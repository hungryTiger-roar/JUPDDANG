package com.jupddang.jupddang.plogging.dto.response;

import java.util.List;

/**
 * 쓰레기 탐지 응답 DTO
 */
public record TrashDetectionResponse(
        boolean success,
        String message,
        List<TrashBoundingBox> detections // 탐지된 쓰레기 목록
) {
}
