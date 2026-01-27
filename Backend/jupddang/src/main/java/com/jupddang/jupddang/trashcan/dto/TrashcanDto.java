package com.jupddang.jupddang.trashcan.dto;

import com.jupddang.jupddang.trashcan.entity.Trashcan;
import com.jupddang.jupddang.trashcan.entity.TrashcanStatus;

/**
 * 쓰레기통 조회 응답 DTO
 */
public record TrashcanDto(
        Long id,
        Double latitude,
        Double longitude,
        String address,
        TrashcanStatus status
) {
    /**
     * Entity를 DTO로 변환
     */
    public static TrashcanDto from(Trashcan trashcan) {
        return new TrashcanDto(
                trashcan.getId(),
                trashcan.getLatitude(),
                trashcan.getLongitude(),
                trashcan.getAddress(),
                trashcan.getStatus()
        );
    }
}