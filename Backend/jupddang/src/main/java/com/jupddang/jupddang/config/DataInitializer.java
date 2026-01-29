package com.jupddang.jupddang.config;

import com.jupddang.jupddang.trashcan.repository.TrashcanRepository;
import com.jupddang.jupddang.trashcan.service.TrashcanCsvService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.io.File;

@Slf4j
@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final TrashcanCsvService trashcanCsvService;
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
            // 외부 볼륨에서 CSV 파일 경로
            String csvPath = "/app/data/trashcans.csv";
            File csvFile = new File(csvPath);

            if (!csvFile.exists()) {
                log.warn("CSV 파일을 찾을 수 없습니다: {}", csvPath);
                log.info("CSV 파일을 /home/gitlab-runner/data/dev/csv/trashcans.csv 에 배치해주세요.");
                return;
            }

            // 기존 서비스 호출
            trashcanCsvService.loadCsvData(csvPath);

            log.info("초기 쓰레기통 데이터 로드 완료!");

        } catch (Exception e) {
            log.error("초기 데이터 로드 실패: {}", e.getMessage(), e);
            log.info("수동으로 데이터를 추가하거나 CSV 파일을 확인해주세요.");
        }
    }
}
