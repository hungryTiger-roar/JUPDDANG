package com.jupddang.jupddang.plogging;

import com.google.cloud.storage.Storage;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.config.EmbeddedRedisConfig;
import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import com.jupddang.jupddang.plogging.exception.PloggingErrorCode;
import com.jupddang.jupddang.plogging.exception.PloggingException;
import com.jupddang.jupddang.plogging.service.PloggingService;
import com.jupddang.jupddang.security.JwtTokenProvider;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.context.annotation.Import;
import org.springframework.messaging.converter.MappingJackson2MessageConverter;
import org.springframework.messaging.simp.stomp.StompHeaders;
import org.springframework.messaging.simp.stomp.StompSession;
import org.springframework.messaging.simp.stomp.StompSessionHandlerAdapter;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.web.socket.WebSocketHttpHeaders;
import org.springframework.web.socket.client.standard.StandardWebSocketClient;
import org.springframework.web.socket.messaging.WebSocketStompClient;
import org.springframework.web.socket.sockjs.client.SockJsClient;
import org.springframework.web.socket.sockjs.client.WebSocketTransport;

import java.util.List;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.*;

@Slf4j
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test")
@Import(EmbeddedRedisConfig.class)
@TestPropertySource(properties = {
        "spring.cloud.gcp.core.enabled=false",
        "spring.cloud.gcp.storage.enabled=false",
        "spring.cloud.gcp.credentials.location=classpath:non-existent.json",
        "logging.level.org.hibernate.SQL=OFF",
        "spring.jpa.show-sql=false"
})
class PloggingWebSocketTest {

    @LocalServerPort
    private int port;

    @MockBean
    private PloggingService ploggingService;

    @MockBean
    private Storage storage;

    @MockBean
    private GcsImageService gcsImageService;

    @MockBean
    private JwtTokenProvider jwtTokenProvider;

    private String wsUrl;
    private final String TRACK_PATH = "/pub/plogging/track";

    @BeforeEach
    void setUp() {
        this.wsUrl = "ws://localhost:" + port + "/ws";
    }

    // -------------------------------------------------------------------
    // 1. 기본 기능 테스트
    // -------------------------------------------------------------------
    @Test
    @Order(1)
    @DisplayName("✅ 정상: 개인 플로깅 위치 전송")
    void testSoloLocation_Success() throws Exception {
        // given
        String token = "valid_token";
        String userId = "user1";
        mockJwt(token, userId);

        StompSession session = connectSession(token);
        LocationRequest request = new LocationRequest(37.5, 127.0, null);

        // when
        session.send(TRACK_PATH, request);

        // then
        verify(ploggingService, timeout(2000).times(1))
                .processLocation(eq(userId), any(LocationRequest.class));

        session.disconnect();
    }

    // -------------------------------------------------------------------
    // 2. 엣지 케이스 테스트
    // -------------------------------------------------------------------
    @Test
    @Order(2)
    @DisplayName("⚠️ 엣지: 잘못된 좌표 전송 (위도 200)")
    void testSoloLocation_InvalidCoordinate() throws Exception {
        // given
        String token = "valid_token";
        String userId = "user_edge";
        mockJwt(token, userId);

        // [수정] null 대신 실제 에러 코드 사용 (INVALID_COORDINATE)
        // PloggingErrorCode 임포트 필요: import
        // com.jupddang.jupddang.plogging.exception.PloggingErrorCode;
        doThrow(new PloggingException(PloggingErrorCode.INVALID_COORDINATE))
                .when(ploggingService)
                .processLocation(eq(userId), argThat(req -> req.getLat() > 90));

        StompSession session = connectSession(token);

        // 위도 200.0 (범위 초과)
        LocationRequest invalidRequest = new LocationRequest(200.0, 127.0, null);

        // when
        session.send(TRACK_PATH, invalidRequest);

        // then
        verify(ploggingService, timeout(2000).times(1))
                .processLocation(eq(userId), any(LocationRequest.class));

        log.info("  -> 잘못된 좌표 전송 시 서비스 호출 확인됨 (서비스 내부에서 예외 발생)");
        session.disconnect();
    }

    // -------------------------------------------------------------------
    // 3. 부하 테스트 (100명 동시 접속)
    // -------------------------------------------------------------------
    @Test
    @Order(3)
    @DisplayName("🔥 부하: 100명 동시 접속 및 위치 전송")
    void test100ConcurrentUsers() throws InterruptedException {
        int userCount = 100;
        ExecutorService executor = Executors.newFixedThreadPool(30); // 스레드 풀
        CountDownLatch latch = new CountDownLatch(userCount);
        AtomicInteger successConnect = new AtomicInteger(0);

        // 동적 토큰 처리를 위한 Mock 설정
        // "token-0" -> "user-0", "token-1" -> "user-1" 식으로 동작
        given(jwtTokenProvider.validateToken(anyString())).willReturn(true);
        given(jwtTokenProvider.getAuthentication(anyString())).willAnswer(new Answer<Object>() {
            @Override
            public Object answer(InvocationOnMock invocation) {
                String token = invocation.getArgument(0);
                String userId = token.replace("token-", "user-");
                return new UsernamePasswordAuthenticationToken(userId, "",
                        List.of(new SimpleGrantedAuthority("ROLE_USER")));
            }
        });

        log.info("🚀 100명 웹소켓 연결 시작...");
        long start = System.currentTimeMillis();

        for (int i = 0; i < userCount; i++) {
            final int index = i;
            executor.submit(() -> {
                try {
                    String token = "token-" + index;
                    StompSession session = connectSession(token);

                    // 위치 전송
                    LocationRequest req = new LocationRequest(37.5 + (index * 0.0001), 127.0, null);
                    session.send(TRACK_PATH, req);

                    successConnect.incrementAndGet();
                    session.disconnect(); // 테스트니까 바로 끊기
                } catch (Exception e) {
                    log.error("User-{} 연결 실패: {}", index, e.getMessage());
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await(20, TimeUnit.SECONDS); // 최대 20초 대기
        long end = System.currentTimeMillis();

        log.info("📊 부하 테스트 결과:");
        log.info("  - 성공 연결: {}/{}", successConnect.get(), userCount);
        log.info("  - 소요 시간: {}ms", (end - start));

        // 검증: 서비스가 100번(또는 그 근사치) 호출되었는지 확인
        // (비동기 처리 특성상 약간의 오차나 딜레이가 있을 수 있어 atLeast로 검증)
        verify(ploggingService, timeout(10000).atLeast(userCount))
                .processLocation(anyString(), any(LocationRequest.class));

        assertThat(successConnect.get()).isEqualTo(userCount);
    }

    // --- Helper Methods ---

    private void mockJwt(String token, String userId) {
        given(jwtTokenProvider.validateToken(token)).willReturn(true);
        given(jwtTokenProvider.getAuthentication(token)).willReturn(
                new UsernamePasswordAuthenticationToken(userId, "", List.of(new SimpleGrantedAuthority("ROLE_USER"))));
    }

    private StompSession connectSession(String token)
            throws ExecutionException, InterruptedException, TimeoutException {
        WebSocketStompClient client = new WebSocketStompClient(new SockJsClient(
                List.of(new WebSocketTransport(new StandardWebSocketClient()))));
        client.setMessageConverter(new MappingJackson2MessageConverter());

        StompHeaders headers = new StompHeaders();
        headers.add("Authorization", "Bearer " + token);

        WebSocketHttpHeaders handshakeHeaders = new WebSocketHttpHeaders();
        handshakeHeaders.add("Authorization", "Bearer " + token);

        return client.connectAsync(wsUrl, handshakeHeaders, headers, new StompSessionHandlerAdapter() {
        })
                .get(5, TimeUnit.SECONDS); // 타임아웃 5초
    }
}