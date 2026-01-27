package com.jupddang.jupddang.plogging.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Getter
@Table(name = "grids")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Grids {

    @Id
    @Column(name = "grid_id")
    private String id; // H3 Index

    // [수정] Long -> String 변경
    @Column(name = "user_id", nullable = false)
    private String userId;

    @Column(name = "party_id")
    private Long partyId;

    @Column(name = "occupied_at", nullable = false)
    private LocalDateTime occupiedAt;

    @Builder
    public Grids(String id, String userId, Long partyId, LocalDateTime occupiedAt) {
        this.id = id;
        this.userId = userId; // [수정] 타입 일치
        this.partyId = partyId;
        this.occupiedAt = occupiedAt;
    }

    /**
     * 점령 가능 여부 확인 (3시간 보호막)
     * @param attackerId 공격하는 유저 ID
     * @param now 현재 시간
     */
    public boolean isClaimable(String attackerId, LocalDateTime now) {
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
    // [수정] 점령 가능 여부 체크 시 파라미터도 String userId로
    public boolean isClaimable(String userId, LocalDateTime now) {
        // 내 땅이면 보호막 시간 갱신만, 남의 땅이면 3분 지났는지 체크 등 로직
        // 단순 예시:
        if (this.userId.equals(userId)) return true; 
        return now.isAfter(this.occupiedAt.plusMinutes(3));
    }

    // [수정] 소유자 변경 메서드 파라미터도 String userId로
    public void changeOwner(String newUserId, Long newPartyId, LocalDateTime now) {
        this.userId = newUserId;
        this.partyId = newPartyId;
        this.occupiedAt = now;
    }
}