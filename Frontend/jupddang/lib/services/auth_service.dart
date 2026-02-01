import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../models/plogging_models.dart';

class AuthService {
  // Android Emulator: 10.0.2.2
  // Real Device: Use your PC's IP address (e.g., 192.168.x.x) or deploy to server
  // For now, let's assume we are testing on emulator or web.
  // Note: Web deals with localhost differently.
  static const String apiBase = 'https://i14d208.p.ssafy.io/dev-api/api';
  static const String accountBase = '$apiBase/account';
  static const String postsBase = '$apiBase/posts';
  static const String ploggingBase = '$apiBase/v1/plogging/end';

  static String? accessToken;
  static String? userId;
  static String? nickname;

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

  //회원 탈퇴
  Future<bool> deleteAccount() async {
    try {
      final response = await _dio.delete(
        '$accountBase/delete',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        accessToken = null;
        userId = null;
        nickname = null;
        return true;
      }

      return false;
    } catch (e) {
      print('회원 탈퇴 실패: $e');
      return false;
    }
  }

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
        if (account is Map && account['nickname'] != null) {
          nickname = account['nickname'].toString();
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

  // 댓글 삭제
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await _dio.delete(
        '$postsBase/$postId/$commentId',
        options: Options(headers: _authHeaders()),
      );
    } catch (e) {
      print('Delete Comment Error: $e');
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

  Future<void> deletePost(String postId) async {
    try {
      await _dio.delete(
        '$postsBase/$postId',
        options: Options(headers: _authHeaders()),
      );
    } catch (e) {
      print('Delete Post Error: $e');
      rethrow;
    }
  }

  // 계정 정보 조회
  Future<Map<String, dynamic>> getAccount(String userId) async {
    try {
      final response = await _dio.get(
        '$accountBase/$userId',
        options: Options(headers: _authHeaders()),
      );
      if (response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Invalid response format');
    } catch (e) {
      print('Get Account Error: $e');
      rethrow;
    }
  }

  // 계정 정보 업데이트
  Future<Map<String, dynamic>> updateAccount(
    String userId,
    Map<String, dynamic> updates,
    dynamic imageFile,
  ) async {
    try {
      final headers = _authHeaders();

      if (imageFile != null) {
        // 이미지가 있는 경우 multipart/form-data로 전송
        final formData = FormData.fromMap({
          'data': MultipartFile.fromString(
            jsonEncode(updates),
            contentType: MediaType('application', 'json'),
          ),
          if (imageFile != null)
            'image': await MultipartFile.fromFile(imageFile.path),
        });

        final response = await _dio.put(
          '$accountBase/$userId',
          data: formData,
          options: Options(headers: headers),
        );
        return response.data as Map<String, dynamic>;
      } else {
        // 이미지가 없는 경우 JSON으로 전송
        final response = await _dio.put(
          '$accountBase/$userId',
          data: updates,
          options: Options(headers: headers),
        );
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      print('Update Account Error: $e');
      rethrow;
    }
  }

  // 내 프로필 조회 - GET /api/account/myprofile
  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await _dio.get(
        '$accountBase/myprofile',
        options: Options(headers: _authHeaders()),
      );
      if (response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw Exception('Invalid response format');
    } catch (e) {
      print('Get My Profile Error: $e');
      rethrow;
    }
  }

  // 내 프로필 업데이트 - PATCH /api/account/myprofile
  Future<Map<String, dynamic>> updateMyProfile(
    Map<String, dynamic> updates,
    dynamic imageFile,
  ) async {
    try {
      final headers = _authHeaders();

      // multipart/form-data로 전송
      final formData = FormData.fromMap({
        'data': MultipartFile.fromString(
          jsonEncode(updates),
          contentType: MediaType('application', 'json'),
        ),
        if (imageFile != null)
          'image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dio.patch(
        '$accountBase/myprofile',
        data: formData,
        options: Options(headers: headers),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Update My Profile Error: $e');
      rethrow;
    }
  }

  //화현: 팔로잉 목록 조회 - GET /api/follow/followings/{userId}
  Future<List<dynamic>> getFollowings(String userId) async {
    try {
      final response = await _dio.get(
        '$apiBase/follow/followings/$userId',
        options: Options(headers: _authHeaders()),
      );
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Get Followings Error: $e');
      return [];
    }
  }

  //화현: 팔로워 목록 조회 - GET /api/follow/followers/{userId}
  Future<List<dynamic>> getFollowers(String userId) async {
    try {
      final response = await _dio.get(
        '$apiBase/follow/followers/$userId',
        options: Options(headers: _authHeaders()),
      );
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Get Followers Error: $e');
      return [];
    }
  }

  //화현: 팔로우/언팔로우 토글 - POST /api/follow/{targetId}
  Future<bool> toggleFollow(String targetId) async {
    try {
      final response = await _dio.post(
        '$apiBase/follow/$targetId',
        options: Options(headers: _authHeaders()),
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Toggle Follow Error: $e');
      return false;

  Future<void> endPlogging({
    required PloggingEndRequest requestData,
    required String beforeImagePath,
    required String afterImagePath,
    required String mapImagePath,
  }) async {
    try {
      final headers = _authHeaders();
      if (userId != null && userId!.isNotEmpty) {
        headers['userId'] = userId!;
      }

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

      await _dio.post(
        ploggingBase,
        data: formData,
        options: Options(headers: headers),
      );
    } catch (e) {
      print('End Plogging Error: $e');
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
