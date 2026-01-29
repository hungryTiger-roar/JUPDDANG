import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../models/party_models.dart';
import 'auth_service.dart';

class PartySocketService {
  static const String wsUrl = 'wss://i14d208.p.ssafy.io/dev-api/ws';

  StompClient? _client;
  Function(List<PartyActivity>)? onActivitiesUpdated;
  Function(String)? onStatusUpdated;

  void connect(int partyId) {
    _client = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: (frame) => _onConnect(frame, partyId),
        onWebSocketError: (error) => print('WebSocket Error: $error'),
        stompConnectHeaders: {
          'Authorization': 'Bearer ${AuthService.accessToken}',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer ${AuthService.accessToken}',
        },
        reconnectDelay: const Duration(seconds: 5),
        connectionTimeout: const Duration(seconds: 10),
      ),
    );
    _client?.activate();
  }

  void _onConnect(StompFrame frame, int partyId) {
    print('Connected to Party WebSocket');

    // 파티 활동 정보 구독
    _client?.subscribe(
      destination: '/sub/party/$partyId/activities',
      callback: (frame) {
        if (frame.body != null) {
          final List<dynamic> data = jsonDecode(frame.body!);
          final activities = data
              .map((a) => PartyActivity.fromJson(a as Map<String, dynamic>))
              .toList();
          onActivitiesUpdated?.call(activities);
        }
      },
    );

    // 파티 상태 정보 구독 (시작 여부 감지)
    _client?.subscribe(
      destination: '/sub/party/$partyId/status',
      callback: (frame) {
        if (frame.body != null) {
          final Map<String, dynamic> data = jsonDecode(frame.body!);
          final status = data['status']?.toString();
          if (status != null) {
            onStatusUpdated?.call(status);
          }
        }
      },
    );
  }

  /// 자신의 활동 정보 전송 (방장이 주로 사용)
  void sendActivity(int partyId, PartyActivity activity) {
    if (_client == null || !_client!.connected) return;

    _client?.send(
      destination: '/pub/party/$partyId/activity',
      body: jsonEncode(activity.toJson()),
    );
  }

  void disconnect() {
    _client?.deactivate();
    _client = null;
  }
}
