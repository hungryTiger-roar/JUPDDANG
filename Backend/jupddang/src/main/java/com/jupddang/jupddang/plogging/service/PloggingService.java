package com.jupddang.jupddang.plogging.service;


import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

public interface PloggingService {
    PloggingResultResponse endPlogging(Long userId, PloggingEndRequest request);
    void test();
}
