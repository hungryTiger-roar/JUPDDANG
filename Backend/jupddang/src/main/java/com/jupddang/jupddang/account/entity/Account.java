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
@Builder
public class Account {

    @Id
    @Column(nullable = false, length = 50, unique = true)
    private String userId;

    @Column(nullable = false)
    private String pw;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String nickname;

    @Column(nullable = false)
    private String address;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    public Account(String userId, String pw, String email, String name, String address) {
        this.userId = userId;
        this.pw = pw;
        this.email = email;
        this.name = name;
        this.address = address;
    }

    public void update(String pw, String name, String email, String address) {
        if (pw != null) {
            this.pw = pw;
        }
        if (name != null) {
            this.name = name;
        }
        if (email != null) {
            this.email = email;
        }
        if (address != null) {
            this.address = address;
        }
    }

}
