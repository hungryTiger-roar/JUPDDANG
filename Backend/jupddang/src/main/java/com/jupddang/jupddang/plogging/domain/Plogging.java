

package com.jupddang.jupddang.plogging.domain;

import com.jupddang.jupddang.account.entity.Account; // Account 임포트 필수!
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Getter
@Table(name = "ploggings")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class Plogging {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "plogging_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private Account account;

    // [추가] 랭킹 산정용 점수 (이동 거리나 시간으로 계산된 결과값)
    @Column(nullable = false)
    private int score;

    // 이동 거리 (기존 유지)
    private Double distance;

    // 소요 시간 (기존 유지)
    private Integer times;

    // [추가] 월간 랭킹 집계용 날짜 필드
    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
}