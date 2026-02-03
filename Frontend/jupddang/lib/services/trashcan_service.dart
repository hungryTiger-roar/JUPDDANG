import 'package:dio/dio.dart';
import 'auth_service.dart';
import '../models/trashcan_model.dart';

class TrashcanService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AuthService.apiBase,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  Map<String, String> _authHeaders() {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) {
      return {};
    }
    return {'Authorization': 'Bearer $token'};
  }

  /// 영역 내 쓰레기통 조회
  /// GET /api/v1/trashcans
  Future<List<TrashcanModel>> getTrashcansInArea({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    try {
      final response = await _dio.get(
        '/v1/trashcans',
        queryParameters: {
          'minLatitude': minLat,
          'maxLatitude': maxLat,
          'minLongitude': minLng,
          'maxLongitude': maxLng,
        },
        options: Options(headers: _authHeaders()),
      );

      // Response: { trashcans: [ ... ] }
      final data = response.data;
      if (data is Map && data['trashcans'] is List) {
        return (data['trashcans'] as List)
            .map((e) => TrashcanModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print('Get Trashcans Error: $e');
      rethrow;
    }
  }

  /// 쓰레기통 위치 제보/추가
  /// POST /api/v1/trashcans
  Future<TrashcanDetailModel> createTrashcan(
    TrashcanCreateRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/v1/trashcans',
        data: request.toJson(),
        options: Options(headers: _authHeaders()),
      );

      return TrashcanDetailModel.fromJson(response.data);
    } catch (e) {
      print('Create Trashcan Error: $e');
      rethrow;
    }
  }

  /// 쓰레기통 검증 (좋아요/인증)
  /// POST /api/v1/trashcans/{trashcanId}/verify
  Future<TrashcanDetailModel> verifyTrashcan(int trashcanId) async {
    try {
      final response = await _dio.post(
        '/v1/trashcans/$trashcanId/verify',
        options: Options(headers: _authHeaders()),
      );

      return TrashcanDetailModel.fromJson(response.data);
    } catch (e) {
      print('Verify Trashcan Error: $e');
      rethrow;
    }
  }

  /// 내가 제안한 쓰레기통 목록 조회
  /// GET /api/v1/trashcans/my
  Future<List<TrashcanModel>> getMyTrashcans({TrashcanStatus? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) {
        queryParams['status'] = status.name; // OFFICIAL, PENDING, VERIFIED
      }

      final response = await _dio.get(
        '/v1/trashcans/my',
        queryParameters: queryParams,
        options: Options(headers: _authHeaders()),
      );

      // Response: { trashcans: [ ... ] }
      final data = response.data;
      if (data is Map && data['trashcans'] is List) {
        return (data['trashcans'] as List)
            .map((e) => TrashcanModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print('Get My Trashcans Error: $e');
      rethrow;
    }
  }
}
