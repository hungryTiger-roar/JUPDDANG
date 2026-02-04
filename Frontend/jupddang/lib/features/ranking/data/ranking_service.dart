import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../services/auth_service.dart';
import 'package:jupddang/features/ranking/models/ranking_model.dart';

class RankingService {
  final ApiClient _apiClient;

  RankingService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();


  Future<RankingResponse> getTotalRanking() async {
    final userId = AuthService.userId ?? 'guest';
    // 로그에 토큰 있는지 확인용
    print('🔑 Token: ${AuthService.accessToken}');

    try {
      final response = await _apiClient.dio.get(
        '/ranking/total',
        queryParameters: {'userId': userId},
      );
      print('✅ [RankingService] Total Ranking Success: ${response.statusCode}');
      return RankingResponse.fromJson(response.data, userId);
    } catch (e) {
      print('❌ [RankingService] Total Ranking Error: $e');
      if (e is DioException) {
        print('   - Status: ${e.response?.statusCode}');
        print('   - Data: ${e.response?.data}');
      }
      return _getMockRanking('Total (FALLBACK)');
    }
  }

  Future<RankingResponse> getMonthlyRanking() async {
    final userId = AuthService.userId ?? 'guest';

    print('📡 [RankingService] Fetching Monthly Ranking...');

    try {
      final response = await _apiClient.dio.get(
        '/ranking/monthly',
        queryParameters: {'userId': userId},
      );
      print(
        '✅ [RankingService] Monthly Ranking Success: ${response.statusCode}',
      );
      return RankingResponse.fromJson(response.data, userId);
    } catch (e) {
      print('❌ [RankingService] Monthly Ranking Error: $e');
      if (e is DioException) {
        print('   - Status: ${e.response?.statusCode}');
        print('   - Data: ${e.response?.data}');
      }
      return _getMockRanking('Monthly (FALLBACK)');
    }
  }

  RankingResponse _getMockRanking(String type) {
    List<Ranker> topRankers = List.generate(
      3,
      (index) => Ranker(
        rank: index + 1,
        nickname: 'Top User ${index + 1}',
        score: 1000 - (index * 50),
        userId: 'top_user_$index',
      ),
    );

    List<Ranker> myWindow = List.generate(
        5,
        (index) => Ranker(
            rank: 40 + index,
            nickname: index == 2 ? 'Me' : 'Neighbor $index',
            score: 500 - (index * 10),
            userId: index == 2 ? 'my_id' : 'neighbor_$index',
        ),
    );

    return RankingResponse(
      topRankers: topRankers,
      myRankWindow: myWindow,
      myRanking: myWindow.firstWhere((r) => r.userId == 'my_id', orElse: () => myWindow[0]),
    );
  }
}
