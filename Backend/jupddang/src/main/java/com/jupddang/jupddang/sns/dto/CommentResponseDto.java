package com.jupddang.jupddang.sns.dto;

import com.jupddang.jupddang.sns.entity.Comment;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
// 게시글 조회할 때, 그 안에 달린 댓글들 같이 보여주기 위함
public class CommentResponseDto {
    private Long commentId;
    private String nickname; // 아이디 대신 닉네임
    private String content;
    private LocalDateTime createdAt;

    public CommentResponseDto(Comment comment) {
        this.commentId = comment.getCommentId();
        this.nickname = comment.getAccount().getName(); // 아이디 대신 닉네임
        this.content = comment.getContent();
        this.createdAt = comment.getCreatedAt();
    }
}
