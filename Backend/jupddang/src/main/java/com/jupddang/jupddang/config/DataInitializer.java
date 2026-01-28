package com.jupddang.jupddang.config;

import com.jupddang.jupddang.trashcan.repository.TrashcanRepository;
import com.jupddang.jupddang.trashcan.service.TrashcanCsvService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
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
            // CSV 파일 경로
            ClassPathResource resource = new ClassPathResource("data/trashcans.csv");
            File csvFile = resource.getFile();

            // CSV 로드
            trashcanCsvService.loadCsvData(csvFile.getAbsolutePath());

            log.info("초기 쓰레기통 데이터 로드 완료!");

        } catch (Exception e) {
            log.error("초기 데이터 로드 실패: {}", e.getMessage());
            log.info("CSV 파일이 없거나 경로가 잘못되었습니다. 수동으로 데이터를 추가하세요.");
        }
    }
}