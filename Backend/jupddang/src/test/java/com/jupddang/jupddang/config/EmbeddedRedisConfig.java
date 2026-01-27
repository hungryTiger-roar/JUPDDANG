package com.jupddang.jupddang.config;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.TestConfiguration;
import redis.embedded.RedisServer;

import java.io.IOException;

@Slf4j
@TestConfiguration
public class EmbeddedRedisConfig {

    @Value("${spring.data.redis.port}")
    private int port;

    private RedisServer redisServer;

    @PostConstruct
    public void startRedis() throws IOException {
        // [중요] 윈도우/맥/리눅스 환경에 따라 RedisServer 생성 방식이 다를 수 있음
        // 포트 충돌 방지 로직은 생략하고 가장 심플하게 구성 (설정 파일 포트 사용)
        redisServer = new RedisServer(port);

        try {
            redisServer.start();
            log.info("✅ Embedded Redis Started on port: {}", port);
        } catch (Exception e) {
            log.error("Redis Start Error: {}", e.getMessage());
            // 이미 떠있으면 무시 (테스트 병렬 실행 시)
        }
    }

    @PreDestroy
    public void stopRedis() {
        if (redisServer != null) {
            redisServer.stop();
            log.info("✅ Embedded Redis Stopped");
        }
    }
}