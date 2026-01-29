package com.jupddang.jupddang.config;

import com.jupddang.jupddang.trashcan.entity.Trashcan;
import com.jupddang.jupddang.trashcan.entity.TrashcanStatus;
import com.jupddang.jupddang.trashcan.repository.TrashcanRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.nio.charset.StandardCharsets;

@Slf4j
@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final TrashcanRepository trashcanRepository;

    @Override
    public void run(String... args) throws Exception {
        // 이미 데이터가 있으면 스킵
        long count = trashcanRepository.count();
        if (count > 0) {
            log.info("쓰레기통 데이터가 이미 존재합니다 ({}개). 초기 로드를 스킵합니다.", count);
            return;
        }

        log.info("쓰레기통 데이터 초기 로드를 시작합니다...");

        try {
            // 외부 볼륨에서 CSV 읽기
            File csvFile = new File("/app/data/trashcans.csv");
            
            if (!csvFile.exists()) {
                log.warn("CSV 파일을 찾을 수 없습니다: {}", csvFile.getAbsolutePath());
                log.info("CSV 파일을 /home/gitlab-runner/data/dev/csv/trashcans.csv 에 배치해주세요.");
                return;
            }

            int loadedCount = 0;
            try (BufferedReader reader = new BufferedReader(new FileReader(csvFile, StandardCharsets.UTF_8))) {
                String line;
                boolean isFirstLine = true;
                
                while ((line = reader.readLine()) != null) {
                    if (isFirstLine) {
                        isFirstLine = false;
                        continue; // 헤더 스킵
                    }
                    
                    // 빈 줄 스킵
                    if (line.trim().isEmpty()) {
                        continue;
                    }
                    
                    // CSV 파싱 및 저장
                    String[] data = line.split(",");
                    if (data.length >= 2) {  // 최소 위도, 경도 필요
                        try {
                            saveTrashcanData(data);
                            loadedCount++;
                        } catch (Exception e) {
                            log.warn("CSV 데이터 파싱 실패 (줄: {}): {}", line, e.getMessage());
                        }
                    }
                }
            }

            log.info("초기 쓰레기통 데이터 로드 완료! ({}개)", loadedCount);

        } catch (Exception e) {
            log.error("초기 데이터 로드 실패: {}", e.getMessage(), e);
            log.info("수동으로 데이터를 추가하거나 CSV 파일을 확인해주세요.");
        }
    }
    
    private void saveTrashcanData(String[] data) {
        // CSV 형식: latitude, longitude, address(optional), status(optional)
        
        Trashcan trashcan = new Trashcan();
        
        // 필수 필드: 위도, 경도
        trashcan.setLatitude(Double.parseDouble(data[0].trim()));
        trashcan.setLongitude(Double.parseDouble(data[1].trim()));
        
        // 주소 (선택 - 3번째 컬럼)
        if (data.length > 2 && !data[2].trim().isEmpty()) {
            trashcan.setAddress(data[2].trim());
        }
        
        // 상태 (선택 - 4번째 컬럼, 없으면 기본값 OFFICIAL)
        if (data.length > 3 && !data[3].trim().isEmpty()) {
            try {
                trashcan.setStatus(TrashcanStatus.valueOf(data[3].trim().toUpperCase()));
            } catch (IllegalArgumentException e) {
                log.warn("잘못된 상태 값: {}. OFFICIAL로 설정합니다.", data[3]);
                trashcan.setStatus(TrashcanStatus.OFFICIAL);
            }
        } else {
            // CSV에서 가져온 데이터는 공공데이터이므로 OFFICIAL
            trashcan.setStatus(TrashcanStatus.OFFICIAL);
        }
        
        // 검증 횟수 초기값
        trashcan.setVerificationCount(0);
        
        // 저장
        trashcanRepository.save(trashcan);
    }
}
