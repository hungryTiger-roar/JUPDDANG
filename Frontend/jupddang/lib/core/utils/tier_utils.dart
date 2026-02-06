// lib/core/utils/tier_utils.dart

class TierUtils {
  static String getTierBadgePath(String? tier) {
    // 1. 데이터가 없으면 기본값(브론즈 5) 리턴
    if (tier == null || tier.isEmpty) {
      return 'assets/images/badges/tier/bronze/bronze_5.png';
    }

    // 2. 대문자 변환 (예: "BRONZE_5")
    String tierUpper = tier.toUpperCase();

    // 3. 챔피언, 레전드 예외 처리 (숫자 없음)
    if (tierUpper == 'CHAMPION') {
      return 'assets/images/badges/tier/champion/champion.png';
    }
    if (tierUpper == 'LEGEND') {
      return 'assets/images/badges/tier/legend/legend.png';
    }

    // 4. 경로 만들기
    // 백엔드: "BRONZE_5" -> 소문자변환: "bronze_5"
    // 폴더명: "bronze" (언더바 앞부분)
    // 파일명: "bronze_5.png"

    String fileName = tier.toLowerCase(); // bronze_5
    String folderName = fileName.split('_')[0]; // bronze

    // 5. 최종 경로 반환
    return 'assets/images/badges/tier/$folderName/$fileName.png';
  }
}