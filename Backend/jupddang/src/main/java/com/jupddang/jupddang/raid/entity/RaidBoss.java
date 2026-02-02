package com.jupddang.jupddang.raid.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PRIVATE)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "raid_boss")
public class RaidBoss {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 보스(구역)의 위치 (H3 Index)
    @Column(nullable = false, unique = true)
    private String h3Index;

    // 보스 이름 (예: "강남역 9번 출구 쓰레기장")
    private String name;

    // 보스 타입 (0: 쓰레기통, 1: 쓰레기봉투, 2: 먼지구름, 3: 썩은 새싹)
    @Column(nullable = false)
    @Builder.Default
    private Integer bossType = 0;

}