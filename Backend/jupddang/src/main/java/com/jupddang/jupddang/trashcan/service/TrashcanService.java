package com.jupddang.jupddang.trashcan.service;

import com.jupddang.jupddang.trashcan.dto.TrashcanDto;
import com.jupddang.jupddang.trashcan.dto.TrashcanListResponse;
import com.jupddang.jupddang.trashcan.entity.Trashcan;
import com.jupddang.jupddang.trashcan.repository.TrashcanRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TrashcanService {

    private final TrashcanRepository trashcanRepository;

    /**
     * 지도 영역 내의 쓰레기통 조회
     *
     * @param minLatitude 최소 위도
     * @param maxLatitude 최대 위도
     * @param minLongitude 최소 경도
     * @param maxLongitude 최대 경도
     * @return 쓰레기통 목록
     */
    public TrashcanListResponse getTrashcansInArea(
            Double minLatitude,
            Double maxLatitude,
            Double minLongitude,
            Double maxLongitude) {

        // 파라미터 유효성 검사
        validateCoordinates(minLatitude, maxLatitude, minLongitude, maxLongitude);

        // DB 조회
        List<Trashcan> trashcans = trashcanRepository.findByLocationRange(
                minLatitude, maxLatitude, minLongitude, maxLongitude
        );

        log.info("조회된 쓰레기통 개수: {}", trashcans.size());

        // Entity → DTO 변환
        List<TrashcanDto> dtos = trashcans.stream()
                .map(TrashcanDto::from)
                .toList();

        return TrashcanListResponse.of(dtos);
    }

    /**
     * 좌표 유효성 검증
     */
    private void validateCoordinates(
            Double minLat, Double maxLat,
            Double minLng, Double maxLng) {

        if (minLat == null || maxLat == null || minLng == null || maxLng == null) {
            throw new IllegalArgumentException("모든 좌표 값은 필수입니다");
        }

        if (minLat >= maxLat) {
            throw new IllegalArgumentException("최소 위도는 최대 위도보다 작아야 합니다");
        }

        if (minLng >= maxLng) {
            throw new IllegalArgumentException("최소 경도는 최대 경도보다 작아야 합니다");
        }

        // 한국 좌표 범위 검증
        if (minLat < 33.0 || maxLat > 43.0) {
            throw new IllegalArgumentException("위도는 33.0 ~ 43.0 범위여야 합니다");
        }

        if (minLng < 124.0 || maxLng > 132.0) {
            throw new IllegalArgumentException("경도는 124.0 ~ 132.0 범위여야 합니다");
        }
    }
}