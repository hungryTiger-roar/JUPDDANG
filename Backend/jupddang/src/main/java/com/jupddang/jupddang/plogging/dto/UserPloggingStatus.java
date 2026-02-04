package com.jupddang.jupddang.plogging.dto;

import java.io.Serializable;

public record UserPloggingStatus(
                String h3Index,
                Double lastLat,
                Double lastLon,
                Double totalDistance,
                Long entryTime,
                boolean isOccupied // true면 이미 이번 방문에서 점령/정산 완료됨
) implements Serializable {
}