package com.jupddang.jupddang.plogging.dto.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;

public record PloggingEndRequest(
        Long ploggingId,
        String content,
        Double distance,     // 이동 거리
        Integer times,            // 소요 시간 (변수명 times 통일)
        Integer score            // 획득 점수

//        @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
//        LocalDateTime endTime
) {}
