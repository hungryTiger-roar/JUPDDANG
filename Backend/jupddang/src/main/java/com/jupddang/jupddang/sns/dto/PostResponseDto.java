package com.jupddang.jupddang.sns.dto;

import com.jupddang.jupddang.sns.entity.Post;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
// 앱 화면에 뿌려줄 게시글 정보
public class PostResponseDto {
    private Long postId;
    private String nickname;
    private Long ploggingId;
    private String beforeImageUrl;
    private String afterImageUrl;
    private String mapImageUrl;
    private String content;
    private int like;
    private LocalDateTime createdAt;
    private List<CommentResponseDto> comments;

    public PostResponseDto(Post post) {
        this.postId = post.getPostId();
        this.nickname = post.getAccount().getNickname();
        this.ploggingId = post.getPloggingId();
        this.beforeImageUrl = post.getBeforeImageUrl();
        this.afterImageUrl = post.getAfterImageUrl();
        this.mapImageUrl = post.getMapImageUrl();
        this.content = post.getContent();
        this.like = post.getLikeCount();
        this.createdAt = post.getCreatedAt();

        this.comments = post.getComments().stream()
                .map(CommentResponseDto::new)
                .collect(Collectors.toList());
    }
}
