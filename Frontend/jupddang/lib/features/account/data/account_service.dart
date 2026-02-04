import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../core/network/api_client.dart';

class AccountService {
  final ApiClient _apiClient;

  AccountService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // 내 프로필 조회
  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await _apiClient.dio.get('/account/myprofile');
      if (response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Invalid response format');
    } catch (e) {
      print('Get My Profile Error: $e');
      rethrow;
    }
  }

  // 타인 프로필 조회
  Future<Map<String, dynamic>> getProfileById(String targetId) async {
    try {
      final response = await _apiClient.dio.get('/account/profile/$targetId');
      if (response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Invalid response format');
    } catch (e) {
      print('Get Profile By ID Error: $e');
      rethrow;
    }
  }

  // 내 프로필 수정
  Future<Map<String, dynamic>> updateMyProfile(
      Map<String, dynamic> updates,
      dynamic imageFile, // File 객체 혹은 path
      ) async {
    try {
      final formData = FormData.fromMap({
        'data': MultipartFile.fromString(
          jsonEncode(updates),
          contentType: MediaType('application', 'json'),
        ),
        if (imageFile != null)
          'image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _apiClient.dio.patch(
        '/account/myprofile',
        data: formData,
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Update My Profile Error: $e');
      rethrow;
    }
  }
}
