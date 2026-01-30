import 'package:dio/dio.dart';
import 'auth_service.dart';
import '../models/raid_models.dart';

class RaidService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AuthService.apiBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  /// 전체 보스 마커 위치 조회 (인증 불필요 - 공개 정보)
  Future<List<RaidBossModel>> getAllRaidBosses() async {
    final url = '${AuthService.apiBase}/api/raids';
    print('📡 [RaidService] Fetching all raid bosses: $url');
    try {
      // 토큰 없이 요청 (공개 API)
      final response = await _dio.get('/api/raids');
      print('✅ [RaidService] Raid bosses loaded: ${response.statusCode}');
      
      if (response.data is List) {
        return (response.data as List)
            .map((json) => RaidBossModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('❌ [RaidService] Failed to load raid bosses: $e');
      if (e is DioException) {
        print('   - Status: ${e.response?.statusCode}');
        print('   - Data: ${e.response?.data}');
      }
      
      // 🧪 에뮬레이터 테스트용 더미 데이터 반환
      print('🧪 [RaidService] Using dummy data for testing');
      return _getDummyBosses();
    }
  }

  /// 🧪 테스트용 더미 보스 데이터 (구미 지역 - Fallback 사용)
  List<RaidBossModel> _getDummyBosses() {
    // 구미 중심: 36.109648, 128.417922
    // H3 인덱스를 무효화하여 Fallback 위치 사용 (구미 좌표)
    
    return [
      RaidBossModel(
        id: 1,
        h3Index: 'invalid1', // Fallback: 구미 중심
        name: '구미역 쓰레기존',
        bossType: 0, // 쓰레기통
      ),
      RaidBossModel(
        id: 2,
        h3Index: 'invalid2', // Fallback: 구미 중심 + 100m
        name: '금오공대 먼지구역',
        bossType: 2, // 먼지구름
      ),
      RaidBossModel(
        id: 3,
        h3Index: 'invalid3', // Fallback: 구미 중심 + 200m
        name: '공단 쓰레기봉투',
        bossType: 1, // 쓰레기봉투
      ),
      RaidBossModel(
        id: 4,
        h3Index: 'invalid4', // Fallback: 구미 중심 + 300m
        name: '썩은 새싹 구역',
        bossType: 3, // 썩은 새싹
      ),
    ];
  }

  /// 특정 보스 상세 정보 조회 (누적 기여도 + 랭킹)
  Future<RaidDetailModel?> getRaidBossDetail(int bossId) async {
    final userId = AuthService.userId ?? '';
    final url =
        '${AuthService.apiBase}/api/raids/$bossId/detail?userId=$userId';
    print('📡 [RaidService] Fetching boss detail: $url');
    try {
      // 토큰 없이 요청 (공개 API)
      final response = await _dio.get(
        '/api/raids/$bossId/detail',
        queryParameters: {'userId': userId},
      );
      print('✅ [RaidService] Boss detail loaded: ${response.statusCode}');
      return RaidDetailModel.fromJson(response.data);
    } catch (e) {
      print('❌ [RaidService] Failed to load boss detail: $e');
      if (e is DioException) {
        print('   - Status: ${e.response?.statusCode}');
        print('   - Data: ${e.response?.data}');
      }
      
      // 🧪 에뮬레이터 테스트용 더미 데이터 반환
      print('🧪 [RaidService] Using dummy detail data for testing');
      return _getDummyBossDetail(bossId);
    }
  }

  /// 🧪 테스트용 더미 보스 상세 데이터
  RaidDetailModel _getDummyBossDetail(int bossId) {
    final bosses = _getDummyBosses();
    final boss = bosses.firstWhere(
      (b) => b.id == bossId,
      orElse: () => bosses.first,
    );

    return RaidDetailModel(
      bossId: boss.id,
      bossName: boss.name,
      totalAccumulatedScore: 12500,
      topRankers: [
        RaidRankInfo(rank: 1, nickname: '플로깅왕', score: 3500, userId: 'user1'),
        RaidRankInfo(rank: 2, nickname: '환경지킴이', score: 2800, userId: 'user2'),
        RaidRankInfo(rank: 3, nickname: '깨끗한세상', score: 2100, userId: 'user3'),
        RaidRankInfo(rank: 4, nickname: '쓰레기헌터', score: 1900, userId: 'user4'),
        RaidRankInfo(rank: 5, nickname: '그린히어로', score: 1200, userId: 'user5'),
      ],
      myRanking: RaidRankInfo(rank: 3, nickname: '나', score: 2100, userId: 'guest'),
      nearbyRankers: [
        RaidRankInfo(rank: 1, nickname: '플로깅왕', score: 3500, userId: 'user1'),
        RaidRankInfo(rank: 2, nickname: '환경지킴이', score: 2800, userId: 'user2'),
        RaidRankInfo(rank: 3, nickname: '나', score: 2100, userId: 'guest'),
        RaidRankInfo(rank: 4, nickname: '쓰레기헌터', score: 1900, userId: 'user4'),
        RaidRankInfo(rank: 5, nickname: '그린히어로', score: 1200, userId: 'user5'),
      ],
    );
  }
}
