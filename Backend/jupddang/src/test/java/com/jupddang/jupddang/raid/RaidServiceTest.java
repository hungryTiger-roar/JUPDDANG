package com.jupddang.jupddang.raid;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.raid.dto.RaidBossResponse;
import com.jupddang.jupddang.raid.dto.RaidGroupInfoResponse;
import com.jupddang.jupddang.raid.entity.RaidBoss;
import com.jupddang.jupddang.raid.entity.RaidRecord;
import com.jupddang.jupddang.raid.repository.RaidBossRepository;
import com.jupddang.jupddang.raid.repository.RaidRecordRepository;
import com.jupddang.jupddang.raid.service.RaidService;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Pageable;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.*;

@Slf4j
@ExtendWith(MockitoExtension.class)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class RaidServiceTest {

    @InjectMocks
    private RaidService raidService;

    @Mock private RaidBossRepository bossRepository;
    @Mock private RaidRecordRepository recordRepository;
    @Mock private AccountRepository accountRepository;

    private static final String USER_ID = "1";
    private static final String BOSS_H3 = "88283082bffffff";

    private Instant testStartTime;

    @BeforeEach
    void setUp() {
        testStartTime = Instant.now();
        log.info("=".repeat(80));
        log.info("테스트 시작 시각: {}", testStartTime);
    }

    @AfterEach
    void tearDown() {
        Instant testEndTime = Instant.now();
        Duration duration = Duration.between(testStartTime, testEndTime);
        log.info("테스트 종료 시각: {}", testEndTime);
        log.info("테스트 실행 시간: {}ms", duration.toMillis());
        log.info("=".repeat(80));
    }

    @Test
    @Order(1)
    @DisplayName("Scenario 1: [지도 로딩] 전체 구역(보스) 마커 정보를 조회한다")
    void getAllBosses() {
        log.info(">>> [Scenario 1] 전체 보스 조회 테스트 시작");

        // given
        log.info("[GIVEN] Mock 보스 데이터 준비");
        RaidBoss boss = mock(RaidBoss.class);
        when(boss.getId()).thenReturn(1L);
        when(boss.getH3Index()).thenReturn(BOSS_H3);
        when(boss.getName()).thenReturn("강남역 구역");
        given(bossRepository.findAll()).willReturn(List.of(boss));
        log.info("  - 보스 ID: 1, 이름: 강남역 구역, H3: {}", BOSS_H3);

        // when
        log.info("[WHEN] getAllBosses 메서드 실행");
        Instant executeStart = Instant.now();
        List<RaidBossResponse> result = raidService.getAllBosses();
        Duration executionTime = Duration.between(executeStart, Instant.now());
        log.info("  - 실행 시간: {}ms", executionTime.toMillis());

        // then
        log.info("[THEN] 결과 검증");
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getName()).isEqualTo("강남역 구역");
        assertThat(result.get(0).getH3Index()).isEqualTo(BOSS_H3);
        log.info("  ✓ 조회 결과: {} 건", result.size());
        log.info(">>> [Scenario 1] 테스트 완료");
    }

    @Test
    @Order(2)
    @DisplayName("Scenario 2: [상세 조회] 특정 구역의 누적 정화량과 랭킹 Top 10을 반환한다")
    void getBossDetail() {
        log.info(">>> [Scenario 2] 보스 상세 조회 테스트 시작");

        // given
        Long bossId = 1L;
        log.info("[GIVEN] Mock 데이터 준비 - bossId: {}", bossId);

        RaidBoss boss = mock(RaidBoss.class);
        when(boss.getName()).thenReturn("강남역");
        given(bossRepository.findById(bossId)).willReturn(Optional.of(boss));
        given(recordRepository.sumTotalScoreByBossId(bossId)).willReturn(1500L);
        log.info("  - 누적 점수: 1500");

        Account account = mock(Account.class);
        when(account.getNickname()).thenReturn("줍줍왕");

        RaidRecord record = mock(RaidRecord.class);
        when(record.getAccount()).thenReturn(account);
        when(record.getTotalScore()).thenReturn(1500L);
        given(recordRepository.findTopRankers(eq(bossId), any(Pageable.class)))
                .willReturn(List.of(record));
        log.info("  - 랭커: 줍줍왕 (1500점)");

        // when
        log.info("[WHEN] getBossDetail 메서드 실행");
        Instant executeStart = Instant.now();
        RaidGroupInfoResponse response = raidService.getBossDetail(bossId);
        Duration executionTime = Duration.between(executeStart, Instant.now());
        log.info("  - 실행 시간: {}ms", executionTime.toMillis());

        // then
        log.info("[THEN] 결과 검증");
        assertThat(response.getTotalAccumulatedScore()).isEqualTo(1500L);
        assertThat(response.getBossName()).isEqualTo("강남역");
        assertThat(response.getTopRankers()).hasSize(1);
        assertThat(response.getTopRankers().get(0).getNickname()).isEqualTo("줍줍왕");
        assertThat(response.getTopRankers().get(0).getRank()).isEqualTo(1);
        log.info("  ✓ 보스명: {}, 누적: {}, 랭커: {} 명",
                response.getBossName(),
                response.getTotalAccumulatedScore(),
                response.getTopRankers().size());
        log.info(">>> [Scenario 2] 테스트 완료");
    }

    @Test
    @Order(3)
    @DisplayName("Scenario 3: [정산] 방문한 경로에 구역이 있고 기존 기록이 있다면, UPDATE 쿼리만 실행된다")
    void applyRaidScore_Update() {
        log.info(">>> [Scenario 3] 레이드 점수 업데이트 테스트 시작");

        // given
        log.info("[GIVEN] 기존 기록이 있는 상황 Mock");
        RaidBoss boss = mock(RaidBoss.class);
        when(boss.getId()).thenReturn(10L);
        when(boss.getH3Index()).thenReturn(BOSS_H3);
        given(bossRepository.findAll()).willReturn(List.of(boss));
        given(recordRepository.addDamage(eq(10L), eq(USER_ID), anyInt())).willReturn(1);
        log.info("  - 사용자: {}, 보스: {}", USER_ID, BOSS_H3);

        // when
        log.info("[WHEN] applyRaidScore 메서드 실행 (UPDATE 경로)");
        Instant executeStart = Instant.now();
        int totalScore = raidService.applyRaidScore(USER_ID, Set.of(BOSS_H3));
        Duration executionTime = Duration.between(executeStart, Instant.now());
        log.info("  - 실행 시간: {}ms", executionTime.toMillis());

        // then
        log.info("[THEN] UPDATE 검증");
        assertThat(totalScore).isEqualTo(500);
        verify(recordRepository, times(0)).save(any(RaidRecord.class));
        log.info("  ✓ 총 점수: {}, INSERT 호출: 0회", totalScore);
        log.info(">>> [Scenario 3] 테스트 완료");
    }

    @Test
    @Order(4)
    @DisplayName("Scenario 4: [정산] 방문한 경로에 구역이 있고 첫 방문이라면, INSERT 쿼리가 실행된다")
    void applyRaidScore_Insert() {
        log.info(">>> [Scenario 4] 레이드 점수 신규 생성 테스트 시작");

        // given
        log.info("[GIVEN] 기록이 없는 상황 Mock");
        RaidBoss boss = mock(RaidBoss.class);
        when(boss.getId()).thenReturn(10L);
        when(boss.getH3Index()).thenReturn(BOSS_H3);
        given(bossRepository.findAll()).willReturn(List.of(boss));
        given(recordRepository.addDamage(eq(10L), eq(USER_ID), anyInt())).willReturn(0);

        Account account = mock(Account.class);
        given(accountRepository.getReferenceById(USER_ID)).willReturn(account);
        log.info("  - 사용자: {}, 보스: {} (첫 방문)", USER_ID, BOSS_H3);

        // when
        log.info("[WHEN] applyRaidScore 메서드 실행 (INSERT 경로)");
        Instant executeStart = Instant.now();
        int totalScore = raidService.applyRaidScore(USER_ID, Set.of(BOSS_H3));
        Duration executionTime = Duration.between(executeStart, Instant.now());
        log.info("  - 실행 시간: {}ms", executionTime.toMillis());

        // then
        log.info("[THEN] INSERT 검증");
        assertThat(totalScore).isEqualTo(500);
        verify(recordRepository, times(1)).save(any(RaidRecord.class));
        log.info("  ✓ 총 점수: {}, INSERT 호출: 1회", totalScore);
        log.info(">>> [Scenario 4] 테스트 완료");
    }

    @Test
    @Order(5)
    @DisplayName("Scenario 5: [엣지] 방문한 경로에 구역(보스)이 하나도 없으면 0점을 반환한다")
    void applyRaidScore_NoBoss() {
        log.info(">>> [Scenario 5] 보스 없는 경로 테스트 시작");

        // given
        log.info("[GIVEN] 방문 경로에 보스가 없는 상황");
        RaidBoss boss = mock(RaidBoss.class);
        when(boss.getH3Index()).thenReturn("OTHER_PLACE");
        given(bossRepository.findAll()).willReturn(List.of(boss));
        log.info("  - 사용자 경로: {}, 보스 위치: OTHER_PLACE (불일치)", BOSS_H3);

        // when
        log.info("[WHEN] applyRaidScore 메서드 실행");
        Instant executeStart = Instant.now();
        int totalScore = raidService.applyRaidScore(USER_ID, Set.of(BOSS_H3));
        Duration executionTime = Duration.between(executeStart, Instant.now());
        log.info("  - 실행 시간: {}ms", executionTime.toMillis());

        // then
        log.info("[THEN] 0점 반환 검증");
        assertThat(totalScore).isEqualTo(0);
        verify(recordRepository, times(0)).addDamage(anyLong(), anyString(), anyInt());
        log.info("  ✓ 총 점수: 0, addDamage 호출: 0회");
        log.info(">>> [Scenario 5] 테스트 완료");
    }
}
