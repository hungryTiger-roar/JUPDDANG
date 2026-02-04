import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:jupddang/features/party/data/party_socket_service.dart';
import 'package:jupddang/features/party/models/party_models.dart';

import 'party_socket_service_test.mocks.dart';

@GenerateMocks([StompClient])
void main() {
  late PartySocketService service;
  late MockStompClient mockClient;

  setUp(() {
    mockClient = MockStompClient();
    service = PartySocketService(
      stompClientFactory: ({required StompConfig config}) => mockClient,
    );
  });

  test('connect should activate the client', () {
    service.connect(123);
    verify(mockClient.activate()).called(1);
  });

  test('sendLocation should call send if connected', () {
    when(mockClient.connected).thenReturn(true);
    service.connect(123);

    final locationRequest = LocationRequest(
      userId: 'test-user',
      lat: 37.5,
      lon: 127.0,
      partyId: 123,
      elapsedTime: 100,
      totalDistance: 200,
      score: 50,
    );

    service.sendLocation(123, locationRequest);

    verify(mockClient.send(
      destination: '/pub/plogging/location/party/123',
      body: anyNamed('body'),
    )).called(1);
  });

  test('disconnect should deactivate the client', () {
    service.connect(123);
    service.disconnect();

    verify(mockClient.deactivate()).called(1);
  });
}
