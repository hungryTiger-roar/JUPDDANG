//package com.jupddang.jupddang.plogging.controller;
//
//import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
//import com.jupddang.jupddang.plogging.dto.response.PloggingResultResponse;
//import com.jupddang.jupddang.plogging.service.PloggingService;
//import jakarta.validation.Valid;
//import lombok.RequiredArgsConstructor;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//@RestController
//@RequestMapping("/api/v1/plogging")
//@RequiredArgsConstructor
//public class PloggingController {
//
//    @O
//    private final PloggingService ploggingService;
//
//    @PostMapping("/end")
//    public ResponseEntity<PloggingResultResponse> endPlogging(
//            @RequestBody @Valid PloggingEndRequest request, // @Valid 추가
//            @RequestAttribute("userId") Long userId
//    ) {
//        // 서비스 호출
//        PloggingResultResponse response = ploggingService.endPlogging(userId, request);
//
//        // 결과 반환
//        return ResponseEntity.ok(response);
//    }
//
//}
