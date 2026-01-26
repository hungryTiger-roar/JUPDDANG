package com.jupddang.jupddang.common.enums;

import lombok.Getter;

import java.util.Arrays;

@Getter
public enum PloggingLevel {
    // 이미지 링크 임의 설정해둠!!!
    // === 브론즈 (Bronze) : 1000점 단위 ===
    BRONZE_5(0, 999, "Bronze 5", "/images/badges/bronze_5.png"),
    BRONZE_4(1000, 1999, "Bronze 4", "/images/badges/bronze_4.png"),
    BRONZE_3(2000, 2999, "Bronze 3", "/images/badges/bronze_3.png"),
    BRONZE_2(3000, 3999, "Bronze 2", "/images/badges/bronze_2.png"),
    BRONZE_1(4000, 4999, "Bronze 1", "/images/badges/bronze_1.png"),

    // === 실버 (Silver) : 1000점 단위 ===
    SILVER_5(5000, 5999, "Silver 5", "/images/badges/silver_5.png"),
    SILVER_4(6000, 6999, "Silver 4", "/images/badges/silver_4.png"),
    SILVER_3(7000, 7999, "Silver 3", "/images/badges/silver_3.png"),
    SILVER_2(8000, 8999, "Silver 2", "/images/badges/silver_2.png"),
    SILVER_1(9000, 9999, "Silver 1", "/images/badges/silver_1.png"),

    // === 골드 (Gold) : 2000점 단위 ===
    GOLD_5(10000, 11999, "Gold 5", "/images/badges/gold_5.png"),
    GOLD_4(12000, 13999, "Gold 4", "/images/badges/gold_4.png"),
    GOLD_3(14000, 15999, "Gold 3", "/images/badges/gold_3.png"),
    GOLD_2(16000, 17999, "Gold 2", "/images/badges/gold_2.png"),
    GOLD_1(18000, 19999, "Gold 1", "/images/badges/gold_1.png"),

    // === 플래티넘 (Platinum) : 2000점 단위 ===
    PLATINUM_5(20000, 21999, "Platinum 5", "/images/badges/platinum_5.png"),
    PLATINUM_4(22000, 23999, "Platinum 4", "/images/badges/platinum_4.png"),
    PLATINUM_3(24000, 25999, "Platinum 3", "/images/badges/platinum_3.png"),
    PLATINUM_2(26000, 27999, "Platinum 2", "/images/badges/platinum_2.png"),
    PLATINUM_1(28000, 29999, "Platinum 1", "/images/badges/platinum_1.png"),

    // === 다이아몬드 (Diamond) : 2000점 단위 ===
    DIAMOND_5(30000, 31999, "Diamond 5", "/images/badges/diamond_5.png"),
    DIAMOND_4(32000, 33999, "Diamond 4", "/images/badges/diamond_4.png"),
    DIAMOND_3(34000, 35999, "Diamond 3", "/images/badges/diamond_3.png"),
    DIAMOND_2(36000, 37999, "Diamond 2", "/images/badges/diamond_2.png"),
    DIAMOND_1(38000, 39999, "Diamond 1", "/images/badges/diamond_1.png"),

    // === 엘리트 (Elite) : 3000점 단위 ===
    ELITE_5(40000, 42999, "Elite 5", "/images/badges/elite_5.png"),
    ELITE_4(43000, 45999, "Elite 4", "/images/badges/elite_4.png"),
    ELITE_3(46000, 48999, "Elite 3", "/images/badges/elite_3.png"),
    ELITE_2(49000, 51999, "Elite 2", "/images/badges/elite_2.png"),
    ELITE_1(52000, 54999, "Elite 1", "/images/badges/elite_1.png"),

    // === 마스터 (Master) : 4000점 단위 ===
    MASTER_5(55000, 58999, "Master 5", "/images/badges/master_5.png"),
    MASTER_4(59000, 62999, "Master 4", "/images/badges/master_4.png"),
    MASTER_3(63000, 66999, "Master 3", "/images/badges/master_3.png"),
    MASTER_2(67000, 70999, "Master 2", "/images/badges/master_2.png"),
    MASTER_1(71000, 74999, "Master 1", "/images/badges/master_1.png"),

    // === 그랜드마스터 (Grandmaster) : 5000점 단위 ===
    GRANDMASTER_5(75000, 79999, "Grand Master 5", "/images/badges/grandmaster_5.png"),
    GRANDMASTER_4(80000, 84999, "Grand Master 4", "/images/badges/grandmaster_4.png"),
    GRANDMASTER_3(85000, 89999, "Grand Master 3", "/images/badges/grandmaster_3.png"),
    GRANDMASTER_2(90000, 94999, "Grand Master 2", "/images/badges/grandmaster_2.png"),
    GRANDMASTER_1(95000, 99999, "Grand Master 1", "/images/badges/grandmaster_1.png"),

    // === 챔피언 (Champion) : 10만점 이상 (단계 없음) ===
    CHAMPION(100000, Integer.MAX_VALUE, "Champion", "/images/badges/champion.png"),

    // === 전설 (Legend) : 점수 무관, 상위 10명 ===
    LEGEND(0, 0, "전설", "/images/badges/legend.png");

    private final int minScore;
    private final int maxScore;
    private final String label;
    private final String badgeImage;

    PloggingLevel(int minScore, int maxScore, String label, String badgeImage) {
        this.minScore = minScore;
        this.maxScore = maxScore;
        this.label = label;
        this.badgeImage = badgeImage;
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