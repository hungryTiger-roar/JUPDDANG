package com.jupddang.jupddang.plogging.test;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Transactional // JPA 테스트 시 필수 (Dirty Checking 등)
@Slf4j
public class JpaTest {

    private final TestRepository testRepository;
    public void test() {
        log.info("========== [CRUD TEST START] ==========");

        // 1. Create (저장)
        TestEntity entity = TestEntity.builder()
                .content("첫 번째 데이터입니다.")
                .build();
        TestEntity savedEntity = testRepository.save(entity);
        log.info("1. Save Success -> ID: {}, Content: {}", savedEntity.getId(), savedEntity.getContent());

        // 2. Read (조회)
        TestEntity foundEntity = testRepository.findById(savedEntity.getId())
                .orElseThrow(() -> new IllegalArgumentException("찾을 수 없음"));
        log.info("2. Read Success -> ID: {}", foundEntity.getId());

        // 3. Update (수정 - Dirty Checking)
        // save()를 호출하지 않아도, Transactional 안에서 값만 바꾸면 자동 업데이트됨
        foundEntity.setContent("수정된 데이터입니다.");
        // 명시적으로 save해도 됨: testRepository.save(foundEntity);
        log.info("3. Update Logic Executed (Commit 시점 반영됨)");

        // 4. Delete (삭제)
        testRepository.delete(foundEntity);
        log.info("4. Delete Logic Executed");

        // 5. 삭제 확인
        boolean exists = testRepository.existsById(savedEntity.getId());
        log.info("5. Delete Check -> Exists? {}", exists ? "O (실패)" : "X (성공)");

        log.info("========== [CRUD TEST END] ==========");
    }
}
