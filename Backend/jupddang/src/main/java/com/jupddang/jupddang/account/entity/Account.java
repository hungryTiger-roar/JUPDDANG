package com.jupddang.jupddang.account.entity;

import com.jupddang.jupddang.common.enums.PloggingLevel;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Getter
@Table(name = "account")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Account implements UserDetails {

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

    @Column(name = "address", nullable = false)
    private String region;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String color;

    @Column(name = "total_score", nullable = false)
    private long totalScore;

    @Column(nullable = false)
    private String tier;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Builder
    public Account(String userId, String pw, String email, String nickname, String region, String color) {
        this.userId = userId;
        this.pw = pw;
        this.email = email;
        this.nickname = nickname;
        this.region = region;
        this.color = color;
        this.totalScore = 0L;
        this.tier = PloggingLevel.BRONZE_5.getLabel();
        this.profileImage = "https://storage.googleapis.com/jupddang-images/default/default-profile.png";
        this.intro = "안녕하세요!";

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

    /**
     * 점수 누적 및 티어 갱신 메서드
     * @param point 획득한 점수
     */
    public void addScore(int point) {
        this.totalScore += point;

        // 점수에 따라 티어도 같이 다시 계산해서 넣기
        this.tier = PloggingLevel.findByScore(this.totalScore).getLabel();
    }


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_USER"));
    }

    @Override
    public String getPassword() {
        return this.pw;
    }

    @Override
    public String getUsername() {
        return this.userId;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
