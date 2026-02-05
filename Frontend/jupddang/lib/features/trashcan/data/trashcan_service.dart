import '../../../../core/network/api_client.dart';
import 'package:jupddang/features/trashcan/models/trashcan_model.dart';

class TrashcanService {
  final ApiClient _apiClient;

  TrashcanService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// 영역 내 쓰레기통 조회
  /// GET /api/v1/trashcans
  Future<List<TrashcanModel>> getTrashcansInArea({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/api/v1/trashcans',
        queryParameters: {
          'minLatitude': minLat,
          'maxLatitude': maxLat,
          'minLongitude': minLng,
          'maxLongitude': maxLng,
        },
      );

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
      print('Creating trashcan with data: ${request.toJson()}');
      final response = await _apiClient.dio.post(
        '/api/v1/trashcans',
        data: request.toJson(),
      );

      return TrashcanDetailModel.fromJson(response.data);
    } catch (e, stackTrace) {
      print('Create Trashcan Error: $e');
      print('Request data: ${request.toJson()}');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// 쓰레기통 검증 (좋아요/인증)
  /// POST /api/v1/trashcans/{trashcanId}/verify
  Future<TrashcanDetailModel> verifyTrashcan(int trashcanId) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/trashcans/$trashcanId/verify',
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
        queryParams['status'] = status.name;
      }

      final response = await _apiClient.dio.get(
        '/api/v1/trashcans/my',
        queryParameters: queryParams,
      );

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
