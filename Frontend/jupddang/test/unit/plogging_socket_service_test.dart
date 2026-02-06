import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:jupddang/features/plogging/data/plogging_socket_service.dart';
import 'package:jupddang/features/party/models/party_models.dart';

import 'party_socket_service_test.mocks.dart';

// GenerateMocks is already handled in party_socket_service_test.mocks.dart 
// (or we can regenerate if needed, but StompClient is the same)

void main() {
  late PloggingSocketService service;
  late MockStompClient mockClient;

  setUp(() {
    mockClient = MockStompClient();
    service = PloggingSocketService(
      stompClientFactory: ({required StompConfig config}) => mockClient,
      baseUrl: 'wss://test.api/ws',
    );
  });

  test('connect should activate the client', () {
    service.connect(partyId: 123, userId: 'user1', accessToken: 'mock_token');
    verify(mockClient.activate()).called(1);
  });

  test('sendLocation for Party should call send with party topic', () {
    when(mockClient.connected).thenReturn(true);
    when(mockClient.isActive).thenReturn(true);
    
    // Connect first to set state
    service.connect(partyId: 123, userId: 'user1', accessToken: 'mock_token');
    // We need to simulate connection success to set isConnected=true? 
    // Actually the service logic sets isConnected in callback, which we can't easily trigger here without capturing the callback.
    // However, sendLocation checks `isConnected`.
    // Let's force isConnected for testing purpose if possible or mock the callback trigger.
    // Since `isConnected` is a public field in PloggingSocketService, we can set it if it's not final.
    service.isConnected = true; 

    final locationRequest = LocationRequest(
      userId: 'user1',
      lat: 37.5,
      lon: 127.0,
      partyId: 123,
      elapsedTime: 100,
      totalDistance: 200,
      score: 50,
    );

    service.sendLocation(locationRequest);

    verify(mockClient.send(
      destination: '/pub/plogging/location/party/123',
      body: anyNamed('body'),
    )).called(1);
  });

  test('sendLocation for Individual should call send with generic topic and partyId 0', () {
    when(mockClient.connected).thenReturn(true);
    when(mockClient.isActive).thenReturn(true);

    service.connect(partyId: null, userId: 'user1', accessToken: 'mock_token');
    service.isConnected = true;

    final locationRequest = LocationRequest(
      userId: 'user1',
      lat: 37.5,
      lon: 127.0,
      partyId: 999, // Should be ignored/overwritten to 0
      elapsedTime: 100,
      totalDistance: 200,
      score: 50,
    );

    service.sendLocation(locationRequest);

    // Verify destination and body content
    verify(mockClient.send(
      destination: '/pub/plogging/location',
      body: argThat(contains('"partyId":0'), named: 'body'),
    )).called(1);
  });

  test('disconnect should deactivate the client', () {
    service.connect(partyId: 123, userId: 'user1', accessToken: 'mock_token');
    service.disconnect();

    verify(mockClient.deactivate()).called(1);
  });
}
