package com.jupddang.jupddang.plogging;

import com.jupddang.jupddang.plogging.domain.Grids;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.plogging.dto.UserPloggingStatus;
import com.jupddang.jupddang.plogging.dto.request.LocationRequest;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.exception.PloggingErrorCode;
import com.jupddang.jupddang.plogging.exception.PloggingException;
import com.jupddang.jupddang.plogging.repository.GridRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRedisRepository;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.plogging.service.impls.PloggingServiceImpl;
import com.uber.h3core.H3Core;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.mock.web.MockMultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Optional;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PloggingServiceScenarioTest {

    /*
    [테스트 시나리오]
    Scenario 1: 점령 성공 (빈 땅)
      - 조건: 한 곳에 3분 이상 머무름 + Redis 상태 occupied=false + DB에 해당 그리드 없음
      - 결과: GridRepository.save() 호출, Redis 상태 occupied=true로 변경, Redis 점령 리스트 추가

    Scenario 2: 단순 이동 (3분 미만 체류 or 새로운 땅)
      - 조건: 새로운 H3 인덱스로 이동
      - 결과: GridRepository.save() 호출 안 됨, Redis에 occupied=false로 상태 갱신

    Scenario 3: 땅 뺏기 성공 (보호막 해제된 땅)
      - 조건: 3분 이상 체류 + 기존 땅의 occupiedAt이 3시간 이전
      - 결과: changeOwner 호출됨, 파티 알림 전송

    Scenario 4: 땅 뺏기 실패 (보호막 유효)
      - 조건: 3분 이상 체류 + 기존 땅의 occupiedAt이 방금 전
      - 결과: changeOwner 호출 안 됨 (DB 상태 유지)

    Scenario 5: 플로깅 종료
      - 조건: 종료 요청
      - 결과: Plogging 저장, Event 발행, Redis 상태 삭제

    Scenario 6: 부하 테스트
      - 조건: 100명 동시 요청
    */

    @InjectMocks
    private PloggingServiceImpl ploggingService;

    @Mock private PloggingRepository ploggingRepository;
    @Mock private PloggingRedisRepository redisRepository;
    @Mock private GridRepository gridRepository;
    @Mock private ApplicationEventPublisher eventPublisher;
    @Mock private SimpMessagingTemplate messagingTemplate;
    @Mock private H3Core h3Core;

    private final Long USER_ID_A = 100L;
    private final Long USER_ID_B = 200L;
    private final String MOCK_H3_INDEX = "8928308280fffff";
    private final double LAT = 37.5;
    private final double LON = 127.0;

    @BeforeEach
    void setUp() throws IOException {
        lenient().when(h3Core.latLngToCellAddress(anyDouble(), anyDouble(), anyInt()))
                .thenReturn(MOCK_H3_INDEX);
    }

    @Test
    @DisplayName("Scenario 1: 유저가 3분 이상 머무르고 빈 땅이면 점령에 성공한다")
    void testOccupationSuccess() {
        // given
        LocationRequest request = new LocationRequest();
        request.setLat(LAT);
        request.setLon(LON);
        request.setPartyId(null);

        // 3분 1초 전 진입, 아직 점령 안함(false)
        long entryTime = System.currentTimeMillis() - (180 * 1000) - 1000;
        UserPloggingStatus status = new UserPloggingStatus(MOCK_H3_INDEX, entryTime, false);

        given(redisRepository.getUserState(USER_ID_A)).willReturn(status);
        given(gridRepository.findById(MOCK_H3_INDEX)).willReturn(Optional.empty()); // 빈 땅

        // when
        ploggingService.processLocation(USER_ID_A, request);

        // then
        verify(gridRepository, times(1)).save(any(Grids.class)); // DB 저장 확인
        verify(redisRepository).updateUserState(eq(USER_ID_A), eq(MOCK_H3_INDEX), eq(entryTime), eq(true)); // occupied=true 갱신 확인
        verify(redisRepository).addCapturedGrid(eq(USER_ID_A), eq(MOCK_H3_INDEX)); // 점령 카운트용 Set 추가 확인
    }

    @Test
    @DisplayName("Scenario 2: 유저가 이동하면 점령 로직 없이 Redis 상태만 갱신한다")
    void testMovementWithoutOccupation() {
        // given
        LocationRequest request = new LocationRequest();
        request.setLat(LAT);
        request.setLon(LON);

        // Redis에 저장된 정보 없음 (처음 진입) 또는 다른 H3
        given(redisRepository.getUserState(USER_ID_A)).willReturn(null);

        // when
        ploggingService.processLocation(USER_ID_A, request);

        // then
        verify(gridRepository, never()).save(any());
        // 새로운 좌표로 갱신, occupied=false
        verify(redisRepository, times(1)).updateUserState(eq(USER_ID_A), eq(MOCK_H3_INDEX), anyLong(), eq(false));
    }

    @Test
    @DisplayName("Scenario 3: 땅 뺏기 - 보호막(3시간)이 지난 땅은 뺏을 수 있다")
    void testStealLandSuccess() {
        // given
        LocationRequest request = new LocationRequest();
        request.setLat(LAT);
        request.setLon(LON);
        request.setPartyId(1L);

        // 3분 지남
        long entryTime = System.currentTimeMillis() - (181 * 1000);
        UserPloggingStatus status = new UserPloggingStatus(MOCK_H3_INDEX, entryTime, false);
        given(redisRepository.getUserState(USER_ID_B)).willReturn(status);

        // 기존 땅: 4시간 전에 점령됨 (보호막 해제)
        Grids existingGrid = Grids.builder()
                .id(MOCK_H3_INDEX)
                .userId(USER_ID_A)
                .occupiedAt(LocalDateTime.now().minusHours(4))
                .build();

        // Spy를 써서 changeOwner 호출 여부 감시 가능 (여기선 객체 상태 변화 확인도 가능)
        given(gridRepository.findById(MOCK_H3_INDEX)).willReturn(Optional.of(existingGrid));

        // when
        ploggingService.processLocation(USER_ID_B, request);

        // then
        // 주인이 B로 바뀌었는지 확인 (Entity 내부 로직 동작 가정 or Mocking)
        assertThat(existingGrid.getUserId()).isEqualTo(USER_ID_B);
        verify(messagingTemplate).convertAndSend(eq("/topic/party/1"), anyString());
        verify(redisRepository).updateUserState(eq(USER_ID_B), eq(MOCK_H3_INDEX), eq(entryTime), eq(true));
    }

    @Test
    @DisplayName("Scenario 4: 땅 뺏기 실패 - 보호막(3시간)이 남은 땅은 뺏지 못한다")
    void testStealLandFail_Shield() {
        // given
        LocationRequest request = new LocationRequest();
        request.setLat(LAT);
        request.setLon(LON);
        request.setPartyId(null);

        long entryTime = System.currentTimeMillis() - (181 * 1000);
        UserPloggingStatus status = new UserPloggingStatus(MOCK_H3_INDEX, entryTime, false);
        given(redisRepository.getUserState(USER_ID_B)).willReturn(status);

        // 기존 땅: 1시간 전에 점령됨 (보호막 유효)
        Grids existingGrid = Grids.builder()
                .id(MOCK_H3_INDEX)
                .userId(USER_ID_A)
                .occupiedAt(LocalDateTime.now().minusHours(1))
                .build();

        given(gridRepository.findById(MOCK_H3_INDEX)).willReturn(Optional.of(existingGrid));

        // when
        ploggingService.processLocation(USER_ID_B, request);

        // then
        // 주인이 여전히 A여야 함
        assertThat(existingGrid.getUserId()).isEqualTo(USER_ID_A);
        // Redis 상태가 occupied=true로 바뀌지 않아야 함 (계속 시도하거나 그대로 둠)
        verify(redisRepository, never()).updateUserState(anyLong(), anyString(), anyLong(), eq(true));
    }

    @Test
    @DisplayName("Scenario 5: 플로깅 종료 시 DB 저장, 이벤트 발행, Redis 삭제 확인")
    void testEndPlogging() {
        // given
        PloggingEndRequest request = new PloggingEndRequest(
                null, 5.0, Collections.emptyList(), Collections.emptyList(), 3600
        );
        MockMultipartFile image = new MockMultipartFile("img", "test.jpg", "image/jpeg", "byte".getBytes());

        Plogging savedPlogging = Plogging.builder().id(999L).userId(USER_ID_A).distance(5.0).times(3600).build();
        given(ploggingRepository.save(any(Plogging.class))).willReturn(savedPlogging);

        // Redis에서 점령 횟수 조회 모킹
        given(redisRepository.getCapturedCount(USER_ID_A)).willReturn(3);

        // when
        ploggingService.endPlogging(USER_ID_A, request, image, image, image);

        // then
        verify(ploggingRepository).save(any(Plogging.class));
        verify(eventPublisher).publishEvent(any(PloggingCompletedEvent.class));
        verify(redisRepository).deleteUserState(USER_ID_A);
    }

    @Test
    @DisplayName("Scenario 6: [부하 테스트] 사용자 100명 동시 요청")
    void testConcurrency100Users() throws InterruptedException {
        int userCount = 100;
        ExecutorService executorService = Executors.newFixedThreadPool(32);
        CountDownLatch latch = new CountDownLatch(userCount);
        AtomicInteger successCount = new AtomicInteger();

        given(redisRepository.getUserState(anyLong())).willReturn(null);

        for (int i = 0; i < userCount; i++) {
            final long userId = i + 1000L;
            executorService.submit(() -> {
                try {
                    LocationRequest req = new LocationRequest();
                    req.setLat(LAT + (Math.random() * 0.01));
                    req.setLon(LON + (Math.random() * 0.01));
                    ploggingService.processLocation(userId, req);
                    successCount.incrementAndGet();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await();
        assertThat(successCount.get()).isEqualTo(userCount);
    }

    @Test
    @DisplayName("Scenario 7: [예외] 좌표 오류 시 예외 발생")
    void testInvalidCoordinateException() {
        LocationRequest request = new LocationRequest();
        request.setLat(200.0);
        request.setLon(127.0);

        assertThatThrownBy(() -> ploggingService.processLocation(USER_ID_A, request))
                .isInstanceOf(PloggingException.class)
                .extracting("errorCode")
                .isEqualTo(PloggingErrorCode.INVALID_COORDINATE);
    }
}