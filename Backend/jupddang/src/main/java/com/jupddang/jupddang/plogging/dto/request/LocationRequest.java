package com.jupddang.jupddang.plogging.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LocationRequest {
    private Double lat;
    private Double lon;
    private Long partyId;
    private Integer elapsedTime; // 초 단위 경과 시간
    private Double totalDistance; // 총 이동 거리 (미터)
    private Integer score; // 점수
    private String currentH3Index;
    private Double occupyProgress;
}