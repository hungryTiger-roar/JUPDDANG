import 'package:dio/dio.dart';
import '../../core/logger/log_service.dart';
import '../../services/auth_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  // [TODO] 환경 변수나 설정 파일로 분리 추천
  static const String baseUrl = 'https://i14d208.p.ssafy.io/dev-api/api';

  String? _accessToken;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null && _accessToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          // Add userId header if available (required by deployed backend)
          if (AuthService.userId != null && AuthService.userId!.isNotEmpty) {
            options.headers['userId'] = AuthService.userId!;
          }
          LogService().log(
            '➡️ [API] Request: ${options.method} ${options.path}',
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          LogService().log(
            '✅ [API] Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // [TODO] 401 Unauthorized 처리 (토큰 갱신 or 로그아웃)
          LogService().log(
            '❌ [API] Error: ${e.message}, Path: ${e.requestOptions.path}',
          );
          return handler.next(e);
        },
      ),
    );
  }

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  String? get accessToken => _accessToken;
}
