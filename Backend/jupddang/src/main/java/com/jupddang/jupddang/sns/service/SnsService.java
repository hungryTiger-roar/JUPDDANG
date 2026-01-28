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
     * [수정됨] Plogging 완료 이벤트 처리
     * 이미 PloggingServiceImpl에서 업로드와 Post 생성을 마쳤으므로
     * 여기서는 중복 로직을 제거하고 로그만 남기거나, 알림 전송 로직만 남깁니다.
     */
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void handlePloggingCompleted(PloggingCompletedEvent event) {
        // 중복 로직(업로드, 저장) 삭제함
        log.info("PloggingCompletedEvent 수신 완료 (Post 생성은 앞단에서 처리됨) - ploggingId: {}", event.ploggingId());

        // 여기에 나중에 '알림 보내기' 같은 로직만 추가하시면 됩니다.
    }

    // ... 아래 나머지 메서드(조회, 좋아요, 댓글 등)는 그대로 유지 ...

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

        // 삭제는 여기서 하는게 맞습니다 (Post가 삭제될 때 이미지도 지워야 하니까)
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