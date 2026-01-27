package com.jupddang.jupddang.trashcan.dto;

import com.jupddang.jupddang.trashcan.entity.Trashcan;
import com.jupddang.jupddang.trashcan.entity.TrashcanStatus;

/**
 * 쓰레기통 상세 정보 DTO (생성/수정 응답용)
 */
public record TrashcanDetailDto(
        Long id,
        Double latitude,
        Double longitude,
        String address,
        TrashcanStatus status,
        String reportedBy,
        Integer verificationCount
) {
    /**
     * Entity를 DTO로 변환
     */
    public static TrashcanDetailDto from(Trashcan trashcan) {
        String reportedByUserId = trashcan.getReportedBy() != null
                ? trashcan.getReportedBy().getUserId()
                : null;

        return new TrashcanDetailDto(
                trashcan.getId(),
                trashcan.getLatitude(),
                trashcan.getLongitude(),
                trashcan.getAddress(),
                trashcan.getStatus(),
                reportedByUserId,
                trashcan.getVerificationCount()
        );
    }
}