package com.jupddang.jupddang.plogging.dto.request;

import java.time.LocalDateTime;
import java.util.List;

public record PloggingEndRequest(
        Long ploggingId,
        Double distance,     // 이동 거리
        List<String> LineString, // 이동 경로 좌표
        List<String> trashImages, // 쓰레기 사진 URL
        Integer endTime //시간 or
) {}
