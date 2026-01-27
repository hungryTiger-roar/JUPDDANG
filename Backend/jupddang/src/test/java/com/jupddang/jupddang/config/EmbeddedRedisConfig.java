package com.jupddang.jupddang.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.test.context.TestConfiguration;
import redis.embedded.RedisServer;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.io.IOException;
import java.net.ServerSocket;

@Slf4j
@TestConfiguration
public class EmbeddedRedisConfig {

    private RedisServer redisServer;
    private int redisPort;

    @PostConstruct
    public void startRedis() throws IOException {
        redisPort = findAvailablePort();
        log.info("=".repeat(80));
        log.info("🚀 Starting Embedded Redis on port: {}", redisPort);

        try {
            redisServer = new RedisServer(redisPort);
            redisServer.start();

            // 동적으로 Redis 포트 설정
            System.setProperty("spring.data.redis.port", String.valueOf(redisPort));

            log.info("✅ Embedded Redis started successfully");
            log.info("=".repeat(80));
        } catch (Exception e) {
            log.error("❌ Failed to start Embedded Redis", e);
            throw e;
        }
    }

    @PreDestroy
    public void stopRedis() {
        if (redisServer != null) {
            try {
                redisServer.stop();
                log.info("✅ Embedded Redis stopped");
            } catch (Exception e) {
                log.error("❌ Error stopping Embedded Redis", e);
            }
        }
    }

    /**
     * 사용 가능한 포트 찾기
     * 1. 기본 포트(6370-6380) 시도
     * 2. 모두 사용 중이면 랜덤 포트
     */
    private int findAvailablePort() throws IOException {
        // 6370-6380 범위에서 찾기
        for (int port = 6370; port <= 6380; port++) {
            if (isPortAvailable(port)) {
                return port;
            }
        }

        // 랜덤 포트
        try (ServerSocket socket = new ServerSocket(0)) {
            return socket.getLocalPort();
        }
    }

    /**
     * 포트 사용 가능 여부 확인
     */
    private boolean isPortAvailable(int port) {
        try (ServerSocket socket = new ServerSocket(port)) {
            socket.setReuseAddress(true);
            return true;
        } catch (IOException e) {
            return false;
        }
    }
}
