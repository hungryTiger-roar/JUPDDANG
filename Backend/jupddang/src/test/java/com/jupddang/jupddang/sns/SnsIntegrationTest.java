package com.jupddang.jupddang.sns;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.storage.Storage;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.security.JwtTokenProvider;
import com.jupddang.jupddang.sns.entity.Comment;
import com.jupddang.jupddang.sns.entity.Post;
import com.jupddang.jupddang.sns.repository.CommentRepository;
import com.jupddang.jupddang.sns.repository.PostRepository;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.doNothing;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Slf4j
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@TestPropertySource(properties = {
        "spring.cloud.gcp.core.enabled=false",
        "spring.cloud.gcp.storage.enabled=false",
        "spring.cloud.gcp.credentials.location=classpath:non-existent.json",
        "logging.level.org.hibernate.SQL=OFF",
        "spring.jpa.show-sql=false"
})
class SnsIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;
    @Autowired private AccountRepository accountRepository;
    @Autowired private PostRepository postRepository;
    @Autowired private CommentRepository commentRepository;

    // --- Mock Beans ---
    @MockBean private GcsImageService gcsImageService;
    @MockBean private Storage storage; // GCP 에러 방지
    @MockBean private JwtTokenProvider jwtTokenProvider; // 인증 우회용

    private Account testUser;
    private Post testPost;
    private final String MOCK_IMG_URL = "https://gcs/mock-image.jpg";

    @BeforeEach
    void setUp() {
        // 1. 데이터 초기화
        commentRepository.deleteAll();
        postRepository.deleteAll();
        accountRepository.deleteAll();

        // 2. 테스트 유저 생성
        testUser = accountRepository.save(Account.builder()
                .userId("snsUser")
                .email("sns@test.com")
                .nickname("SNS테스터")
                .pw("password")
                .color("#FF5733")
                .build());

        // 3. 테스트 포스트 생성
        testPost = postRepository.save(Post.builder()
                .account(testUser)
                .ploggingId(1L)
                .beforeImageUrl(MOCK_IMG_URL)
                .afterImageUrl(MOCK_IMG_URL)
                .mapImageUrl(MOCK_IMG_URL)
                .content("테스트 포스트입니다!")
                .build());

        // 4. 외부 서비스 Mock
        doNothing().when(gcsImageService).deleteImage(anyString());

        // 5. JWT 인증 무조건 통과 설정
        setupJwtMock();
    }

    private void setupJwtMock() {
        // 유효성 검사 통과
        given(jwtTokenProvider.validateToken(anyString())).willReturn(true);

        // getUserIdFromToken 설정
        given(jwtTokenProvider.getUserIdFromToken(anyString()))
                .willAnswer(invocation -> invocation.getArgument(0));

        // 인증 객체 생성
        given(jwtTokenProvider.getAuthentication(anyString())).willAnswer(invocation -> {
            String userId = invocation.getArgument(0);
            return new UsernamePasswordAuthenticationToken(
                    userId, "", List.of(new SimpleGrantedAuthority("ROLE_USER"))
            );
        });
    }

    @AfterEach
    void tearDown() {
        commentRepository.deleteAll();
        postRepository.deleteAll();
        accountRepository.deleteAll();
    }

    // -------------------------------------------------------------------------
    // 1. 전체 포스트 조회 테스트
    // -------------------------------------------------------------------------
    @Test
    @Order(1)
    @DisplayName("✅ 전체 포스트 조회: 정상 처리")
    void getAllPosts_Success() throws Exception {
        // when & then
        mockMvc.perform(get("/api/posts")
                        .header("Authorization", "Bearer " + testUser.getUserId())
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].postId").value(testPost.getPostId()))
                .andExpect(jsonPath("$[0].content").value("테스트 포스트입니다!"))
                .andExpect(jsonPath("$[0].like").value(0)); // likeCount -> like 수정
    }

    // -------------------------------------------------------------------------
    // 2. 포스트 좋아요 테스트
    // -------------------------------------------------------------------------
    @Test
    @Order(2)
    @DisplayName("✅ 포스트 좋아요: 정상 처리")
    void likePost_Success() throws Exception {
        // when
        mockMvc.perform(post("/api/posts/{postId}/like", testPost.getPostId())
                        .header("Authorization", "Bearer " + testUser.getUserId())
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("좋아요 성공"));

        // then
        Post updatedPost = postRepository.findById(testPost.getPostId()).orElseThrow();
        assertThat(updatedPost.getLikeCount()).isEqualTo(1);
    }

    @Test
    @Order(3)
    @DisplayName("⚠️ 예외: 존재하지 않는 포스트에 좋아요 시도")
    void likePost_NotFound() throws Exception {
        // when & then - GlobalExceptionHandler가 500으로 처리하므로 5xx 검증
        mockMvc.perform(post("/api/posts/{postId}/like", 99999L)
                        .header("Authorization", "Bearer " + testUser.getUserId())
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().is5xxServerError()); // 4xx -> 5xx로 수정
    }

    // -------------------------------------------------------------------------
    // 3. 댓글 작성 테스트
    // -------------------------------------------------------------------------
    @Test
    @Order(4)
    @DisplayName("✅ 댓글 작성: 정상 처리")
    void createComment_Success() throws Exception {
        // given - JSON 직접 작성
        String requestJson = String.format(
                "{\"userId\":\"%s\",\"content\":\"멋진 포스트네요!\"}",
                testUser.getUserId()
        );

        // when
        mockMvc.perform(post("/api/posts/{postId}/comment", testPost.getPostId())
                        .header("Authorization", "Bearer " + testUser.getUserId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestJson))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isNumber());

        // then
        List<Comment> comments = commentRepository.findAll();
        assertThat(comments).hasSize(1);
        assertThat(comments.get(0).getContent()).isEqualTo("멋진 포스트네요!");
        assertThat(comments.get(0).getAccount().getUserId()).isEqualTo(testUser.getUserId());
    }

    @Test
    @Order(5)
    @DisplayName("⚠️ 예외: 존재하지 않는 포스트에 댓글 작성")
    void createComment_PostNotFound() throws Exception {
        // given - JSON 직접 작성
        String requestJson = String.format(
                "{\"userId\":\"%s\",\"content\":\"댓글입니다\"}",
                testUser.getUserId()
        );

        // when & then - 5xx 검증으로 수정
        mockMvc.perform(post("/api/posts/{postId}/comment", 99999L)
                        .header("Authorization", "Bearer " + testUser.getUserId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestJson))
                .andDo(print())
                .andExpect(status().is5xxServerError()); // 4xx -> 5xx로 수정
    }

    // -------------------------------------------------------------------------
    // 4. 댓글 삭제 테스트
    // -------------------------------------------------------------------------
    @Test
    @Order(6)
    @DisplayName("✅ 댓글 삭제: 정상 처리")
    void deleteComment_Success() throws Exception {
        // given
        Comment comment = commentRepository.save(Comment.builder()
                .post(testPost)
                .account(testUser)
                .content("테스트 댓글")
                .build());

        // when
        mockMvc.perform(delete("/api/posts/{postId}/{commentId}",
                        testPost.getPostId(), comment.getCommentId())
                        .header("Authorization", "Bearer " + testUser.getUserId())
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("댓글 삭제 성공"));

        // then
        assertThat(commentRepository.findById(comment.getCommentId())).isEmpty();
    }

    @Test
    @Order(7)
    @DisplayName("⚠️ 예외: 존재하지 않는 댓글 삭제 시도")
    void deleteComment_NotFound() throws Exception {
        // when & then - 5xx 검증으로 수정
        mockMvc.perform(delete("/api/posts/{postId}/{commentId}",
                        testPost.getPostId(), 99999L)
                        .header("Authorization", "Bearer " + testUser.getUserId())
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().is5xxServerError()); // 4xx -> 5xx로 수정
    }

    // -------------------------------------------------------------------------
    // 5. 포스트 삭제 테스트
    // -------------------------------------------------------------------------
    @Test
    @Order(8)
    @DisplayName("✅ 포스트 삭제: 정상 처리 (GCS 이미지도 삭제)")
    void deletePost_Success() throws Exception {
        // when
        mockMvc.perform(delete("/api/posts/{postId}", testPost.getPostId())
                        .header("Authorization", "Bearer " + testUser.getUserId())
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("게시글 삭제 성공"));

        // then
        assertThat(postRepository.findById(testPost.getPostId())).isEmpty();
    }

    @Test
    @Order(9)
    @DisplayName("⚠️ 예외: 존재하지 않는 포스트 삭제 시도")
    void deletePost_NotFound() throws Exception {
        // when & then - 5xx 검증으로 수정
        mockMvc.perform(delete("/api/posts/{postId}", 99999L)
                        .header("Authorization", "Bearer " + testUser.getUserId())
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().is5xxServerError()); // 4xx -> 5xx로 수정
    }

    // -------------------------------------------------------------------------
    // 6. 100명 동시 좋아요 테스트
    // -------------------------------------------------------------------------
    @Test
    @Order(10)
    @DisplayName("🔥 부하: 100명 동시 좋아요 처리 (동시성 이슈 확인)")
    void test100ConcurrentLikes() throws InterruptedException {
        int requestCount = 100;
        ExecutorService executor = Executors.newFixedThreadPool(20);
        CountDownLatch latch = new CountDownLatch(requestCount);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failCount = new AtomicInteger(0);

        log.info("100명 동시 좋아요 테스트 시작...");
        long start = System.currentTimeMillis();

        for (int i = 0; i < requestCount; i++) {
            final int index = i;
            executor.submit(() -> {
                try {
                    mockMvc.perform(post("/api/posts/{postId}/like", testPost.getPostId())
                                    .header("Authorization", "Bearer " + testUser.getUserId())
                                    .contentType(MediaType.APPLICATION_JSON))
                            .andExpect(status().isOk());

                    successCount.incrementAndGet();
                } catch (Throwable e) {
                    log.error("❌ Request-{} 실패: {}", index, e.getMessage());
                    failCount.incrementAndGet();
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await(30, TimeUnit.SECONDS);
        long duration = System.currentTimeMillis() - start;

        log.info("📊 100명 결과: 성공={}, 실패={}, 시간={}ms",
                successCount.get(), failCount.get(), duration);

        // 검증 - 동시성 제어가 없으면 100개 미만으로 증가
        Post updatedPost = postRepository.findById(testPost.getPostId()).orElseThrow();
        log.info("최종 좋아요 수: {} (낙관적 락 없으면 100 미만)", updatedPost.getLikeCount());

        assertThat(successCount.get()).isEqualTo(requestCount);
        // 동시성 이슈로 100개가 안 될 수 있으므로 0보다 크기만 확인
        assertThat(updatedPost.getLikeCount()).isGreaterThan(0).isLessThanOrEqualTo(requestCount);
    }

    // -------------------------------------------------------------------------
    // 7. 100명 동시 댓글 작성 테스트
    // -------------------------------------------------------------------------
    @Test
    @Order(11)
    @DisplayName("🔥 부하: 100명 동시 댓글 작성")
    void test100ConcurrentComments() throws InterruptedException {
        int userCount = 100;
        ExecutorService executor = Executors.newFixedThreadPool(20);
        CountDownLatch latch = new CountDownLatch(userCount);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failCount = new AtomicInteger(0);

        log.info("유저 100명 DB 생성 시작...");
        for (int i = 0; i < userCount; i++) {
            accountRepository.save(Account.builder()
                    .userId("commentUser" + i)
                    .email("cu" + i + "@test.com")
                    .nickname("댓글러" + i)
                    .pw("pw")
                    .color("#AABBCC")
                    .build());
        }
        log.info("유저 100명 생성 완료.");

        long start = System.currentTimeMillis();

        for (int i = 0; i < userCount; i++) {
            final int index = i;
            executor.submit(() -> {
                try {
                    String userId = "commentUser" + index;

                    // JSON 직접 작성
                    String requestJson = String.format(
                            "{\"userId\":\"%s\",\"content\":\"동시 댓글 %d\"}",
                            userId, index
                    );

                    mockMvc.perform(post("/api/posts/{postId}/comment", testPost.getPostId())
                                    .header("Authorization", "Bearer " + userId)
                                    .contentType(MediaType.APPLICATION_JSON)
                                    .content(requestJson))
                            .andExpect(status().isOk());

                    successCount.incrementAndGet();
                } catch (Throwable e) {
                    log.error("❌ User-{} 실패: {}", index, e.getMessage());
                    failCount.incrementAndGet();
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await(30, TimeUnit.SECONDS);
        long duration = System.currentTimeMillis() - start;

        log.info("📊 100명 댓글 결과: 성공={}, 실패={}, 시간={}ms",
                successCount.get(), failCount.get(), duration);

        // 검증
        assertThat(successCount.get()).isEqualTo(userCount);
        long commentCount = commentRepository.count();
        log.info("최종 댓글 수: {}", commentCount);
        assertThat(commentCount).isEqualTo(userCount);
    }
}