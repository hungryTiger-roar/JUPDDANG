package com.jupddang.jupddang.plogging.dto.request;

import java.util.List;

public record PloggingEndRequest(
                Long ploggingId,
                String content,
                Double distance, // 이동 거리 (km)
                List<String> LineString, // 이동 경로 좌표
                List<String> trashImages, // 쓰레기 사진 URL
                Integer endTime // 소요 시간 (초 단위) - 타임스탬프가 아님!
) {
}
