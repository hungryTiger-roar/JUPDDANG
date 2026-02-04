import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // 로그인
  Future<Map<String, dynamic>> login(String id, String pw) async {
    try {
      final response = await _apiClient.dio.post(
        '/account/login',
        data: {'id': id, 'pw': pw},
      );
      
      final data = response.data;
      if (data is Map) {
        // 토큰 저장 (ApiClient 싱글톤에 설정)
        final token = data['accessToken'];
        if (token is String && token.isNotEmpty) {
          _apiClient.setAccessToken(token);
        }
      }
      return data;
    } catch (e) {
      // [Conflict Consideration] 기존에는 print만 했으나 리팩토링 시 rethrow 혹은 커스텀 Exception 사용 권장
      print('Login Error: $e');
      rethrow;
    }
  }

  // 회원가입
  Future<dynamic> signup({
    required String id,
    required String pw,
    required String email,
    required String nickname,
    required String color,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/account/signup',
        data: {
          'id': id,
          'pw': pw,
          'email': email,
          'nickname': nickname,
          'color': color,
        },
      );
      return response.data;
    } catch (e) {
      print('Signup Error: $e');
      rethrow;
    }
  }

  // 회원 탈퇴
  Future<bool> deleteAccount() async {
    try {
      final response = await _apiClient.dio.delete('/account/delete');
      if (response.statusCode == 200) {
        _apiClient.setAccessToken(null); // 토큰 초기화
        return true;
      }
      return false;
    } catch (e) {
      print('Delete Account Error: $e');
      return false;
    }
  }
}
