package com.jupddang.jupddang.plogging.service;


import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.dto.response.PloggingTempDetailResponse;
import com.jupddang.jupddang.plogging.dto.response.PloggingTempSaveResponse;
import org.springframework.web.multipart.MultipartFile;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

public interface PloggingService {
    PloggingResultResponse endPlogging(
            String userId,
            PloggingEndRequest request,
            MultipartFile beforeImage,
            MultipartFile afterImage,
            MultipartFile mapImage
    );
    void processLocation(String userId, LocationRequest request);
    PloggingTempDetailResponse getTempPloggingDetail(String userId, Long ploggingId);
    PloggingTempSaveResponse savePloggingTemp(
            String userId,
            PloggingEndRequest request,
            MultipartFile before,
            MultipartFile after,
            MultipartFile map);
    List<PloggingTempDetailResponse> getTempPloggings(String userId);
}
