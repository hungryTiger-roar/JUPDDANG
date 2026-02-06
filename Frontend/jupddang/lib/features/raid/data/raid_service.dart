import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/network/api_client.dart';
import '../../../../services/location_h3_service.dart';
import 'package:jupddang/features/raid/models/raid_models.dart';
import '../../../../services/auth_service.dart';

class RaidService {
  final ApiClient _apiClient;
  
  RaidService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();


  /// 전체 보스 마커 위치 조회 (인증 불필요 - 공개 정보)
  Future<List<RaidBossModel>> getAllRaidBosses() async {
    print('📡 [RaidService] Fetching all raid bosses');
    try {
      // 토큰 없이 요청 (공개 API)
      final response = await _apiClient.dio.get('/raids');
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
      return await _getDummyBosses();
    }
  }

  /// 🧪 테스트용 더미 보스 데이터 (구미 지역 - Fallback 사용)
  Future<List<RaidBossModel>> _getDummyBosses() async {
    // 구미 중심: 36.109648, 128.417922
    final baseLat = 36.109648;
    final baseLon = 128.417922;
    final h3Service = LocationH3Service();

    // H3 서비스 초기화 확인 (보통 MapScreen에서 하지만 안전을 위해)
    await h3Service.init();

    String? getIndex(int idx) {
      // 각 보스를 약간씩 다른 위치에 배치 (약 500m ~ 1km 간격)
      // 0.005도 = 약 500m
      final lat = baseLat + (idx == 1 ? 0.005 : idx == 2 ? -0.005 : 0);
      final lon = baseLon + (idx == 3 ? 0.005 : idx == 0 ? -0.005 : 0);
      return h3Service.latLngToH3(LatLng(lat, lon));
    }

    return [
      RaidBossModel(
        id: 1,
        h3Index: getIndex(0) ?? '8930e466317ffff', // Fallback or Valid
        name: '구미역 쓰레기존',
        bossType: 0, // 쓰레기통
      ),
      RaidBossModel(
        id: 2,
        h3Index: getIndex(1) ?? '8930e46630bffff',
        name: '금오공대 먼지구역',
        bossType: 2, // 먼지구름
      ),
      RaidBossModel(
        id: 3,
        h3Index: getIndex(2) ?? '8930e466387ffff',
        name: '공단 쓰레기봉투',
        bossType: 1, // 쓰레기봉투
      ),
      RaidBossModel(
        id: 4,
        h3Index: getIndex(3) ?? '8930e466313ffff',
        name: '썩은 새싹 구역',
        bossType: 3, // 썩은 새싹
      ),
    ];
  }

  /// 특정 보스 상세 정보 조회 (누적 기여도 + 랭킹)
  Future<RaidDetailModel?> getRaidBossDetail(int bossId) async {
    final userId = AuthService.userId ?? '';
    print('📡 [RaidService] Fetching boss detail for bossId: $bossId');
    try {
      // 토큰 없이 요청 (공개 API)
      final response = await _apiClient.dio.get(
        '/raids/$bossId/detail',
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
    final bosses = [
      // 동기적 더미 데이터 반환 (상세 정보용)
      RaidBossModel(id: 1, h3Index: 'dummy', name: '구미역 쓰레기존', bossType: 0),
      RaidBossModel(id: 2, h3Index: 'dummy', name: '금오공대 먼지구역', bossType: 2),
      RaidBossModel(id: 3, h3Index: 'dummy', name: '공단 쓰레기봉투', bossType: 1),
      RaidBossModel(id: 4, h3Index: 'dummy', name: '썩은 새싹 구역', bossType: 3),
    ];
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
