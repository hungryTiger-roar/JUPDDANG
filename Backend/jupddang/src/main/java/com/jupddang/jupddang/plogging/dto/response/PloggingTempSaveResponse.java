package com.jupddang.jupddang.plogging.dto.response;

public record PloggingTempSaveResponse(
        Long ploggingId,
        String message,
        Integer times,
        Double distance,
        String recordTitle,
        Integer occupiedCount,
        Integer raidScore
) {
}
