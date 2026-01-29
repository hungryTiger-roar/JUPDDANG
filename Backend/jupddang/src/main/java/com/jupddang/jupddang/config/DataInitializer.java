package com.jupddang.jupddang.config;

import com.jupddang.jupddang.trashcan.entity.Trashcan;
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
                    
                    // CSV 파싱 및 저장
                    String[] data = line.split(",");
                    if (data.length >= 3) {  // 최소 필드 개수 확인
                        saveTrashcanData(data);
                        loadedCount++;
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
        // CSV 형식에 맞게 수정 (예시)
        // data[0] = name, data[1] = latitude, data[2] = longitude 등
        Trashcan trashcan = Trashcan.builder()
            .name(data[0])
            .latitude(Double.parseDouble(data[1]))
            .longitude(Double.parseDouble(data[2]))
            // 추가 필드 매핑
            .build();
        
        trashcanRepository.save(trashcan);
    }
}
