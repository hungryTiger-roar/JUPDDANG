package com.jupddang.jupddang.plogging.controller;

import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
import com.jupddang.jupddang.plogging.service.PloggingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/plogging")
@RequiredArgsConstructor
public class PloggingController {

    private final PloggingService ploggingService;

//    @PostMapping("/end")
//    public ResponseEntity<PloggingResultResponse> endPlogging(
//            @RequestBody PloggingEndRequest request,
//            @RequestAttribute("userId") Long userId // 인증된 유저 ID
//    ) {
//        return ResponseEntity.ok();
//    }

}
