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
}