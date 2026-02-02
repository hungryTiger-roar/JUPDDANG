import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../models/party_models.dart';
import 'auth_service.dart';

class PartySocketService {

  StompClient? _client;
  Function(List<PartyActivity>)? onActivitiesUpdated;
  Function(String)? onStatusUpdated;
  Function(PartyMemberLocation)? onLeaderLocationUpdated;

  void connect(int partyId) {
    _client = StompClient(
      config: StompConfig.sockJS(
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

    // 파티장 위치 정보만 구독 (엔드포인트 변경)
    _client?.subscribe(
      destination: '/sub/party/$partyId/leader',
      callback: (frame) {
        if (frame.body != null) {
          _handleLeaderLocationUpdate(frame.body!);
        }
      },
    );
  }

  // 위치 정보를 파싱하고 Map으로 관리
  PartyMemberLocation? _leaderLocation;

  void _handleLeaderLocationUpdate(String body) {
    try {
      print('===== 파티장 위치 데이터 수신 =====');
      print('Raw data: $body');

      final Map<String, dynamic> data = jsonDecode(body);
      print('Parsed data: $data');

      final location = PartyMemberLocation.fromJson(data);

      print('파티장 ID: ${location.userId}');
      print('위도: ${location.lat}');
      print('경도: ${location.lon}');
      print('경과시간: ${location.elapsedTime}초');
      print('총 거리: ${location.totalDistance}m');
      print('점수: ${location.score}');
      print('================================');

      _leaderLocation = location;
      onLeaderLocationUpdated?.call(location);
    } catch (e) {
      print('❌ Leader location update parsing error: $e');
    }
  }


  /// 자신의 활동 정보 전송 (방장이 주로 사용)
  void sendLocation(int partyId, LocationRequest location) {
    if (_client == null || !_client!.connected) return;

    _client?.send(
      destination: '/pub/plogging/location/party/$partyId',
      body: jsonEncode(location.toJson()),
    );
  }

  void disconnect() {
    _client?.deactivate();
    _client = null;
  }

}
