package com.jupddang.jupddang.plogging.dto.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;

public record PloggingEndRequest(
                Long ploggingId,
                String content,
                Double distance, // 이동 거리 (km)
                Integer times, // 소요 시간 (초) - Plogging 엔티티 필드명과 일치
                String recordTitle,
                Long partyId,
                Integer score,
                @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss") LocalDateTime endTime // 종료 시각
) {

}
