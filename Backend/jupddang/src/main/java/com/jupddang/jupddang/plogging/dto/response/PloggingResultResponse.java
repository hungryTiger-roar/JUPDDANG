package com.jupddang.jupddang.plogging.dto.response;

public record PloggingResultResponse(
        String message,
        Double distance,
        int occupiedGridCnt,
        int raidScore
) {}