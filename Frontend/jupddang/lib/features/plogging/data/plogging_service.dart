import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jupddang/features/plogging/models/plogging_models.dart';

class PloggingService {
  final ApiClient _apiClient;

  PloggingService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  // 플로깅 종료 및 결과 저장
  Future<dynamic> endPlogging({
    required PloggingEndRequest requestData,
    required String beforeImagePath,
    required String afterImagePath,
    required String mapImagePath,
  }) async {
    try {
      final dataJson = jsonEncode(requestData.toJson());
      final formData = FormData.fromMap({
        'data': MultipartFile.fromString(
          dataJson,
          contentType: MediaType('application', 'json'),
        ),
        'beforeImage': await MultipartFile.fromFile(beforeImagePath),
        'afterImage': await MultipartFile.fromFile(afterImagePath),
        'mapImage': await MultipartFile.fromFile(mapImagePath),
      });
      // [Header Note] userId 헤더가 필요한 경우 Interceptor나 여기서 추가.
      // 현재 ApiClient는 Authorization만 처리하므로, 필요 시 options 파라미터 사용.

      await _apiClient.dio.post('/v1/plogging/end', data: formData);
    } catch (e) {
      print('End Plogging Error: $e');
      rethrow;
    }
  }

  // 플로깅 임시 저장
  Future<dynamic> savePloggingTemp({
    required TempPloggingRequest requestData,
    String? beforeImagePath,
    String? afterImagePath,
    String? mapImagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'data': MultipartFile.fromString(
          jsonEncode(requestData.toJson()),
          contentType: MediaType('application', 'json'),
        ),
        if (beforeImagePath != null)
          'beforeImage': await MultipartFile.fromFile(beforeImagePath),
        if (afterImagePath != null)
          'afterImage': await MultipartFile.fromFile(afterImagePath),
        if (mapImagePath != null)
          'mapImage': await MultipartFile.fromFile(mapImagePath),
      });

      final response = await _apiClient.dio.post(
        '/v1/plogging/temp',
        data: formData,
      );
      return response.data;
    } catch (e) {
      print('Save Plogging Temp Error: $e');
      rethrow;
    }
  }

  // [WebSocket] 관련 메서드는 추후 여기에 추가하거나 별도 SocketService로 분리
}
