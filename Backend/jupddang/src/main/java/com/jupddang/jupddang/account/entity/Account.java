package com.jupddang.jupddang.account.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Getter
@Table(name = "account")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Account {

    @Id
    @Column(nullable = false, length = 50, unique = true)
    private String userId;

    @Column(nullable = false)
    private String pw;

    @Column(nullable = false)
    private String nickname;

    @Column(name = "profile_image", nullable = false)
    private String profileImage;

    @Column(nullable = false)
    private String intro;

    @Column(nullable = false)
    private String region;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String color;

    @Column(nullable = false)
    private int score;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Builder
    public Account(String userId, String pw, String email, String nickname, String region, String color, int score) {
        this.userId = userId;
        this.pw = pw;
        this.email = email;
        this.nickname = nickname;
        this.region = region;
        this.color = color;
        this.score = score;
    }

    public void update(String pw, String nickname, String profileImage, String intro, String region, String email, String color) {
        if (pw != null) {
            this.pw = pw;
        }
        if (nickname != null) {
            this.nickname = nickname;
        }
        if (profileImage != null) {
            this.profileImage = profileImage;
        }
        if (intro != null) {
            this.intro = intro;
        }
        if (region != null) {
            this.region = region;
        }
        if (email != null) {
            this.email = email;
        }
        if (color != null) {
            this.color = color;
        }
    }

}
