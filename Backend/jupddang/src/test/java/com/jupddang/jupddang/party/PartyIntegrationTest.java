package com.jupddang.jupddang.party;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.config.EmbeddedRedisConfig;
import com.jupddang.jupddang.party.domain.*;
import com.jupddang.jupddang.party.dto.request.PartyCreateRequest;
import com.jupddang.jupddang.party.dto.request.PartyJoinRequest;
import com.jupddang.jupddang.party.repository.PartyActivityRepository;
import com.jupddang.jupddang.party.repository.PartyMemberRepository;
import com.jupddang.jupddang.party.repository.PartyRepository;
import com.jupddang.jupddang.plogging.domain.Plogging;
import com.jupddang.jupddang.plogging.dto.request.PloggingEndRequest;
import com.jupddang.jupddang.plogging.repository.PloggingRepository;
import com.jupddang.jupddang.security.JwtTokenProvider;
import com.jupddang.jupddang.sns.entity.Post;
import com.jupddang.jupddang.sns.repository.PostRepository;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doNothing;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import jakarta.persistence.EntityManager;

@Slf4j
@SpringBootTest(properties = {
                "spring.cloud.gcp.core.enabled=false",
                "spring.cloud.gcp.storage.enabled=false",
                "spring.cloud.gcp.credentials.location=classpath:non-existent.json"
})
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Import(EmbeddedRedisConfig.class)
@Transactional
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@TestPropertySource(properties = {
                "spring.data.redis.host=localhost",
                "spring.data.redis.port=6379"
})
class PartyIntegrationTest {

        @Autowired
        private MockMvc mockMvc;

        @Autowired
        private ObjectMapper objectMapper;

        @Autowired
        private AccountRepository accountRepository;

        @Autowired
        private PartyRepository partyRepository;

        @Autowired
        private PartyMemberRepository partyMemberRepository;

        @Autowired
        private PartyActivityRepository partyActivityRepository;

        @Autowired
        private PloggingRepository ploggingRepository;

        @Autowired
        private PostRepository postRepository;

        @Autowired
        private JwtTokenProvider jwtTokenProvider;

        @Autowired
        private BCryptPasswordEncoder passwordEncoder;

        @MockBean
        private GcsImageService gcsImageService;

        private Instant testStartTime;

        // 테스트용 상수
        private static final String TEST_LEADER_ID = "leader";
        private static final String TEST_MEMBER1_ID = "member1";
        private static final String TEST_MEMBER2_ID = "member2";
        private static final String TEST_PASSWORD = "test1234!";
        private static final String TEST_EMAIL_TEMPLATE = "%s@test.com";
        private static final String TEST_NICKNAME_TEMPLATE = "User_%s";
        private static final String TEST_REGION = "서울";
        private static final String TEST_PARTY_NAME = "테스트 파티";
        private static final String MOCK_IMAGE_URL = "https://storage.googleapis.com/test-bucket/test-image.jpg";

        @BeforeEach
        void setUp() {
                testStartTime = Instant.now();
                log.info("=".repeat(80));
                log.info("📌 테스트 시작: {}", testStartTime);

                // GCS Mock 설정
                given(gcsImageService.uploadImage(any(), anyString())).willReturn(MOCK_IMAGE_URL);
                doNothing().when(gcsImageService).deleteImage(anyString());

                partyActivityRepository.deleteAll();
                partyMemberRepository.deleteAll();
                partyRepository.deleteAll();
        }

        @AfterEach
        void tearDown() {
                Instant testEndTime = Instant.now();
                Duration duration = Duration.between(testStartTime, testEndTime);
                log.info("⏱️  테스트 실행 시간: {}ms", duration.toMillis());
                log.info("=".repeat(80));
        }

        @Test
        @Order(1)
        @DisplayName("Scenario 1: 파티 생성 및 초대 코드 검증")
        void testCreatePartyAndInviteCode() throws Exception {
                log.info(">>> [Scenario 1] 파티 생성 및 초대 코드 테스트 시작");

                // Step 1: 방장 계정 생성
                Account leader = createTestAccount(TEST_LEADER_ID);
                String token = generateToken(leader);

                // Step 2: 초대 코드 생성 요청
                MvcResult inviteCodeResult = mockMvc.perform(get("/api/party/id")
                                .header("Authorization", "Bearer " + token))
                                .andDo(print())
                                .andExpect(status().isOk())
                                .andExpect(jsonPath("$.inviteCode").exists())
                                .andExpect(jsonPath("$.inviteCode").isString())
                                .andReturn();

                String inviteCodeJson = inviteCodeResult.getResponse().getContentAsString();
                String inviteCode = objectMapper.readTree(inviteCodeJson).get("inviteCode").asText();

                assertThat(inviteCode).hasSize(6);
                assertThat(inviteCode).matches("\\d{6}");

                log.info("  ✅ 초대 코드 생성 성공: {}", inviteCode);

                // Step 3: 파티 생성
                PartyCreateRequest createRequest = new PartyCreateRequest(TEST_PARTY_NAME);

                MvcResult createResult = mockMvc.perform(post("/api/party")
                                .header("Authorization", "Bearer " + token)
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(objectMapper.writeValueAsString(createRequest)))
                                .andDo(print())
                                .andExpect(status().isCreated())
                                .andExpect(jsonPath("$.partyId").exists())
                                .andExpect(jsonPath("$.inviteCode").exists())
                                .andExpect(jsonPath("$.name").value(TEST_PARTY_NAME))
                                .andExpect(jsonPath("$.isLeader").value(true))
                                .andReturn();

                String createJson = createResult.getResponse().getContentAsString();
                Long partyId = objectMapper.readTree(createJson).get("partyId").asLong();

                log.info("  ✅ 파티 생성 성공: partyId={}", partyId);

                // Step 4: DB 검증
                Party savedParty = partyRepository.findById(partyId).orElseThrow();
                assertThat(savedParty.getName()).isEqualTo(TEST_PARTY_NAME);
                assertThat(savedParty.getLeaderId()).isEqualTo(TEST_LEADER_ID);
                assertThat(savedParty.getStatus()).isEqualTo(PartyStatus.WAITING);
                assertThat(savedParty.getInviteCode()).hasSize(6);

                // 방장이 자동으로 멤버에 추가되었는지 확인
                boolean leaderIsMember = partyMemberRepository.existsByPartyIdAndUserId(partyId, TEST_LEADER_ID);
                assertThat(leaderIsMember).isTrue();

                log.info("  ✅ DB 검증 완료: 파티 상태={}, 방장 멤버 추가 확인", savedParty.getStatus());
        }

        @Test
        @Order(2)
        @DisplayName("Scenario 2: 파티 참여 및 멤버 관리")
        void testJoinPartyAndMemberManagement() throws Exception {
                log.info(">>> [Scenario 2] 파티 참여 및 멤버 관리 테스트 시작");

                // Step 1: 파티 생성 (방장)
                Account leader = createTestAccount(TEST_LEADER_ID);
                String leaderToken = generateToken(leader);
                Long partyId = createPartyAsLeader(leader, TEST_PARTY_NAME);

                Party party = partyRepository.findById(partyId).orElseThrow();
                String inviteCode = party.getInviteCode();

                log.info("  ✅ 파티 생성 완료: inviteCode={}", inviteCode);

                // Step 2: 첫 번째 멤버 참여
                Account member1 = createTestAccount(TEST_MEMBER1_ID);
                String member1Token = generateToken(member1);

                PartyJoinRequest joinRequest = new PartyJoinRequest(inviteCode);

                mockMvc.perform(post("/api/party/join")
                                .header("Authorization", "Bearer " + member1Token)
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(objectMapper.writeValueAsString(joinRequest)))
                                .andDo(print())
                                .andExpect(status().isOk())
                                .andExpect(jsonPath("$.partyId").value(partyId))
                                .andExpect(jsonPath("$.partyName").value(TEST_PARTY_NAME))
                                .andExpect(jsonPath("$.isLeader").value(false))
                                .andExpect(jsonPath("$.currentMembers").value(2))
                                .andExpect(jsonPath("$.maxMembers").value(6));

                log.info("  ✅ Member1 참여 성공: 현재 인원 2명");

                // Step 3: 두 번째 멤버 참여
                Account member2 = createTestAccount(TEST_MEMBER2_ID);
                String member2Token = generateToken(member2);

                mockMvc.perform(post("/api/party/join")
                                .header("Authorization", "Bearer " + member2Token)
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(objectMapper.writeValueAsString(joinRequest)))
                                .andDo(print())
                                .andExpect(status().isOk())
                                .andExpect(jsonPath("$.currentMembers").value(3));

                log.info("  ✅ Member2 참여 성공: 현재 인원 3명");

                // Step 4: 중복 참여 시도 (실패해야 함)
                mockMvc.perform(post("/api/party/join")
                                .header("Authorization", "Bearer " + member1Token)
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(objectMapper.writeValueAsString(joinRequest)))
                                .andDo(print())
                                .andExpect(status().is4xxClientError());

                log.info("  ✅ 중복 참여 방지 검증 완료");

                // Step 5: DB 검증
                long memberCount = partyMemberRepository.countByPartyId(partyId);
                assertThat(memberCount).isEqualTo(3);

                List<PartyMember> members = partyMemberRepository.findByPartyId(partyId);
                List<String> memberIds = members.stream().map(PartyMember::getUserId).toList();
                assertThat(memberIds).containsExactlyInAnyOrder(TEST_LEADER_ID, TEST_MEMBER1_ID, TEST_MEMBER2_ID);

                log.info("  ✅ DB 멤버 검증 완료: 총 {}명", memberCount);
        }

        @Test
        @Order(3)
        @DisplayName("Scenario 3: 파티 시작 (방장 전용)")
        void testStartParty() throws Exception {
                log.info(">>> [Scenario 3] 파티 시작 테스트 시작");

                // Step 1: 파티 및 멤버 준비
                Account leader = createTestAccount(TEST_LEADER_ID);
                Account member1 = createTestAccount(TEST_MEMBER1_ID);
                String leaderToken = generateToken(leader);
                String member1Token = generateToken(member1);

                Long partyId = createPartyAsLeader(leader, TEST_PARTY_NAME);
                joinParty(partyId, member1);

                // Step 2: 일반 멤버가 시작 시도 (실패해야 함)
                mockMvc.perform(post("/api/party/" + partyId + "/start")
                                .header("Authorization", "Bearer " + member1Token))
                                .andDo(print())
                                .andExpect(status().is4xxClientError());

                log.info("  ✅ 일반 멤버의 시작 시도 차단 확인");

                em.flush();
                em.clear();

                // Step 3: 방장이 파티 시작
                mockMvc.perform(post("/api/party/" + partyId + "/start")
                                .header("Authorization", "Bearer " + leaderToken))
                                .andDo(print())
                                .andExpect(status().isOk())
                                .andExpect(jsonPath("$.partyId").value(partyId))
                                .andExpect(jsonPath("$.status").value("IN_PROGRESS"))
                                .andExpect(jsonPath("$.startedAt").exists())
                                .andExpect(jsonPath("$.totalMembers").value(2))
                                .andExpect(jsonPath("$.startedMemberIds").isArray());

                log.info("  ✅ 방장의 파티 시작 성공");

                // Step 4: DB 검증
                Party party = partyRepository.findById(partyId).orElseThrow();
                assertThat(party.getStatus()).isEqualTo(PartyStatus.IN_PROGRESS);
                assertThat(party.getStartedAt()).isNotNull();

                // PartyActivity가 모든 멤버에 대해 생성되었는지 확인
                List<PartyActivity> activities = partyActivityRepository.findByPartyId(partyId);
                assertThat(activities).hasSize(2);

                for (PartyActivity activity : activities) {
                        assertThat(activity.getStatus()).isEqualTo(ActivityStatus.IN_PROGRESS);
                        assertThat(activity.getStartedAt()).isNotNull();
                }

                log.info("  ✅ DB 검증 완료: 파티 상태={}, 활동 레코드={}개", party.getStatus(), activities.size());
        }

        @Autowired
        private EntityManager em;

        @Test
        @Order(4)
        @DisplayName("Scenario 4: 실시간 활동 상태 조회")
        void testGetActivityStatus() throws Exception {
                log.info(">>> [Scenario 4] 실시간 활동 상태 조회 테스트 시작");

                // Step 1: 파티 생성 및 시작
                Account leader = createTestAccount(TEST_LEADER_ID);
                Account member1 = createTestAccount(TEST_MEMBER1_ID);
                String leaderToken = generateToken(leader);

                Long partyId = createPartyAsLeader(leader, TEST_PARTY_NAME);
                joinParty(partyId, member1);

                em.flush();
                em.clear();

                startParty(partyId, leader);

                log.info("  ✅ 파티 시작 완료");

                // Step 2: 활동 상태 조회
                mockMvc.perform(get("/api/party/" + partyId + "/activities")
                                .header("Authorization", "Bearer " + leaderToken))
                                .andDo(print())
                                .andExpect(status().isOk())
                                .andExpect(jsonPath("$.partyId").value(partyId))
                                .andExpect(jsonPath("$.activities").isArray())
                                .andExpect(jsonPath("$.activities.length()").value(2))
                                .andExpect(jsonPath("$.activities[0].status").value("IN_PROGRESS"))
                                .andExpect(jsonPath("$.activities[0].startedAt").exists())
                                .andExpect(jsonPath("$.activities[1].status").value("IN_PROGRESS"));

                log.info("  ✅ 활동 상태 조회 성공");

                // Step 3: 비회원 접근 차단 확인
                Account outsider = createTestAccount("outsider");
                String outsiderToken = generateToken(outsider);

                mockMvc.perform(get("/api/party/" + partyId + "/activities")
                                .header("Authorization", "Bearer " + outsiderToken))
                                .andDo(print())
                                .andExpect(status().is4xxClientError());

                log.info("  ✅ 비회원 접근 차단 확인");
        }

        @Test
        @Order(5)
        @DisplayName("Scenario 5: 활동 완료 (Plogging & SNS 통합)")
        void testCompleteActivityWithPloggingAndSns() throws Exception {
                log.info(">>> [Scenario 5] 활동 완료 및 Plogging/SNS 통합 테스트 시작");

                // Step 1: 파티 생성
                Account leader = createTestAccount(TEST_LEADER_ID);
                String leaderToken = generateToken(leader);
                Long partyId = createPartyAsLeader(leader, TEST_PARTY_NAME);

                // Step 2: 멤버 추가 (최소 인원 조건 충족을 위해 필수!)
                Account member1 = createTestAccount("temp_member_s5");
                joinParty(partyId, member1);

                // [핵심 수정] 영속성 컨텍스트 비우기
                // (이걸 안 하면 startParty 때 옛날 데이터를 가져와서 실패함)
                em.flush();
                em.clear();

                // Step 3: 파티 시작
                startParty(partyId, leader);

                log.info("  ✅ 파티 시작 완료");
                ;

                // Step 4: PloggingEndRequest 준비
                PloggingEndRequest ploggingRequest = new PloggingEndRequest(
                                null, // ploggingId
                                "플로깅 완료!", // content
                                5.5, // distance
                                3600, // times
                                "테스트 기록", // recordTitle
                                null, // partyId
                                null, // score
                                java.time.LocalDateTime.now() // endTime
                );

                // Step 5: 이미지 파일 준비
                MockMultipartFile beforeImage = new MockMultipartFile(
                                "beforeImage", "before.jpg", "image/jpeg", "before-content".getBytes());
                MockMultipartFile afterImage = new MockMultipartFile(
                                "afterImage", "after.jpg", "image/jpeg", "after-content".getBytes());
                MockMultipartFile mapImage = new MockMultipartFile(
                                "mapImage", "map.jpg", "image/jpeg", "map-content".getBytes());
                MockMultipartFile dataPart = new MockMultipartFile(
                                "data", "", "application/json",
                                objectMapper.writeValueAsBytes(ploggingRequest));

                // Step 6: 활동 완료 요청
                MvcResult completeResult = mockMvc
                                .perform(multipart(HttpMethod.POST, "/api/party/" + partyId + "/activities/complete")
                                                .file(dataPart)
                                                .file(beforeImage)
                                                .file(afterImage)
                                                .file(mapImage)
                                                .header("Authorization", "Bearer " + leaderToken))
                                .andDo(print())
                                .andExpect(status().isOk())
                                .andExpect(jsonPath("$.activityId").exists())
                                .andExpect(jsonPath("$.partyId").value(partyId))
                                .andExpect(jsonPath("$.userId").value(TEST_LEADER_ID))
                                .andExpect(jsonPath("$.status").value("COMPLETED"))
                                .andExpect(jsonPath("$.endedAt").exists())
                                .andExpect(jsonPath("$.ploggingId").exists())
                                .andExpect(jsonPath("$.postId").exists())
                                .andExpect(jsonPath("$.distance").value(5.5))
                                .andReturn();

                String completeJson = completeResult.getResponse().getContentAsString();
                Long ploggingId = objectMapper.readTree(completeJson).get("ploggingId").asLong();
                Long postId = objectMapper.readTree(completeJson).get("postId").asLong();

                log.info("  ✅ 활동 완료 성공: ploggingId={}, postId={}", ploggingId, postId);

                // Step 7: DB 검증 - PartyActivity
                PartyActivity activity = partyActivityRepository
                                .findByPartyIdAndUserId(partyId, TEST_LEADER_ID)
                                .orElseThrow();

                assertThat(activity.getStatus()).isEqualTo(ActivityStatus.COMPLETED);
                assertThat(activity.getEndedAt()).isNotNull();
                assertThat(activity.getDistance()).isEqualTo(5.5);
                assertThat(activity.getPlogging()).isNotNull();

                // Step 8: DB 검증 - Plogging
                Plogging plogging = ploggingRepository.findById(ploggingId).orElseThrow();
                assertThat(plogging.getAccount().getUserId()).isEqualTo(TEST_LEADER_ID);
                assertThat(plogging.getDistance()).isEqualTo(5.5);
                assertThat(plogging.getTimes()).isEqualTo(3600);

                // Step 9: DB 검증 - Post (SNS)
                Post post = postRepository.findById(postId).orElseThrow();
                assertThat(post.getPloggingId()).isEqualTo(ploggingId);
                assertThat(post.getAccount().getUserId()).isEqualTo(TEST_LEADER_ID);
                assertThat(post.getContent()).isEqualTo("플로깅 완료!");
                assertThat(post.getBeforeImageUrl()).isEqualTo(MOCK_IMAGE_URL);
                assertThat(post.getAfterImageUrl()).isEqualTo(MOCK_IMAGE_URL);
                assertThat(post.getMapImageUrl()).isEqualTo(MOCK_IMAGE_URL);

                log.info("  ✅ DB 검증 완료: PartyActivity, Plogging, Post 모두 정상 생성");
        }

        @Test
        @Order(6)
        @DisplayName("Scenario 6: [대용량] 50개 파티 동시 생성")
        void testConcurrentPartyCreation() throws InterruptedException {
                log.info(">>> [Scenario 6] 동시 파티 생성 테스트 시작");

                int partyCount = 50;
                ExecutorService executor = Executors.newFixedThreadPool(16);
                CountDownLatch latch = new CountDownLatch(partyCount);
                AtomicInteger successCount = new AtomicInteger(0);
                AtomicInteger failCount = new AtomicInteger(0);

                for (int i = 0; i < partyCount; i++) {
                        final int idx = i;
                        executor.submit(() -> {
                                try {
                                        // 각 파티마다 다른 방장 생성
                                        Account leader = createTestAccount("leader" + idx);
                                        String token = generateToken(leader);

                                        PartyCreateRequest request = new PartyCreateRequest("Party_" + idx);

                                        mockMvc.perform(post("/api/party")
                                                        .header("Authorization", "Bearer " + token)
                                                        .contentType(MediaType.APPLICATION_JSON)
                                                        .content(objectMapper.writeValueAsString(request)))
                                                        .andExpect(status().isCreated())
                                                        .andExpect(jsonPath("$.inviteCode").exists());

                                        successCount.incrementAndGet();
                                } catch (Exception e) {
                                        failCount.incrementAndGet();
                                        log.error("Fail: {}", e.getMessage());
                                } finally {
                                        latch.countDown();
                                }
                        });
                }

                latch.await(30, TimeUnit.SECONDS);
                executor.shutdown();

                log.info("  ✅ 성공: {}, ❌ 실패: {}", successCount.get(), failCount.get());

                assertThat(successCount.get()).isEqualTo(partyCount);

                // 초대 코드 중복 검증
                List<Party> allParties = partyRepository.findAll();
                long uniqueInviteCodes = allParties.stream()
                                .map(Party::getInviteCode)
                                .distinct()
                                .count();

                assertThat(uniqueInviteCodes).isEqualTo(allParties.size());
                log.info("  ✅ 초대 코드 중복 없음: {}개 파티, {}개 고유 코드", allParties.size(), uniqueInviteCodes);
        }

        // --- Helper Methods ---

        private Account createTestAccount(String userId) {
                Account account = Account.builder()
                                .userId(userId)
                                .pw(passwordEncoder.encode(TEST_PASSWORD))
                                .email(String.format(TEST_EMAIL_TEMPLATE, userId))
                                .nickname(String.format(TEST_NICKNAME_TEMPLATE, userId))
                                .color("#000000")
                                .build();
                return accountRepository.save(account);
        }

        private String generateToken(Account account) {
                return jwtTokenProvider.createAccessToken(
                                account.getUserId(),
                                List.of("ROLE_USER"));
        }

        private Long createPartyAsLeader(Account leader, String partyName) throws Exception {
                String token = generateToken(leader);
                PartyCreateRequest request = new PartyCreateRequest(partyName);

                MvcResult result = mockMvc.perform(post("/api/party")
                                .header("Authorization", "Bearer " + token)
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(objectMapper.writeValueAsString(request)))
                                .andExpect(status().isCreated())
                                .andReturn();

                String json = result.getResponse().getContentAsString();
                return objectMapper.readTree(json).get("partyId").asLong();
        }

        private void joinParty(Long partyId, Account member) throws Exception {
                Party party = partyRepository.findById(partyId).orElseThrow();
                String token = generateToken(member);
                PartyJoinRequest request = new PartyJoinRequest(party.getInviteCode());

                mockMvc.perform(post("/api/party/join")
                                .header("Authorization", "Bearer " + token)
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(objectMapper.writeValueAsString(request)))
                                .andExpect(status().isOk());
        }

        private void startParty(Long partyId, Account leader) throws Exception {
                String token = generateToken(leader);

                mockMvc.perform(post("/api/party/" + partyId + "/start")
                                .header("Authorization", "Bearer " + token))
                                .andExpect(status().isOk());
        }
}
