package com.jupddang.jupddang.plogging.domain;


import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Getter
@Table(name = "ploggings")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class) // 생성/수정 시간 자동화
public class Plogging {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "plogging_id")
    private Long id;

    @Column(nullable = true)
    private Long userId;

    // 이동 거리
    private Double distance;

    // 소요 시간
    private Integer times;
}