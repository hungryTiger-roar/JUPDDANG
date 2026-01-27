package com.jupddang.jupddang.raid.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "raid_boss")
public class RaidBoss {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 보스(구역)의 위치 (H3 Index)
    @Column(nullable = false, unique = true)
    private String h3Index;

    // 보스 이름 (예: "강남역 9번 출구 쓰레기장")
    private String name;

}