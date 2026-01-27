package com.jupddang.jupddang.plogging.dto.response;

public record PloggingResultResponse(
        Long ploggingId,
        Long postId,
        String message,
        Double distance,
        int occupiedGridCnt,
        int raidScore
) {}