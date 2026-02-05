import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/network/api_client.dart';
import '../models/quest_models.dart';

class QuestService {
  final ApiClient _apiClient;

  QuestService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 로컬 GPS 거리 검증 (Haversine 공식)
  double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // 지구 반지름 (미터)

    double lat1Rad = point1.latitude * pi / 180;
    double lat2Rad = point2.latitude * pi / 180;
    double deltaLat = (point2.latitude - point1.latitude) * pi / 180;
    double deltaLon = (point2.longitude - point1.longitude) * pi / 180;

    double a =
        sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // 미터 단위
  }

  /// 로컬 검증 (거리만 확인)
  QuestValidationResponse validateLocally({
    required LatLng beforeLocation,
    required LatLng afterLocation,
  }) {
    const double maxDistanceMeters = 10.0;

    double distance = calculateDistance(beforeLocation, afterLocation);
    bool isValid = distance <= maxDistanceMeters;

    return QuestValidationResponse(
      isValid: isValid,
      beforeTrashCount: 0, // 로컬에서는 알 수 없음
      afterTrashCount: 0, // 로컬에서는 알 수 없음
      distanceMeters: distance,
      message: isValid
          ? '거리 검증 성공 (${distance.toStringAsFixed(1)}m)'
          : '사진 촬영 위치가 너무 멀리 떨어져 있습니다 (${distance.toStringAsFixed(1)}m)',
    );
  }

  /// AI 서버를 통한 전체 검증 (향후 구현)
  Future<QuestValidationResponse> validateQuest({
    required String beforeImagePath,
    required String afterImagePath,
    required LatLng beforeLocation,
    required LatLng afterLocation,
  }) async {
    try {
      final formData = FormData.fromMap({
        'beforeImage': await MultipartFile.fromFile(beforeImagePath),
        'afterImage': await MultipartFile.fromFile(afterImagePath),
        'beforeLocation': jsonEncode({
          'lat': beforeLocation.latitude,
          'lon': beforeLocation.longitude,
        }),
        'afterLocation': jsonEncode({
          'lat': afterLocation.latitude,
          'lon': afterLocation.longitude,
        }),
      });

      final response = await _apiClient.dio.post(
        '/v1/quest/validate',
        data: formData,
      );

      return QuestValidationResponse.fromJson(response.data);
    } catch (e) {
      print('Quest Validation Error: $e');
      // 서버 오류 시 로컬 검증으로 fallback
      return validateLocally(
        beforeLocation: beforeLocation,
        afterLocation: afterLocation,
      );
    }
  }
}
