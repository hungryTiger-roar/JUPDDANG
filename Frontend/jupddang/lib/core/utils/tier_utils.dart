// lib/core/utils/tier_utils.dart

class TierUtils {
  static String getTierBadgePath(String? tier) {
    print('🔍 getTierBadgePath called with tier: "$tier"');

    // 1. 데이터가 없으면 기본값(브론즈 5) 리턴
    if (tier == null || tier.isEmpty) {
      print('⚠️ tier is null or empty, using default');
      return 'assets/images/badges/tier/bronze/bronze_5.png';
    }

    // 2. 공백을 언더스코어로 변환하고 대문자로 변환 (예: "Bronze 5" -> "BRONZE_5")
    String tierNormalized = tier.replaceAll(' ', '_').toUpperCase();
    print('🔄 Normalized: "$tier" -> "$tierNormalized"');

    // 3. 챔피언, 레전드 예외 처리 (숫자 없음)
    if (tierNormalized == 'CHAMPION') {
      final path = 'assets/images/badges/tier/champion/champion.png';
      print('✅ Path: $path');
      return path;
    }
    if (tierNormalized == 'LEGEND') {
      final path = 'assets/images/badges/tier/legend/legend.png';
      print('✅ Path: $path');
      return path;
    }

    // 4. 경로 만들기
    // "BRONZE_5" -> 소문자변환: "bronze_5"
    // 폴더명: "bronze" (언더바 앞부분)
    // 파일명: "bronze_5.png"

    String fileName = tierNormalized.toLowerCase(); // bronze_5
    String folderName = fileName.split('_')[0]; // bronze

    // 5. 최종 경로 반환
    final path = 'assets/images/badges/tier/$folderName/$fileName.png';
    print('✅ Path: $path');
    return path;
  }
}