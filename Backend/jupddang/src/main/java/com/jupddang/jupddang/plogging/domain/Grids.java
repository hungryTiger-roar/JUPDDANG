package com.jupddang.jupddang.plogging.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Getter
@Table(name = "grids")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class Grids {

    @Id
    @Column(name = "h3_index", length = 20)
    private String id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "party_id")
    private Long partyId;

    @Column(name = "occupied_at")
    private LocalDateTime occupiedAt;

    @Builder
    public Grids(String id, Long userId, Long partyId, LocalDateTime occupiedAt) {
        this.id = id;
        this.userId = userId;
        this.partyId = partyId;
        this.occupiedAt = occupiedAt;
    }

    // --- 비즈니스 로직 ---

    /**
     * 점령 가능 여부 확인 (3시간 보호막)
     * @param attackerId 공격하는 유저 ID
     * @param now 현재 시간
     */
    public boolean isClaimable(Long attackerId, LocalDateTime now) {
        // 1. 주인이 없는 땅이면 즉시 점령 가능
        if (this.userId == null) return true;

        // 2. 이미 내가 점령한 땅이면 점령 불가 (중복 점령 방지)
        if (this.userId.equals(attackerId)) return false;

        // 3. 보호막 체크: 점령 후 3시간이 지났는지 확인
        // (점령 시간 + 3시간)이 현재 시간보다 이전이어야 함
        return this.occupiedAt.plusHours(3).isBefore(now);
    }

    /**
     * 주인 변경 (땅 뺏기 성공)
     */
    public void changeOwner(Long newUserId, Long newPartyId, LocalDateTime now) {
        this.userId = newUserId;
        this.partyId = newPartyId;
        this.occupiedAt = now; // 점령 시간 갱신 (보호막 초기화)
    }
}