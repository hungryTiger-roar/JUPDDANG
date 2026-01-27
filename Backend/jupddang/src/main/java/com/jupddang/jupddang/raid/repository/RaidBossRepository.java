package com.jupddang.jupddang.raid.repository;

import com.jupddang.jupddang.raid.entity.RaidBoss;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface RaidBossRepository extends JpaRepository<RaidBoss, Long> {
    // H3 인덱스로 보스 찾기 (유니크)
    Optional<RaidBoss> findByH3Index(String h3Index);
}