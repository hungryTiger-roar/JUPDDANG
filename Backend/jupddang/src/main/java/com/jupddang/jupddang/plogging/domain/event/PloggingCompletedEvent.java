package com.jupddang.jupddang.plogging.domain.event;

import lombok.Builder;
import org.springframework.web.multipart.MultipartFile;

@Builder
public record PloggingCompletedEvent(
                Long ploggingId,
                String userId, // Principal Name (String)
                int occupiedGridCnt,
                int raidScore, // 레이드 기여도 점수
                int ploggingScore, // ✅ 플로깅 점수 (distance, times, grids 기반)
                MultipartFile beforeImage,
                MultipartFile afterImage,
                MultipartFile mapImage) {
}