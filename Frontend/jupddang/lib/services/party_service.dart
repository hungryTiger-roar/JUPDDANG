import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../models/party_models.dart';
import '../models/plogging_models.dart';
import 'auth_service.dart';

class PartyService {

  // static const String apiBase = 'https://i14d208.p.ssafy.io/dev-api/api';
  static const String partyBase = '$apiBase/party';

  final Dio _dio = Dio(
    BaseOptions(
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

  /// 초대 코드 생성
  Future<String> generateInviteCode() async {
    try {
      final response = await _dio.get(
        '$partyBase/id',
        options: Options(headers: _authHeaders()),
      );
      return response.data['inviteCode']?.toString() ?? '';
    } catch (e) {
      print('Generate Invite Code Error: $e');
      rethrow;
    }
  }

  /// 파티 생성 (초대 코드는 백엔드에서 자동 생성)
  Future<Party> createParty({required String name}) async {
    try {
      final response = await _dio.post(
        partyBase,
        data: {'name': name},
        options: Options(headers: _authHeaders()),
      );
      return Party.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      print('Create Party Error: $e');
      rethrow;
    }
  }

  /// 파티 참가
  Future<Party> joinParty(String inviteCode) async {
    try {
      final response = await _dio.post(
        '$partyBase/join',
        data: {'inviteCode': inviteCode},
        options: Options(headers: _authHeaders()),
      );
      return Party.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      print('Join Party Error: $e');
      rethrow;
    }
  }

  /// 파티 상세 조회
  Future<Party> getPartyDetail(int partyId) async {
    try {
      final response = await _dio.get(
        '$partyBase/$partyId',
        options: Options(headers: _authHeaders()),
      );
      return Party.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      print('Get Party Detail Error: $e');
      rethrow;
    }
  }

  /// 파티 시작 (방장 전용)
  Future<Map<String, dynamic>> startParty(int partyId) async {
    try {
      final response = await _dio.post(
        '$partyBase/$partyId/start',
        options: Options(headers: _authHeaders()),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Start Party Error: $e');
      rethrow;
    }
  }

  /// 실시간 활동 상태 조회
  Future<List<PartyActivity>> getActivityStatus(int partyId) async {
    try {
      final response = await _dio.get(
        '$partyBase/$partyId/activities',
        options: Options(headers: _authHeaders()),
      );

      final activities = response.data['activities'] as List?;
      if (activities == null) return [];

      return activities
          .map((a) => PartyActivity.fromJson(a as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Get Activity Status Error: $e');
      rethrow;
    }
  }

  Future<dynamic> completeActivity( // 🎯 Future<void> → Future<dynamic>
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

      final response = await _dio.post( // 🎯 응답 저장
        '$partyBase/$partyId/activities/complete',
        data: formData,
        options: Options(
          headers: _authHeaders(),
          contentType: 'multipart/form-data',
        ),
      );

      print('파티 활동 완료 성공!');
      return response.data; // 🎯 응답 반환
    } catch (e) {
      print('Complete Activity Error: $e');
      rethrow;
    }
  }

  /// 간단한 활동 완료 (이미지 없이 - 테스트용)
  Future<void> completeActivitySimple(int partyId) async {
    try {
      // 백엔드에 간단한 종료 API가 없으므로, 상태 변경을 위해 활동 조회 API를 호출
      // 실제로는 백엔드에 종료 API가 필요함
      await _dio.get(
        '$partyBase/$partyId/activities',
        options: Options(headers: _authHeaders()),
      );
    } catch (e) {
      print('Complete Activity Simple Error: $e');
      // 에러 무시 (최선의 노력)
    }
  }
}
