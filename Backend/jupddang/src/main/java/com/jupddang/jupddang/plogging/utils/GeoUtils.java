package com.jupddang.jupddang.plogging.utils;

import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Component
public class GeoUtils {

    // 육각형 그리드 해상도 (H3 기준: 9~10 정도가 골목길 수준)
    private static final int GRID_RESOLUTION = 9;

    /**
     * LineString(경로 좌표 리스트)을 입력받아
     * 해당 경로가 지나가는 육각형 Grid ID 리스트를 반환합니다.
     *
     * @param lineString 좌표 리스트 (ex: ["37.5665,126.9780", "37.5666,126.9781"])
     * @return 중복 제거된 Grid ID 리스트
     */
    public List<String> getGridIdsFromLineString(List<String> lineString) {
        if (lineString == null || lineString.isEmpty()) {
            return new ArrayList<>();
        }

        // 중복 제거를 위해 Set 사용
        Set<String> uniqueGridIds = new HashSet<>();

        // 1. 좌표 파싱 및 그리드 변환
        for (int i = 0; i < lineString.size(); i++) {
            String currentCoord = lineString.get(i);

            // TODO: [Real] 실제 H3 라이브러리 적용 시
            // double[] latLng = parseCoordinate(currentCoord);
            // long h3Index = h3.latLngToCell(latLng[0], latLng[1], GRID_RESOLUTION);
            // uniqueGridIds.add(h3.h3ToString(h3Index));

            // NOTE: [MVP Mock] 라이브러리 없이 테스트하기 위한 임시 로직
            // 좌표 문자열 자체를 해싱해서 임시 Grid ID 생성
            String mockGridId = "GRID_" + simpleHash(currentCoord);
            uniqueGridIds.add(mockGridId);

            // 2. [Advanced] 좌표와 좌표 사이 '보간(Interpolation)' 처리 필요
            // GPS가 튀어서 점이 멀리 찍히면, 그 사이의 땅을 못 먹는 문제 발생.
            // 두 점 사이를 촘촘하게 채워주는 로직이 나중에 여기에 들어가야 함.
            if (i > 0) {
                // String prevCoord = lineString.get(i - 1);
                // List<String> pathGrids = getGridsBetween(prevCoord, currentCoord);
                // uniqueGridIds.addAll(pathGrids);
            }
        }

        return new ArrayList<>(uniqueGridIds);
    }

    // --- Helper Methods ---

    /**
     * "위도,경도" 문자열을 파싱
     */
    private double[] parseCoordinate(String coord) {
        String[] parts = coord.split(",");
        return new double[]{
                Double.parseDouble(parts[0].trim()), // lat
                Double.parseDouble(parts[1].trim())  // lng
        };
    }

    /**
     * [테스트용] 간단한 문자열 해싱
     */
    private String simpleHash(String input) {
        // 실제로는 쓰면 안됨. 단순히 테스트용 ID 생성을 위함.
        return String.valueOf(input.hashCode()).replace("-", "N");
    }
}