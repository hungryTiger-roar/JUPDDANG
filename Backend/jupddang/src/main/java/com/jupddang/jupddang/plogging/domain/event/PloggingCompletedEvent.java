package com.jupddang.jupddang.plogging.domain.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import org.springframework.web.multipart.MultipartFile;

/**
 * Plogging 완료 Domain Event
 * Plogging 도메인 → SNS 도메인으로 전달
 */
@Getter
@Builder
@AllArgsConstructor
public class PloggingCompletedEvent {
    private final Long ploggingId;
    private final Long userId;
    private final MultipartFile beforeImage;
    private final MultipartFile afterImage;
    private final MultipartFile mapImage;
    private final int occupiedGridCnt;
}