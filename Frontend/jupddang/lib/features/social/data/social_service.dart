import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import 'package:http_parser/http_parser.dart'; // MediaType을 위해 필요

class SocialService {
  final ApiClient _apiClient;

  SocialService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // --- Follow Domain ---

  // 팔로잉 목록 조회
  Future<List<dynamic>> getFollowings(String userId) async {
    try {
      final response = await _apiClient.dio.get('/follow/followings/$userId');
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Get Followings Error: $e');
      return [];
    }
  }

  // 팔로워 목록 조회
  Future<List<dynamic>> getFollowers(String userId) async {
    try {
      final response = await _apiClient.dio.get('/follow/followers/$userId');
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Get Followers Error: $e');
      return [];
    }
  }

  // 팔로우/언팔로우 토글
  Future<bool> toggleFollow(String targetId) async {
    try {
      final response = await _apiClient.dio.post('/follow/$targetId');
      return response.statusCode == 200;
    } catch (e) {
      print('Toggle Follow Error: $e');
      return false;
    }
  }

  // --- SNS (Posts) Domain ---

  // 전체 게시글 조회
  Future<List<dynamic>> getPosts({bool allPosts = false}) async {
    try {
      final endpoint = allPosts ? '/posts/all' : '/posts';
      final response = await _apiClient.dio.get(endpoint);
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Get Posts Error: $e');
      rethrow;
    }
  }
  
  // 내 게시글 조회
  Future<List<dynamic>> getMyPosts() async {
    try {
      final response = await _apiClient.dio.get('/posts/myposts');
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Get My Posts Error: $e');
      rethrow;
    }
  }

  // 내 댓글 조회
  Future<List<dynamic>> getMyComments() async {
    try {
      final response = await _apiClient.dio.get('/posts/mycomments');
      if (response.data is List) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      print('Get My Comments Error: $e');
      rethrow;
    }
  }

  // 게시글 생성
  Future<dynamic> createPost({
    required String userId,
    required String content,
    List<String> imagePaths = const [],
  }) async {
    try {
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

      final response = await _apiClient.dio.post(
        '/posts',
        data: formData,
      );
      return response.data;
    } catch (e) {
      print('Create Post Error: $e');
      rethrow;
    }
  }

  // 게시글 좋아요
  Future<void> likePost(String postId) async {
    await _apiClient.dio.post('/posts/$postId/like');
  }

  // 게시글 삭제
  Future<void> deletePost(String postId) async {
    await _apiClient.dio.delete('/posts/$postId');
  }

  // 댓글 작성
  Future<dynamic> addComment(String postId, String userId, String content) async {
    try {
      final response = await _apiClient.dio.post(
        '/posts/$postId/comment',
        data: {'userId': userId, 'content': content},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 댓글 삭제
  Future<void> deleteComment(String postId, String commentId) async {
    await _apiClient.dio.delete('/posts/$postId/$commentId');
  }
}
