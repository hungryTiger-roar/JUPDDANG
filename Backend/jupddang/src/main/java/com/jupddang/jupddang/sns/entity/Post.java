package com.jupddang.jupddang.sns.entity;

import com.jupddang.jupddang.account.entity.Account;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class) // 자동으로 날짜 기록
public class Post {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_id")
    private Long postId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "userId")  // Account의 userId(String)와 연결
    private Account account;

    // Plogging 참조 추가!
    @Column(name = "plogging_id")
    private Long ploggingId;

    // 이미지 3장으로 변경!
    @Column(length = 500)
    private String beforeImageUrl;

    @Column(length = 500)
    private String afterImageUrl;

    @Column(length = 500)
    private String mapImageUrl;

    @Column(columnDefinition = "TEXT")
    private String content;

    @Column(name = "like_cnt") // db 예약어인 경우 백틱으로 감싸야함
    @Builder.Default
    private int likeCount = 0;

    @CreatedDate
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // 게시글 하나에 달린 댓글들 (양방향 매핑)
    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("createdAt ASC") // 댓글 시간 순 정렬
    @Builder.Default
    private List<Comment> comments = new ArrayList<>();

    public void increaseLike(){
        this.likeCount++;
    }

    public void updateImages(String beforeUrl, String afterUrl, String mapUrl) {
        this.beforeImageUrl = beforeUrl;
        this.afterImageUrl = afterUrl;
        this.mapImageUrl = mapUrl;
    }

}
