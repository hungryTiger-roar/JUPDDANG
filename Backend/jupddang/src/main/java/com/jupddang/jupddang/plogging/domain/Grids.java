package com.jupddang.jupddang.plogging.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Getter
@Table(name = "grids")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class Grids {

    // 1. H3 인덱스 자체가 고유 ID가 됩니다. (PK)
    // 예: "8928308280fffff"
    @Id
    @Column(name = "h3_index", length = 20)
    private String id;

    // 2. 누가 먹었는지
    @Column(name = "user_id", nullable = false)
    private Long userId;

    // 3. 어떤 파티가 먹었는지 (선택)
    // 개인전이면 null, 파티전이면 값 있음
    @Column(name = "party_id")
    private Long partyId;

    // 4. 언제 점령했는지
    // 기존 데이터가 업데이트될 수 있으므로
    // 혹은 최초 점령 시간은 CreatedDate, 뺏은 시간은 LastModifiedDate로 관리
    @LastModifiedDate
    @Column(name = "occupied_at")
    private LocalDateTime occupiedAt;

    // --- 생성자 (Builder) ---
    @Builder
    public Grids(String id, Long userId, Long partyId) {
        this.id = id;
        this.userId = userId;
        this.partyId = partyId;
    }

    // --- 비즈니스 로직 (땅 뺏기용) ---
    // 이미 있는 땅을 다른 사람이 밟았을 때 주인 변경
    public void changeOwner(Long newUserId, Long newPartyId) {
        this.userId = newUserId;
        this.partyId = newPartyId;
        // AuditingEntityListener 덕분에 시간은 자동 갱신되지만,
        // 명시적으로 하려면 this.occupiedAt = LocalDateTime.now(); 추가
    }
}