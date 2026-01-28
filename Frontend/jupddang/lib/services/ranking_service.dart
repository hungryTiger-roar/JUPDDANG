import 'package:dio/dio.dart';
import 'auth_service.dart';
import '../models/ranking_model.dart';

class RankingService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AuthService.apiBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  Future<RankingResponse> getTotalRanking() async {
    final url = '${AuthService.apiBase}/api/ranking/total';
    print('📡 [RankingService] Fetching Total Ranking: $url');
    try {
      final response = await _dio.get('/api/ranking/total');
      print('✅ [RankingService] Total Ranking Success: ${response.statusCode}');
      return RankingResponse.fromJson(response.data);
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
    final url = '${AuthService.apiBase}/api/ranking/monthly';
    print('📡 [RankingService] Fetching Monthly Ranking: $url');
    try {
      final response = await _dio.get('/api/ranking/monthly');
      print(
        '✅ [RankingService] Monthly Ranking Success: ${response.statusCode}',
      );
      return RankingResponse.fromJson(response.data);
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
      10,
      (index) => Ranker(
        rank: index + 1,
        nickname: 'User ${index + 1}',
        score: 1000 - (index * 50),
        userId: 'user_$index',
      ),
    );

    return RankingResponse(
      topRankers: topRankers,
      myRanking: Ranker(
        rank: 42,
        nickname: 'MyNickname',
        score: 120,
        userId: 'my_id',
      ),
    );
  }
}
