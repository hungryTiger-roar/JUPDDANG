import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:jupddang/core/network/api_client.dart';
import 'package:jupddang/features/party/data/party_service.dart';
import 'package:jupddang/features/party/models/party_models.dart';

import 'party_service_test.mocks.dart';

@GenerateMocks([ApiClient, Dio])
void main() {
  late PartyService service;
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
    when(mockApiClient.dio).thenReturn(mockDio);
    service = PartyService(apiClient: mockApiClient);
  });

  group('PartyService Tests', () {
    test('generateInviteCode should return invite code', () async {
      when(mockDio.get('/party/id')).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/party/id'),
            statusCode: 200,
            data: {'inviteCode': 'ABCDEF'},
          ));

      final result = await service.generateInviteCode();
      expect(result, 'ABCDEF');
      verify(mockDio.get('/party/id')).called(1);
    });

    test('createParty should return Party object', () async {
      final partyData = {
        'partyId': 1,
        'name': 'Test Party',
        'inviteCode': 'XYZ123',
        'leaderId': 'leader',
        'members': [],
        'status': 'WAITING',
      };

      when(mockDio.post('/party', data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/party'),
                statusCode: 200,
                data: partyData,
              ));

      final result = await service.createParty(name: 'Test Party');
      expect(result.partyId, 1);
      expect(result.name, 'Test Party');
      verify(mockDio.post('/party', data: {'name': 'Test Party'})).called(1);
    });

    test('joinParty should return Party object', () async {
       final partyData = {
        'partyId': 1,
        'name': 'Test Party',
        'inviteCode': 'ABCDEF',
        'leaderId': 'leader',
        'members': [],
        'status': 'WAITING',
      };

      when(mockDio.post('/party/join', data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/party/join'),
                statusCode: 200,
                data: partyData,
              ));

      final result = await service.joinParty('ABCDEF');
      expect(result.partyId, 1);
      verify(mockDio.post('/party/join', data: {'inviteCode': 'ABCDEF'})).called(1);
    });
  });
}
