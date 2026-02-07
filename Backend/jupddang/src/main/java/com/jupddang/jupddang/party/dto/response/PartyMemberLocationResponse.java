package com.jupddang.jupddang.party.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PartyMemberLocationResponse {
    private String userId;
    private Double lat;
    private Double lon;
    private Double totalDistance;
    private Integer elapsedTime;  // 초 단위
    private Integer occupiedCount;
    private Double occupyProgress;
    private String currentH3Index;
}
