import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/party_models.dart';
import 'auth_service.dart';

class PartyService {
  static const String apiBase = 'https://i14d208.p.ssafy.io/dev-api';
  static const String partyBase = '$apiBase/api/party';

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
}
