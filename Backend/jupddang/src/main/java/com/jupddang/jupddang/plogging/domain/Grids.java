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
     * 
     * @param attackerId 공격하는 유저 ID
     * @param now        현재 시간
     */
    /**
     * 주인 변경 (땅 뺏기 성공)
     */
    // [수정] 점령 가능 여부 체크 시 파라미터도 String userId로
    public boolean isClaimable(String userId, LocalDateTime now) {
        // 내 땅이면 언제든 갱신(재점령) 가능 -> 방어 성공으로 시간 초기화
        if (this.userId.equals(userId))
            return true;

        // 남의 땅이면 점령 후 3시간이 지났는지 확인
        return now.isAfter(this.occupiedAt.plusHours(3));
    }

    // [수정] 소유자 변경 메서드 파라미터도 String userId로
    public void changeOwner(String newUserId, Long newPartyId, LocalDateTime now) {
        this.userId = newUserId;
        this.partyId = newPartyId;
        this.occupiedAt = now;
    }
}