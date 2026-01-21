package com.jupddang.jupddang.plogging.test;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class TestController {
    private final JpaTest jpaTest;

    @GetMapping("/test")
    public String runTest() {
        jpaTest.test();
        return "테스트 완료! 콘솔 로그를 확인하세요.";
    }
}
