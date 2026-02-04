import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:jupddang/features/auth/data/auth_service.dart';
import 'package:jupddang/core/network/api_client.dart';

// Generate Mocks
@GenerateMocks([ApiClient, Dio])
import 'auth_service_test.mocks.dart';

void main() {
  late AuthService authService;
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();

    // ApiClient의 dio 게터가 mockDio를 반환하도록 설정
    when(mockApiClient.dio).thenReturn(mockDio);

    // AuthService 생성 시 Mock 주입
    authService = AuthService(apiClient: mockApiClient);
  });

  group('AuthService Login Test', () {
    const userId = 'testUser';
    const userPw = 'testPass';

    test('Login Success returns data and sets token', () async {
      // Arrange
      final mockResponseData = {
        'accessToken': 'fake_token_123',
        'account': {'userId': userId, 'nickname': 'Tester'}
      };
      
      when(mockDio.post(
        '/account/login',
        data: {'id': userId, 'pw': userPw},
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/account/login'),
        data: mockResponseData,
        statusCode: 200,
      ));

      // Act
      final result = await authService.login(userId, userPw);

      // Assert
      expect(result, mockResponseData);
      verify(mockApiClient.setAccessToken('fake_token_123')).called(1);
    });

    test('Login Failure propagates exception', () async {
      // Arrange
      when(mockDio.post(
        any,
        data: anyNamed('data'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/account/login'),
        error: 'Login Failed',
        type: DioExceptionType.badResponse,
      ));

      // Act & Assert
      expect(() => authService.login(userId, userPw), throwsA(isA<DioException>()));
    });
  });
}
