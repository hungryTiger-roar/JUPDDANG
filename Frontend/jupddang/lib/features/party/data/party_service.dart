import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import 'package:jupddang/features/party/models/party_models.dart';
import '../../plogging/models/plogging_models.dart';
import '../../../../services/auth_service.dart';
import '../../../../core/logger/log_service.dart';

class PartyService {
  final ApiClient _apiClient;

  PartyService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  static const String partyBase = '/party';

  /// 초대 코드 생성
  Future<String> generateInviteCode() async {
    try {
      final response = await _apiClient.dio.get(
        '$partyBase/id',
      );
      return response.data['inviteCode']?.toString() ?? '';
    } catch (e) {
      LogService().log('❌ [Party] Generate Invite Code Error: $e');
      rethrow;
    }
  }

  /// 파티 생성 (초대 코드는 백엔드에서 자동 생성)
  Future<Party> createParty({required String name}) async {
    try {
      final response = await _apiClient.dio.post(
        partyBase,
        data: {'name': name},
      );
      return Party.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      LogService().log('❌ [Party] Create Party Error: $e');
      rethrow;
    }
  }

  /// 파티 참가
  Future<Party> joinParty(String inviteCode) async {
    try {
      final response = await _apiClient.dio.post(
        '$partyBase/join',
        data: {'inviteCode': inviteCode},
      );
      return Party.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      LogService().log('❌ [Party] Join Party Error: $e');
      rethrow;
    }
  }

  /// 파티 상세 조회
  Future<Party> getPartyDetail(int partyId) async {
    try {
      final response = await _apiClient.dio.get(
        '$partyBase/$partyId',
      );
      return Party.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      LogService().log('❌ [Party] Get Detail Error: $e');
      rethrow;
    }
  }

  /// 파티 시작 (방장 전용)
  Future<Map<String, dynamic>> startParty(int partyId) async {
    try {
      final response = await _apiClient.dio.post(
        '$partyBase/$partyId/start',
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      LogService().log('❌ [Party] Start Error: $e');
      rethrow;
    }
  }

  /// 실시간 활동 상태 조회
  Future<List<PartyActivity>> getActivityStatus(int partyId) async {
    try {
      final response = await _apiClient.dio.get(
        '$partyBase/$partyId/activities',
      );

      final activities = response.data['activities'] as List?;
      if (activities == null) return [];

      return activities
          .map((a) => PartyActivity.fromJson(a as Map<String, dynamic>))
          .toList();
    } catch (e) {
      LogService().log('❌ [Party] Get Activity Status Error: $e');
      rethrow;
    }
  }

  Future<dynamic> completeActivity(
      int partyId,
      PloggingEndRequest request,
      XFile beforeImage,
      XFile afterImage,
      XFile mapImage,
      ) async {
    try {
      final formData = FormData.fromMap({
        'request': jsonEncode(request.toJson()),
        'beforeImage': await MultipartFile.fromFile(
          beforeImage.path,
          filename: 'before.jpg',
        ),
        'afterImage': await MultipartFile.fromFile(
          afterImage.path,
          filename: 'after.jpg',
        ),
        'mapImage': await MultipartFile.fromFile(
          mapImage.path,
          filename: 'map.png',
        ),
      });

      final response = await _apiClient.dio.post(
        '$partyBase/$partyId/activities/complete',
        data: formData,
        // Content-Type multipart is handled by FormData
      );

      LogService().log('✅ [Party] Activity Completed');
      return response.data;
    } catch (e) {
      LogService().log('❌ [Party] Complete Activity Error: $e');
      rethrow;
    }
  }

  /// 간단한 활동 완료 (이미지 없이 - 테스트용)
  Future<void> completeActivitySimple(int partyId) async {
    try {
      await _apiClient.dio.get(
        '$partyBase/$partyId/activities',
      );
    } catch (e) {
      print('Complete Activity Simple Error: $e');
      // 에러 무시 (최선의 노력)
    }
  }
}
