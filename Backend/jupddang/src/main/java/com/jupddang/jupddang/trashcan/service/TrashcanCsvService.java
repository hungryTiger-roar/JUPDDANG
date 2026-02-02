package com.jupddang.jupddang.trashcan.service;

import com.jupddang.jupddang.trashcan.entity.Trashcan;
import com.jupddang.jupddang.trashcan.entity.TrashcanStatus;
import com.jupddang.jupddang.trashcan.repository.TrashcanRepository;
import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class TrashcanCsvService {

    private final TrashcanRepository trashcanRepository;

    private static final int BATCH_SIZE = 1000;

    // 대한민국 대략적인 위경도 범위
    private static final double MIN_LAT = 33.0;
    private static final double MAX_LAT = 43.0;
    private static final double MIN_LNG = 124.0;
    private static final double MAX_LNG = 132.0;

    /**
     * CSV 파일을 읽어서 DB에 저장
     */
    @Transactional
    public void loadCsvData(String filePath) {
        List<Trashcan> trashcans = new ArrayList<>();
        int successCount = 0;
        int errorCount = 0;

        try (CSVReader reader = new CSVReader(new FileReader(filePath, StandardCharsets.UTF_8))) {
            List<String[]> allLines = reader.readAll();

            // 헤더 스킵 (첫 번째 줄)
            for (int i = 1; i < allLines.size(); i++) {
                String[] line = allLines.get(i);
                
                // 빈 라인 무시
                if (line == null || line.length == 0) continue;

                try {
                    // 1. 스마트 좌표 파싱 (밀림 현상 방지)
                    Coordinate coordinate = findCoordinatesRobustly(line);

                    if (coordinate == null) {
                        log.warn("[Skip] 유효한 좌표를 찾을 수 없음 (행: {}): {}", i + 1, String.join(",", line));
                        errorCount++;
                        continue;
                    }

                    // 2. 주소 파싱 (좌표 인덱스 앞쪽의 데이터를 주소로 간주)
                    // 기본적으로 index 3이 도로명주소지만, 쉼표로 밀렸을 수 있으므로
                    // index 3부터 좌표가 발견된 index 직전까지 합칩니다.
                    String address = extractAddress(line, coordinate.foundIndex);

                    // 3. 엔티티 생성
                    Trashcan trashcan = new Trashcan();
                    trashcan.setAddress(address);
                    trashcan.setLatitude(coordinate.latitude);
                    trashcan.setLongitude(coordinate.longitude);
                    trashcan.setStatus(TrashcanStatus.OFFICIAL); // 공공 데이터는 OFFICIAL
                    trashcan.setVerificationCount(0);
                    
                    // 공공데이터는 제보자(Account)가 없으므로 null 유지 혹은 시스템 계정 할당
                    // trashcan.setReportedBy(null); 

                    trashcans.add(trashcan);
                    successCount++;

                    // 4. 배치 저장
                    if (trashcans.size() >= BATCH_SIZE) {
                        saveBatch(trashcans);
                    }

                } catch (Exception e) {
                    log.error("데이터 파싱 중 예외 발생 (행: {}): {}", i + 1, e.getMessage());
                    errorCount++;
                }
            }

            // 남은 데이터 저장
            if (!trashcans.isEmpty()) {
                saveBatch(trashcans);
            }

            log.info("=== CSV 로드 완료 ===");
            log.info("성공: {} 건", successCount);
            log.info("실패: {} 건", errorCount);

        } catch (IOException | CsvException e) {
            log.error("CSV 파일 로드 실패: {}", e.getMessage(), e);
            throw new RuntimeException("CSV 처리 중 치명적 오류", e);
        }
    }

    private void saveBatch(List<Trashcan> trashcans) {
        trashcanRepository.saveAll(trashcans);
        log.info("{}개 데이터 저장 완료", trashcans.size());
        trashcans.clear();
    }

    /**
     * 행(Line) 전체를 스캔하여 위도/경도로 추정되는 값을 찾아냅니다.
     * 데이터 밀림(Shifting) 현상을 해결하기 위한 핵심 로직입니다.
     */
    private Coordinate findCoordinatesRobustly(String[] line) {
        Double foundLat = null;
        Double foundLng = null;
        int foundIndex = -1; // 좌표가 시작된 인덱스 (주소 파싱 범위를 알기 위해)

        // 이미지 기준 기본 인덱스: 위도(5), 경도(6)
        // 하지만 안전을 위해 라인 전체에서 좌표 포맷을 찾습니다.
        // 뒤에서부터 찾는 것이 보통 더 정확합니다 (주소가 앞에서 늘어났을 확률이 높음)
        
        for (int j = 0; j < line.length; j++) {
            Double val = parseDouble(line[j]);
            if (val == null) continue;

            // 값이 위도 범위인지 경도 범위인지 체크
            boolean isLat = (val >= MIN_LAT && val <= MAX_LAT);
            boolean isLng = (val >= MIN_LNG && val <= MAX_LNG);

            if (isLat || isLng) {
                // 현재 값과 바로 다음 값(j+1)을 쌍으로 확인
                if (j + 1 < line.length) {
                    Double nextVal = parseDouble(line[j+1]);
                    
                    // Case 1: [Lat, Lng] 순서 (정상)
                    if (isLat && isValidLng(nextVal)) {
                        return new Coordinate(val, nextVal, j);
                    }
                    // Case 2: [Lng, Lat] 순서 (뒤집힘) -> 스왑
                    if (isLng && isValidLat(nextVal)) {
                         log.debug("좌표 반전 감지 및 보정: {}, {}", nextVal, val);
                         return new Coordinate(nextVal, val, j);
                    }
                }
            }
        }
        
        // 쌍을 못 찾았지만, 개별적으로라도 유효한 값이 있는지 최후의 검색 (선택사항)
        // 여기서는 데이터 무결성을 위해 쌍이 맞지 않으면 null 반환
        return null;
    }

    /**
     * 주소 추출 로직
     * 쉼표로 인해 주소가 여러 컬럼에 나뉘었을 경우 하나로 합칩니다.
     * @param line 전체 컬럼 배열
     * @param coordStartIndex 좌표가 발견된 시작 인덱스
     */
    private String extractAddress(String[] line, int coordStartIndex) {
        // 이미지 기준: 0(장소명), 1(시도), 2(시군구), 3(도로명), 4(지번)
        // 보통 도로명주소(3)부터 좌표 전까지 합치면 됩니다.
        
        if (coordStartIndex <= 3) return ""; // 주소 데이터가 없는 경우

        StringBuilder sb = new StringBuilder();
        // 도로명 주소 시작 인덱스(3)부터 좌표 나오기 전까지 루프
        for (int i = 3; i < coordStartIndex; i++) {
            String part = line[i].trim();
            if (StringUtils.hasText(part)) {
                if (!sb.isEmpty()) sb.append(" ");
                sb.append(part);
            }
        }
        
        // 만약 조합된 주소가 비었다면 지번주소(4)라도 쓰거나, 시도/시군구(1,2)를 활용
        if (sb.isEmpty() && line.length > 2) {
             sb.append(line[1]).append(" ").append(line[2]);
        }
        
        return sb.toString();
    }

    private boolean isValidLat(Double val) {
        return val != null && val >= MIN_LAT && val <= MAX_LAT;
    }

    private boolean isValidLng(Double val) {
        return val != null && val >= MIN_LNG && val <= MAX_LNG;
    }

    private Double parseDouble(String value) {
        if (!StringUtils.hasText(value)) return null;
        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    // 내부 도우미 클래스
    private static class Coordinate {
        Double latitude;
        Double longitude;
        int foundIndex; // 좌표가 발견된 배열 인덱스

        public Coordinate(Double latitude, Double longitude, int foundIndex) {
            this.latitude = latitude;
            this.longitude = longitude;
            this.foundIndex = foundIndex;
        }
    }
}