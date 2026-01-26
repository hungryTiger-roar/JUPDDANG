package com.jupddang.jupddang.trashcan.controller;

import com.jupddang.jupddang.trashcan.dto.TrashcanListResponse;
import com.jupddang.jupddang.trashcan.service.TrashcanService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/v1/trashcans")
@RequiredArgsConstructor
public class TrashcanController {

    private final TrashcanService trashcanService;

    /**
     * 지도 영역 내 쓰레기통 조회
     *
     * GET /api/v1/trashcans?minLatitude=37.5&maxLatitude=37.6&minLongitude=126.9&maxLongitude=127.0
     */
    @GetMapping
    public ResponseEntity<TrashcanListResponse> getTrashcans(
            @RequestParam Double minLatitude,
            @RequestParam Double maxLatitude,
            @RequestParam Double minLongitude,
            @RequestParam Double maxLongitude) {

        log.info("쓰레기통 조회 요청 - 위도: [{}, {}], 경도: [{}, {}]",
                minLatitude, maxLatitude, minLongitude, maxLongitude);

        TrashcanListResponse response = trashcanService.getTrashcansInArea(
                minLatitude, maxLatitude, minLongitude, maxLongitude
        );

        return ResponseEntity.ok(response);
    }
}