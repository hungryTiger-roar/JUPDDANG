
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:jupddang/features/account/data/account_service.dart';
import 'package:jupddang/core/network/api_client.dart';

// Generate mocks
@GenerateMocks([ApiClient, Dio])
import 'account_service_test.mocks.dart';

void main() {
  late AccountService accountService;
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(mockApiClient.dio).thenReturn(mockDio);
    accountService = AccountService(apiClient: mockApiClient);
  });

  group('AccountService', () {
    test('getMyProfile returns map when successful', () async {
      // Arrange
      final mockData = {'userId': 'testUser', 'nickname': 'Test Nick'};
      when(mockDio.get('/account/myprofile')).thenAnswer(
        (_) async => Response(
          data: mockData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/account/myprofile'),
        ),
      );

      // Act
      final result = await accountService.getMyProfile();

      // Assert
      expect(result, mockData);
      verify(mockDio.get('/account/myprofile')).called(1);
    });

    test('updateMyProfile sends valid JSON', () async {
        // This test documents the fix we need to make (jsonEncode)
        // We will simulate the fix in the service first
    });
  });
}
