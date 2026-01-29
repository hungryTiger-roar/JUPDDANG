package com.jupddang.jupddang.plogging.dto.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;
import java.util.List;

public record PloggingEndRequest(
        Long ploggingId,
        String content,
        Double distance,     // 이동 거리
        Integer score,            // 획득 점수

        @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
        LocalDateTime endTime
) {}
