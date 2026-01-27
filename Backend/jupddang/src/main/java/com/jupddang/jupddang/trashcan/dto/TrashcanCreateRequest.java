package com.jupddang.jupddang.trashcan.dto;

/**
 * 쓰레기통 위치 추가 요청
 */
public record TrashcanCreateRequest(
        Double latitude,
        Double longitude,
        String address
) {
    /**
     * 유효성 검증
     */
    public void validate() {
        if (latitude == null || longitude == null) {
            throw new IllegalArgumentException("위도와 경도는 필수입니다");
        }

        // 한국 좌표 범위 검증
        if (latitude < 33.0 || latitude > 43.0) {
            throw new IllegalArgumentException("위도는 33.0 ~ 43.0 범위여야 합니다");
        }

        if (longitude < 124.0 || longitude > 132.0) {
            throw new IllegalArgumentException("경도는 124.0 ~ 132.0 범위여야 합니다");
        }
    }
}