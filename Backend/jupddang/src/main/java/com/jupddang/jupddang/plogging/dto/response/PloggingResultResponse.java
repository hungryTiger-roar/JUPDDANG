package com.jupddang.jupddang.plogging.dto.response;

public record PloggingResultResponse(
        Long ploggingId,
        Integer gainedScore,
        String message
) {}
