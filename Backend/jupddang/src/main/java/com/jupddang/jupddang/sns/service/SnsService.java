package com.jupddang.jupddang.sns.service;

import com.jupddang.jupddang.account.entity.Account;
import com.jupddang.jupddang.account.repository.AccountRepository;
import com.jupddang.jupddang.sns.dto.CommentRequestDto;
import com.jupddang.jupddang.sns.dto.PostResponseDto;
import com.jupddang.jupddang.sns.entity.Comment;
import com.jupddang.jupddang.sns.entity.Post;
import com.jupddang.jupddang.sns.repository.CommentRepository;
import com.jupddang.jupddang.sns.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SnsService {
    private final PostRepository postRepository;
    private final CommentRepository commentRepository;
    private final AccountRepository accountRepository;

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
                .orElseThrow(() -> new IllegalArgumentException(postId + "해당 게시글이 없습니다."));
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
                .account(account) // userId 대신 account 객체 저장
                .content(requestDto.getContent()) // DTO에서 받은 내용
                .build();

        return commentRepository.save(comment).getCommentId();
    }

    // 댓글 삭제
    @Transactional
    public void deleteComment(Long postId, Long commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("해당 댓글이 없습니다. id=" + commentId));

        // (선택) 진짜 이 게시글의 댓글이 맞는지 확인하는 안전장치
        if (!comment.getPost().getPostId().equals(postId)) {
            throw new IllegalArgumentException("해당 게시글의 댓글이 아닙니다.");
        }

        commentRepository.delete(comment);
    }
}