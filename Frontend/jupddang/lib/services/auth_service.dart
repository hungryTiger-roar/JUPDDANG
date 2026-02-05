import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../features/auth/data/auth_service.dart' as AuthFeature;
import '../features/account/data/account_service.dart';
import '../features/social/data/social_service.dart';
import '../features/plogging/data/plogging_service.dart';
import '../features/plogging/models/plogging_models.dart';

// [Deprecation Notice] 이 클래스는 곧 삭제될 예정이며, 각 Feature별 Service를 직접 사용해야 합니다.
class AuthService {
  static const String apiBase = 'https://i14d208.p.ssafy.io/dev-api/api';
  final AuthFeature.AuthService _authService = AuthFeature.AuthService();
  final AccountService _accountService = AccountService();
  final SocialService _socialService = SocialService();
  final PloggingService _ploggingService = PloggingService();
  
  // ApiClient 싱글톤 접근용 (기존 코드 호환성)
  static String? get accessToken => ApiClient().accessToken;
  static set accessToken(String? token) => ApiClient().setAccessToken(token);
  
  static String? userId; // [Warning] 상태 관리(Provider 등)로 이관 필요
  static String? nickname;
  static int? userColor = 0xFF46A140; // Default Green

  // --- Auth ---
  Future<dynamic> login(String id, String pw) async {
    final data = await _authService.login(id, pw);
    // [Legacy Support] 정적 변수에 값 할당
    if (data is Map) {
         final account = data['account'];
         if (account is Map) {
            userId = account['userId']?.toString();
            nickname = account['nickname']?.toString();
         }
    }
    return data;
  }

  Future<dynamic> signup({
    required String id,
    required String pw,
    required String email,
    required String nickname,
    required String color,
  }) {
    return _authService.signup(
      id: id,
      pw: pw,
      email: email,
      nickname: nickname,
      color: color,
    );
  }

  Future<bool> deleteAccount() {
    return _authService.deleteAccount();
  }

  // --- Account ---
  Future<Map<String, dynamic>> getMyProfile() => _accountService.getMyProfile();
  Future<Map<String, dynamic>> getProfileById(String targetId) => _accountService.getProfileById(targetId);
  Future<Map<String, dynamic>> updateMyProfile(Map<String, dynamic> updates, dynamic imageFile) => _accountService.updateMyProfile(updates, imageFile);
  
  // --- Social ---
  Future<List<dynamic>> getPosts() => _socialService.getPosts();
  Future<List<dynamic>> getMyPosts() => _socialService.getMyPosts();
  Future<List<dynamic>> getMyComments() => _socialService.getMyComments();
  Future<List<dynamic>> getFollowings(String userId) => _socialService.getFollowings(userId);
  Future<List<dynamic>> getFollowers(String userId) => _socialService.getFollowers(userId);
  Future<bool> toggleFollow(String targetId) => _socialService.toggleFollow(targetId);
  Future<dynamic> createPost({required String userId, required String content, List<String> imagePaths = const []}) 
      => _socialService.createPost(userId: userId, content: content, imagePaths: imagePaths);
  Future<void> likePost(String postId) => _socialService.likePost(postId);
  Future<dynamic> addComment(String postId, String userId, String content) => _socialService.addComment(postId, userId, content);
  Future<void> deleteComment(String postId, String commentId) => _socialService.deleteComment(postId, commentId);
  Future<void> deletePost(String postId) => _socialService.deletePost(postId);

  // --- Plogging ---
  Future<dynamic> endPlogging({required PloggingEndRequest requestData, required String beforeImagePath, required String afterImagePath, required String mapImagePath})
      => _ploggingService.endPlogging(requestData: requestData, beforeImagePath: beforeImagePath, afterImagePath: afterImagePath, mapImagePath: mapImagePath);
      
  Future<dynamic> savePloggingTemp({required TempPloggingRequest requestData, String? beforeImagePath, String? afterImagePath, String? mapImagePath})
      => _ploggingService.savePloggingTemp(requestData: requestData, beforeImagePath: beforeImagePath, afterImagePath: afterImagePath, mapImagePath: mapImagePath);

  // --- Legacy Support ---
  Future<List<dynamic>> getAccounts() async => []; // 사용처 거의 없음
  Future<Map<String, dynamic>> searchUser(String targetId) => getProfileById(targetId);
}
