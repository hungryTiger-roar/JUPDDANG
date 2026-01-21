package com.jupddang.jupddang.plogging.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Getter
@Table(name = "grids")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class) // 생성/수정 시간 자동화
public class Grids {

    @Id
    @Column(name = "grid_id")
    private String id;

    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime startedAt;

}
