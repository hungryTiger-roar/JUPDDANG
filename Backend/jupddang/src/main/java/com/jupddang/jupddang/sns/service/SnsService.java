package com.jupddang.jupddang.sns.service;

import com.jupddang.jupddang.common.infrastructure.storage.GcsImageService;
import com.jupddang.jupddang.plogging.domain.event.PloggingCompletedEvent;
import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.sns.dto.CommentRequestDto;
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

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class SnsService {
    private final PostRepository postRepository;
    private final CommentRepository commentRepository;
    private final GcsImageService gcsImageService;
    private final AccountRepository accountRepository;

    /**
     * Plogging 완료 이벤트 처리 - 피드 생성
     */
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void handlePloggingCompleted(PloggingCompletedEvent event) {
        log.info("PloggingCompletedEvent 수신 - ploggingId: {}", event.ploggingId());

        try {
            // 1. 이미지 3장 GCS 업로드
            String beforeUrl = gcsImageService.uploadImage(
                    event.beforeImage(), "before"
            );
            String afterUrl = gcsImageService.uploadImage(
                    event.afterImage(), "after"
            );
            String mapUrl = gcsImageService.uploadImage(
                    event.mapImage(), "map"
            );

            Account account = accountRepository.findByUserId(event.userId())
                    .orElseThrow(() -> new IllegalArgumentException("해당 유저가 없습니다."));

            // 2. Post(Feed) 생성
            Post post = Post.builder()
                    .account(account)
                    .ploggingId(event.ploggingId())
                    .beforeImageUrl(beforeUrl)
                    .afterImageUrl(afterUrl)
                    .mapImageUrl(mapUrl)
                    .content("플로깅 " + event.occupiedGridCnt() + "칸 정복! 🎉")
                    .build();

            postRepository.save(post);

            log.info("피드 생성 완료 - postId: {}", post.getPostId());

        } catch (Exception e) {
            log.error("피드 생성 실패 - ploggingId: {}", event.ploggingId(), e);
            throw new RuntimeException("피드 생성에 실패했습니다", e);
        }
    }

    // 전체 포스트 조회
    @Transactional(readOnly = true)
    public List<PostResponseDto> getAllPost() {
        return postRepository.findAllByOrderByCreatedAtDesc().stream()
                .map(PostResponseDto::new)
                .collect(Collectors.toList());
    }

    // 포스트 좋아요
    @Transactional
    public void like(Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException(postId + " 해당 게시글이 없습니다."));
        post.increaseLike();
    }

    // 포스트 삭제
    @Transactional
    public void deletePost(Long postId) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("게시글이 없습니다."));

        gcsImageService.deleteImage(post.getBeforeImageUrl());
        gcsImageService.deleteImage(post.getAfterImageUrl());
        gcsImageService.deleteImage(post.getMapImageUrl());

        postRepository.delete(post);
    }

    // 댓글 작성
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

    // 댓글 삭제
    @Transactional
    public void deleteComment(Long postId, Long commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("해당 댓글이 없습니다. id=" + commentId));

        if (!comment.getPost().getPostId().equals(postId)) {
            throw new IllegalArgumentException("해당 게시글의 댓글이 아닙니다.");
        }

        commentRepository.delete(comment);
    }
}
