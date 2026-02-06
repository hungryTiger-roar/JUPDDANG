package com.jupddang.jupddang.raid.dto;

import lombok.Builder;
import lombok.Getter;
import java.util.List;

@Getter
@Builder
public class RaidGroupInfoResponse {
    private Long bossId;
    private String bossName;

    private long totalAccumulatedScore;

    // 상위 기여 유저 목록 (Top 10)
    private List<RankInfo> topRankers;

    // 본인 랭킹 정보 (본인이 참여하지 않았으면 null)
    private RankInfo myRanking;

    // 본인 포함 위아래 랭커 목록 (본인 ± 2명, 총 5명)
    private List<RankInfo> nearbyRankers;

    @Getter
    @Builder
    public static class RankInfo {
        private int rank;
        private String nickname;
        private String tier;
        private long score;
        private String userId; // 본인 여부 확인용
    }
}