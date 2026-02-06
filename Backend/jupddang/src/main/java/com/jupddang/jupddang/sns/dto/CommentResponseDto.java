package com.jupddang.jupddang.sns.dto;

import com.jupddang.jupddang.sns.entity.Comment;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
// 게시글 조회할 때, 그 안에 달린 댓글들 같이 보여주기 위함
public class CommentResponseDto {
    private Long commentId;
    private String userId; // userId 추가
    private String nickname; // 아이디 대신 닉네임
    private String tier; // 티어 추가
    private String profileImage; // 프로필 이미지 추가
    private String content;
    private LocalDateTime createdAt;

    public CommentResponseDto(Comment comment) {
        this.commentId = comment.getCommentId();
        this.userId = comment.getAccount().getUserId(); // userId 설정
        this.nickname = comment.getAccount().getNickname(); // 아이디 대신 닉네임
        this.tier = comment.getAccount().getTier(); // 티어 추가
        this.profileImage = comment.getAccount().getProfileImage(); // 프로필 이미지 설정
        this.content = comment.getContent();
        this.createdAt = comment.getCreatedAt();
    }


}
