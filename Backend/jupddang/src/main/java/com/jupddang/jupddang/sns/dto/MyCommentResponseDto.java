package com.jupddang.jupddang.sns.dto;

import com.jupddang.jupddang.sns.entity.Comment;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class MyCommentResponseDto {

    // 댓글 정보
    private Long commentId;
    private String content;
    private LocalDateTime createdAt;

    // 게시글 정보
    private Long postId;
    private String postAuthor;
    private String postTier; // 게시글 작성자 티어 추가
    private String postContent;
    private LocalDateTime postCreatedAt;

    public MyCommentResponseDto(Comment comment) {
        this.commentId = comment.getCommentId();
        this.content = comment.getContent();
        this.createdAt = comment.getCreatedAt();
        this.postId = comment.getPost().getPostId();
        this.postAuthor = comment.getPost().getAccount().getNickname();
        this.postTier = comment.getPost().getAccount().getTier(); // 게시글 작성자 티어 추가
        this.postContent = comment.getPost().getContent();
        this.postCreatedAt = comment.getPost().getCreatedAt();
    }

}
