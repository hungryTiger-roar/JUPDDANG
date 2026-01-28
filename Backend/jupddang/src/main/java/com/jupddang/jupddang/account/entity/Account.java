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

    @Column(name = "profile_image", nullable = true)
    private String profileImage;

    @Column(nullable = true)
    private String intro;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = true)
    private String color;

    @Column(name = "total_score", nullable = false)
    private Long totalScore;

    @Column(nullable = false)
    private String tier;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    // [빌더 적용된 생성자]
    // Service에서 .color()를 호출하면 이 생성자의 color 파라미터로 들어옵니다.
    @Builder
    public Account(String userId, String pw, String email, String nickname, String color) {
        this.userId = userId;
        this.pw = pw;
        this.email = email;
        this.nickname = nickname;

        // [중요] Service에서 null을 보내더라도 여기서 기본값을 처리합니다.
        this.color = (color != null && !color.isBlank()) ? color : "#111111";

        this.totalScore = 0L;
        this.tier = PloggingLevel.BRONZE_5.getLabel();
        this.profileImage = "https://storage.googleapis.com/jupddang-images/default/default-profile.png";
        this.intro = "안녕하세요!";
    }

    // [수정 메서드] region 삭제됨
    public void update(String pw, String nickname, String profileImage, String intro, String email, String color) {
        if (pw != null) this.pw = pw;
        if (nickname != null) this.nickname = nickname;
        if (profileImage != null) this.profileImage = profileImage;
        if (intro != null) this.intro = intro;
        if (email != null) this.email = email;
        if (color != null) this.color = color;
    }

    public void addScore(int point) {
        this.totalScore += point;
        this.tier = PloggingLevel.findByScore(this.totalScore).getLabel();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_USER"));
    }

    @Override
    public String getPassword() { return this.pw; }

    @Override
    public String getUsername() { return this.userId; }

    @Override
    public boolean isAccountNonExpired() { return true; }

    @Override
    public boolean isAccountNonLocked() { return true; }

    @Override
    public boolean isCredentialsNonExpired() { return true; }

    @Override
    public boolean isEnabled() { return true; }
}