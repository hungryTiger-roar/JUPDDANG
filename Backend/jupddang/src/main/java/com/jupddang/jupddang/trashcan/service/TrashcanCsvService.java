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

    /**
     * CSV 파일을 읽어서 DB에 저장
     * 
     * @param filePath CSV 파일 경로
     */
    @Transactional
    public void loadCsvData(String filePath) {
        List<Trashcan> trashcans = new ArrayList<>();
        int successCount = 0;
        int errorCount = 0;

        try (CSVReader reader = new CSVReader(
                new FileReader(filePath, StandardCharsets.UTF_8))) {

            List<String[]> allLines = reader.readAll();

            // 첫 번째 줄은 헤더이므로 스킵
            for (int i = 1; i < allLines.size(); i++) {
                String[] line = allLines.get(i);

                try {
                    // CSV 컬럼 매핑 (실제 공공데이터 포털 형식)
                    // 0: 쓰레기통명
                    // 1: 시도명
                    // 2: 시군구명
                    // 3: 도로명주소
                    // 4: 지번주소
                    // 5: (빈 컬럼 - 설치장소)
                    // 6: 위도
                    // 7: 경도
                    String address = line.length > 3 ? line[3] : "";
                    String latitudeStr = line.length > 6 ? line[6] : "";
                    String longitudeStr = line.length > 7 ? line[7] : "";

                    // 위도/경도 파싱
                    Double latitude = parseDouble(latitudeStr);
                    Double longitude = parseDouble(longitudeStr);

                    // 유효성 검사
                    if (latitude == null || longitude == null) {
                        log.warn("잘못된 위도/경도 데이터 (행: {}): lat={}, lng={}",
                                i + 1, latitudeStr, longitudeStr);
                        errorCount++;
                        continue;
                    }

                    // 한국 좌표 범위 검증 (대략)
                    if (latitude < 33.0 || latitude > 43.0 ||
                            longitude < 124.0 || longitude > 132.0) {
                        log.warn("유효하지 않은 좌표 범위 (행: {}): lat={}, lng={}",
                                i + 1, latitude, longitude);
                        errorCount++;
                        continue;
                    }

                    // Trashcan 엔티티 생성
                    Trashcan trashcan = new Trashcan();
                    trashcan.setLatitude(latitude);
                    trashcan.setLongitude(longitude);
                    trashcan.setAddress(address);
                    trashcan.setStatus(TrashcanStatus.OFFICIAL);
                    trashcan.setVerificationCount(0);

                    trashcans.add(trashcan);
                    successCount++;

                    // 메모리 관리: 1000개씩 배치 저장
                    if (trashcans.size() >= 1000) {
                        trashcanRepository.saveAll(trashcans);
                        log.info("{}개 저장 완료 (누적: {}개)", trashcans.size(), successCount);
                        trashcans.clear();
                    }

                } catch (Exception e) {
                    log.error("데이터 파싱 오류 (행: {}): {}", i + 1, e.getMessage());
                    errorCount++;
                }
            }

            // 남은 데이터 저장
            if (!trashcans.isEmpty()) {
                trashcanRepository.saveAll(trashcans);
                log.info("{}개 저장 완료 (최종)", trashcans.size());
            }

            log.info("=== CSV 로드 완료 ===");
            log.info("성공: {}개", successCount);
            log.info("실패: {}개", errorCount);
            log.info("총 데이터: {}개", allLines.size() - 1);

        } catch (IOException | CsvException e) {
            log.error("CSV 파일 로드 실패: {}", e.getMessage(), e);
            throw new RuntimeException("CSV 파일 처리 중 오류 발생", e);
        }
    }

    /**
     * 문자열을 Double로 안전하게 파싱
     */
    private Double parseDouble(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}