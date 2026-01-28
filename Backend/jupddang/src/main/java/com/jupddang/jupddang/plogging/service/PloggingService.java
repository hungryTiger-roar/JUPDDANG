package com.jupddang.jupddang.plogging.service;


import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import org.springframework.web.multipart.MultipartFile;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

public interface PloggingService {
    PloggingResultResponse endPlogging(
            String userId,
            PloggingEndRequest request,
            MultipartFile beforeImage,
            MultipartFile afterImage,
            MultipartFile mapImage
    );
    void processLocation(String userId, LocationRequest request);
}
