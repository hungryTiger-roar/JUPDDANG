package com.jupddang.jupddang.plogging.dto.response;

public record PloggingResultResponse(
        String message,
        int totalScore,
        int occupiedGridCnt
) {}
