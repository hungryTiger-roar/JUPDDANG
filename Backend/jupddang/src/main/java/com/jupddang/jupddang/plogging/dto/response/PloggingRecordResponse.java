package com.jupddang.jupddang.plogging.dto.response;

public record PloggingRecordResponse(

        Long ploggingId,
        String recordName,
        int times,
        Double distance,
        int score
        ) { }
