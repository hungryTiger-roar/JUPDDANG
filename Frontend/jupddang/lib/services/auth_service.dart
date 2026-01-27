import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class AuthService {
  // Android Emulator: 10.0.2.2
  // Real Device: Use your PC's IP address (e.g., 192.168.x.x) or deploy to server
  // For now, let's assume we are testing on emulator or web.
  // Note: Web deals with localhost differently.

  // static const String baseUrl = 'http://127.0.0.1:8080/api/account';
  // 실제 기기 테스트를 위해 호스트 PC의 로컬 IP 사용
  static const String apiBase = 'http://10.195.208.228:8080/api';
  static const String accountBase = '$apiBase/account';
  static const String postsBase = '$apiBase/posts';

  static String? accessToken;
  static String? userId;

  final Dio _dio =
      Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            requestHeader: false,
            responseHeader: false,
          ),
        );

  Future<dynamic> login(String id, String pw) async {
    try {
      final response = await _dio.post(
        '$accountBase/login',
        data: {'id': id, 'pw': pw},
      );
      final data = response.data;
      if (data is Map) {
        final token = data['accessToken'];
        if (token is String && token.isNotEmpty) {
          accessToken = token;
        }
        final account = data['account'];
        if (account is Map && account['userId'] != null) {
          userId = account['userId'].toString();
        }
      }
      return response.data;
    } catch (e) {
      print('Login Error: $e');
      throw e;
    }
  }

  Future<dynamic> signup({
    required String id,
    required String pw,
    required String email,
    required String nickname,
    required String region,
    String? profileImage,
    String? intro,
  }) async {
    try {
      final response = await _dio.post(
        '$accountBase/signup',
        data: {
          'id': id,
          'pw': pw,
          'email': email,
          'nickname': nickname,
          'region': region,
          'profileImage': profileImage ?? '',
          'intro': intro ?? '',
        },
      );
      return response.data;
    } catch (e) {
      print('Signup Error: $e');
      throw e;
    }
  }

  Future<List<dynamic>> getAccounts() async {
    try {
      final response = await _dio.get(
        accountBase,
        options: Options(headers: _authHeaders()),
      );
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Get Accounts Error: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getPosts() async {
    try {
      final response = await _dio.get(
        postsBase,
        options: Options(headers: _authHeaders()),
      );
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Get Posts Error: $e');
      rethrow;
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await _dio.post(
        '$postsBase/$postId/like',
        options: Options(headers: _authHeaders()),
      );
    } catch (e) {
      print('Like Post Error: $e');
      rethrow;
    }
  }

  Future<dynamic> addComment(
    String postId,
    String userId,
    String content,
  ) async {
    try {
      final response = await _dio.post(
        '$postsBase/$postId/comment',
        data: {'userId': userId, 'content': content},
        options: Options(headers: _authHeaders()),
      );
      return response.data;
    } catch (e) {
      print('Add Comment Error: $e');
      rethrow;
    }
  }

  Future<dynamic> createPost({
    required String userId,
    required String content,
    List<String> imagePaths = const [],
  }) async {
    try {
      final headers = _authHeaders();
      if (imagePaths.isNotEmpty) {
        final payload = {
          'userId': userId,
          'content': content,
          'beforeImageUrl': '',
          'afterImageUrl': '',
          'mapImageUrl': '',
        };
        final formData = FormData.fromMap({
          'data': MultipartFile.fromString(
            jsonEncode(payload),
            contentType: MediaType('application', 'json'),
          ),
          'images': [
            for (final path in imagePaths.take(5))
              await MultipartFile.fromFile(path),
          ],
        });
        final response = await _dio.post(
          postsBase,
          data: formData,
          options: Options(headers: headers),
        );
        return response.data;
      }

      final response = await _dio.post(
        postsBase,
        data: {
          'userId': userId,
          'content': content,
          'beforeImageUrl': '',
          'afterImageUrl': '',
          'mapImageUrl': '',
        },
        options: Options(headers: headers),
      );
      return response.data;
    } catch (e) {
      print('Create Post Error: $e');
      rethrow;
    }
  }

  Map<String, String> _authHeaders() {
    if (accessToken == null || accessToken!.isEmpty) {
      return {};
    }
    return {'Authorization': 'Bearer $accessToken'};
  }
}
