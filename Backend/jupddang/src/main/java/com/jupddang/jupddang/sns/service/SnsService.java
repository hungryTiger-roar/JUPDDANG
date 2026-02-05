package com.jupddang.jupddang.sns.service;

import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.follow.repository.FollowRepository;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.sns.dto.CommentRequestDto;
import com.jupddang.jupddang.sns.dto.MyCommentResponseDto;
import com.jupddang.jupddang.sns.dto.PostCreateRequest;
import com.jupddang.jupddang.sns.dto.PostResponseDto;
import com.jupddang.jupddang.sns.entity.Comment;
import com.jupddang.jupddang.sns.entity.Post;
import com.jupddang.jupddang.sns.repository.CommentRepository;
import com.jupddang.jupddang.sns.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class SnsService {
    private final PostRepository postRepository;
    private final CommentRepository commentRepository;
    private final GcsImageService gcsImageService;
    private final AccountRepository accountRepository;
    private final FollowRepository followRepository;

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void handlePloggingCompleted(PloggingCompletedEvent event) {
        log.info("PloggingCompletedEvent 수신 완료 (Post 생성은 앞단에서 처리됨) - ploggingId: {}", event.ploggingId());
    }

    @Transactional(readOnly = true)
    public List<PostResponseDto> getFollowFeed(Account loginUser) {
        List<Account> followingAccounts = followRepository.findAllByFollower(loginUser).stream()
                .map(follow -> follow.getFollowing())
                .collect(Collectors.toList());

        followingAccounts.add(loginUser);

        return postRepository.findAllByAccountInOrderByCreatedAtDesc(followingAccounts).stream()
                .map(PostResponseDto::new)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PostResponseDto> getAllPost() {
        List<Post> allPosts = postRepository.findAllByOrderByCreatedAtDesc();
        log.info("🔍 getAllPost: Total {} posts found", allPosts.size());
        
        // userId별로 카운트
        Map<String, Long> userPostCount = allPosts.stream()
            .filter(post -> post.getAccount() != null)
            .collect(Collectors.groupingBy(
                post -> post.getAccount().getUserId(),
                Collectors.counting()
            ));
        
        log.info("🔍 Posts per user: {}", userPostCount);
        
        return allPosts.stream()
                .map(PostResponseDto::new)
                .collect(Collectors.toList());
    }

    @Transactional
    public void like(Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException(postId + " 해당 게시글이 없습니다."));
        post.increaseLike();
    }

    @Transactional
    public void deletePost(Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("게시글이 없습니다."));

        gcsImageService.deleteImage(post.getBeforeImageUrl());
        gcsImageService.deleteImage(post.getAfterImageUrl());
        gcsImageService.deleteImage(post.getMapImageUrl());

        postRepository.delete(post);
    }

    @Transactional
    public Long createComment(Long postId, CommentRequestDto requestDto) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다. id=" + postId));

        Account account = accountRepository.findById(requestDto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("해당 유저가 없습니다."));

        Comment comment = Comment.builder()
                .post(post)
                .account(account)
                .content(requestDto.getContent())
                .build();

        return commentRepository.save(comment).getCommentId();
    }

    @Transactional
    public void deleteComment(Long postId, Long commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("해당 댓글이 없습니다. id=" + commentId));

        if (!comment.getPost().getPostId().equals(postId)) {
            throw new IllegalArgumentException("해당 게시글의 댓글이 아닙니다.");
        }

        commentRepository.delete(comment);
    }

    /**
     * 일반 게시글 작성 (플로깅 데이터 없음)
     * plogging/{userId}/{postId}/ 폴더 구조로 저장
     */
    @Transactional
    public Long createPost(Account account, PostCreateRequest request,
                           MultipartFile beforeImage, MultipartFile afterImage, MultipartFile mapImage) {

        // 1. 먼저 Post 저장 (이미지 URL 없이)
        Post post = Post.builder()
                .account(account)
                .content(request.getContent())
                .ploggingId(null)
                .build();

        Post savedPost = postRepository.save(post);
        Long postId = savedPost.getPostId();

        log.info("게시글 생성 완료 - postId: {}, userId: {}", postId, account.getUserId());

        // 2. 폴더 경로 생성: plogging/{userId}/{postId}/
        String folderPath = String.format("plogging/%s/%d", account.getUserId(), postId);

        // 3. 이미지 업로드
        String beforeUrl = uploadImageIfPresent(beforeImage, folderPath);
        String afterUrl = uploadImageIfPresent(afterImage, folderPath);
        String mapUrl = uploadImageIfPresent(mapImage, folderPath);

        // 4. Post에 이미지 URL 업데이트
        savedPost.updateImages(beforeUrl, afterUrl, mapUrl);

        log.info("이미지 업로드 완료 - postId: {}", postId);

        return postId;
    }

    /**
     * 이미지 null 체크 및 업로드 헬퍼 메서드
     */
    private String uploadImageIfPresent(MultipartFile image, String folder) {
        if (image != null && !image.isEmpty()) {
            try {
                return gcsImageService.uploadImage(image, folder);
            } catch (Exception e) {
                log.error("SNS 이미지 업로드 실패: {}", e.getMessage());
                throw new RuntimeException("이미지 업로드에 실패했습니다.", e);
            }
        }
        return null;
    }

    public List<PostResponseDto> getMyPosts(String userId) {
        log.info("🔍 getMyPosts called for userId: {}", userId);
        List<Post> posts = postRepository.findByAccount_UserId(userId);
        log.info("🔍 Found {} posts for userId: {}", posts.size(), userId);
        
        // 각 포스트의 account 정보 로그
        for (Post post : posts) {
            log.info("  - Post ID: {}, Account: {}, Account.userId: {}", 
                post.getPostId(), 
                post.getAccount() != null ? "exists" : "null",
                post.getAccount() != null ? post.getAccount().getUserId() : "null");
        }
        
        return posts.stream()
                .map(PostResponseDto::new)
                .collect(Collectors.toList());
    }

    public List<MyCommentResponseDto> getMyComments(String userId) {
        return commentRepository.findByAccount_UserId(userId).stream()
                .map(MyCommentResponseDto::new)
                .collect(Collectors.toList());
    }
}