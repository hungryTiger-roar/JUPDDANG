package com.jupddang.jupddang.plogging.test;

import lombok.RequiredArgsConstructor;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "test api", description = "테스트 관련 API")
public class TestController {
    private final JpaTest jpaTest;

    @GetMapping("/test")
    @Operation(summary = "JPA 테스트 실행")
    public String runTest() {
        jpaTest.test();
        return "테스트 완료! 콘솔 로그를 확인하세요.";
    }
}
