package com.jupddang.jupddang.common.enums;

import lombok.Getter;

import java.util.Arrays;

@Getter
public enum PloggingLevel {
    // === 브론즈 (Bronze) : 1000점 단위 ===
    BRONZE_5(0, 999, "Bronze 5"),
    BRONZE_4(1000, 1999, "Bronze 4"),
    BRONZE_3(2000, 2999, "Bronze 3"),
    BRONZE_2(3000, 3999, "Bronze 2"),
    BRONZE_1(4000, 4999, "Bronze 1"),

    // === 실버 (Silver) : 1000점 단위 ===
    SILVER_5(5000, 5999, "Silver 5"),
    SILVER_4(6000, 6999, "Silver 4"),
    SILVER_3(7000, 7999, "Silver 3"),
    SILVER_2(8000, 8999, "Silver 2"),
    SILVER_1(9000, 9999, "Silver 1"),

    // === 골드 (Gold) : 2000점 단위 ===
    GOLD_5(10000, 11999, "Gold 5"),
    GOLD_4(12000, 13999, "Gold 4"),
    GOLD_3(14000, 15999, "Gold 3"),
    GOLD_2(16000, 17999, "Gold 2"),
    GOLD_1(18000, 19999, "Gold 1"),

    // === 플래티넘 (Platinum) : 2000점 단위 ===
    PLATINUM_5(20000, 21999, "Platinum 5"),
    PLATINUM_4(22000, 23999, "Platinum 4"),
    PLATINUM_3(24000, 25999, "Platinum 3"),
    PLATINUM_2(26000, 27999, "Platinum 2"),
    PLATINUM_1(28000, 29999, "Platinum 1"),

    // === 다이아몬드 (Diamond) : 2000점 단위 ===
    DIAMOND_5(30000, 31999, "Diamond 5"),
    DIAMOND_4(32000, 33999, "Diamond 4"),
    DIAMOND_3(34000, 35999, "Diamond 3"),
    DIAMOND_2(36000, 37999, "Diamond 2"),
    DIAMOND_1(38000, 39999, "Diamond 1"),

    // === 엘리트 (Elite) : 3000점 단위 ===
    ELITE_5(40000, 42999, "Elite 5"),
    ELITE_4(43000, 45999, "Elite 4"),
    ELITE_3(46000, 48999, "Elite 3"),
    ELITE_2(49000, 51999, "Elite 2"),
    ELITE_1(52000, 54999, "Elite 1"),

    // === 마스터 (Master) : 4000점 단위 ===
    MASTER_5(55000, 58999, "Master 5"),
    MASTER_4(59000, 62999, "Master 4"),
    MASTER_3(63000, 66999, "Master 3"),
    MASTER_2(67000, 70999, "Master 2"),
    MASTER_1(71000, 74999, "Master 1"),

    // === 그랜드마스터 (Grandmaster) : 5000점 단위 ===
    GRANDMASTER_5(75000, 79999, "Grand Master 5"),
    GRANDMASTER_4(80000, 84999, "Grand Master 4"),
    GRANDMASTER_3(85000, 89999, "Grand Master 3"),
    GRANDMASTER_2(90000, 94999, "Grand Master 2"),
    GRANDMASTER_1(95000, 99999, "Grand Master 1"),

    // === 챔피언 (Champion) : 10만점 이상 (단계 없음) ===
    CHAMPION(100000, Integer.MAX_VALUE, "Champion"),

    // === 전설 (Legend) : 점수 무관, 누적 랭킹 1~3등 ===
    LEGEND(0, 0, "Legend");

    private final int minScore;
    private final int maxScore;
    private final String label;

    PloggingLevel(int minScore, int maxScore, String label) {
        this.minScore = minScore;
        this.maxScore = maxScore;
        this.label = label;
    }

    // '전설(LEGEND)' 등급은 점수 구간이 아닌 '순위'로 결정
    //  전설 등급 판별 로직은 Service 계층에서 별도로 처리해야 함!
    public static PloggingLevel findByScore(long score) {
        return Arrays.stream(PloggingLevel.values())
                .filter(level -> level != LEGEND)
                .filter(level -> score >= level.minScore && score <= level.maxScore)
                .findFirst()
                .orElse(BRONZE_5);
    }
}