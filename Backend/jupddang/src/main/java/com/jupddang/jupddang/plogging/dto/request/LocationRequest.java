package com.jupddang.jupddang.plogging.dto.request;

import lombok.Data;

@Data
public class LocationRequest {
    private Double lat;
    private Double lon;
    private Long partyId; // 없으면 null (개인)
}