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

    // 상위 기여 유저 목록
    private List<RankInfo> topRankers;

    @Getter
    @Builder
    public static class RankInfo {
        private int rank;
        private String nickname;
        private long score;
    }
}