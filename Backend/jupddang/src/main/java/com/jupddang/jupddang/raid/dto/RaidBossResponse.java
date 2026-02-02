package com.jupddang.jupddang.raid.dto;

import com.jupddang.jupddang.raid.entity.RaidBoss;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class RaidBossResponse {
    private Long id;
    private String h3Index;
    private String name;
    private Integer bossType; // 0: trash can, 1: trash bag, 2: dust cloud, 3: rotten sprout

    // 지도는 정말 가볍게 "여기 구역이 있다"만 알려줍니다.
    public static RaidBossResponse from(RaidBoss boss) {
        return RaidBossResponse.builder()
                .id(boss.getId())
                .h3Index(boss.getH3Index())
                .name(boss.getName())
                .bossType(boss.getBossType())
                .build();
    }
}