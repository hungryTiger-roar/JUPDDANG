import 'dart:async';
import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import '../../party/models/party_models.dart';
import '../../../services/auth_service.dart';
import '../../../core/logger/log_service.dart';

class PloggingSocketService {
  StompClient? _client;
  final StompClient Function({required StompConfig config})? stompClientFactory;
  final String? _baseUrl;

  PloggingSocketService({this.stompClientFactory, String? baseUrl})
    : _baseUrl = baseUrl;

  // Callbacks
  Function(String)? onConnectionError;
  Function()? onConnected;

  // Party-Specific Callbacks
  Function(List<PartyActivity>)? onActivitiesUpdated;
  Function(String)? onStatusUpdated;
  Function(PartyMemberLocation)? onLeaderLocationUpdated;

  // Individual/General Callbacks
  Function(PartyMemberLocation)?
  onMemberLocationUpdate; // For individual or generic member updates

  // State
  bool isConnected = false;
  int? _currentPartyId;
  String? _currentUserId;
  bool _isIndividual = false;

  String get wsUrl =>
      _baseUrl ??
      dotenv.env['WS_URL'] ??
      'https://i14d208.p.ssafy.io/dev-api/ws';

  void connect({int? partyId, required String userId, String? accessToken}) {
    _currentPartyId = partyId;
    _currentUserId = userId;
    _isIndividual = partyId == null;

    if (_client != null && _client!.isActive) {
      debugPrint('🔌 Already connected or connecting.');
      return;
    }

    final token = accessToken ?? AuthService.accessToken;

    final config = StompConfig.sockJS(
      url: wsUrl,
      onConnect: _onConnect,
      onWebSocketError: (dynamic error) => _onError(error.toString()),
      onStompError: (dynamic error) => _onError(error.toString()),
      onDisconnect: (frame) => _onDisconnect(),
      stompConnectHeaders: {'Authorization': 'Bearer $token'},
      webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      heartbeatOutgoing: const Duration(seconds: 10),
      heartbeatIncoming: const Duration(seconds: 10),
    );

    _client = stompClientFactory != null
        ? stompClientFactory!(config: config)
        : StompClient(config: config);

    _client!.activate();
  }

  void _onConnect(StompFrame frame) {
    isConnected = true;
    debugPrint('✅ Socket Connected!');
    if (onConnected != null) onConnected!();
    _subscribeToTopic();
  }

  void _subscribeToTopic() {
    if (_client == null || !isConnected) return;

    if (!_isIndividual && _currentPartyId != null) {
      // 1. Party Activities (List of members stats)
      _client!.subscribe(
        destination: '/sub/party/$_currentPartyId/activities',
        callback: (frame) {
          if (frame.body != null) {
            try {
              final List<dynamic> data = jsonDecode(frame.body!);
              final activities = data
                  .map((a) => PartyActivity.fromJson(a as Map<String, dynamic>))
                  .toList();
              onActivitiesUpdated?.call(activities);
            } catch (e) {
              LogService().log('❌ Activities Parse Error: $e');
            }
          }
        },
      );

      // 2. Party Status (Waiting, InProgress, Completed)
      _client!.subscribe(
        destination: '/sub/party/$_currentPartyId/status',
        callback: (frame) {
          if (frame.body != null) {
            try {
              final Map<String, dynamic> data = jsonDecode(frame.body!);
              final status = data['status']?.toString();
              if (status != null) {
                onStatusUpdated?.call(status);
              }
            } catch (e) {
              LogService().log('❌ Status Parse Error: $e');
            }
          }
        },
      );

      // 3. Leader Location
      _client!.subscribe(
        destination: '/sub/party/$_currentPartyId/leader',
        callback: (frame) {
          if (frame.body != null) {
            try {
              final Map<String, dynamic> data = jsonDecode(frame.body!);
              final location = PartyMemberLocation.fromJson(data);
              onLeaderLocationUpdated?.call(location);
            } catch (e) {
              LogService().log('❌ Leader Location Parse Error: $e');
            }
          }
        },
      );

      // [New] Subscribe to ALL party members' locations
      _client!.subscribe(
        destination: '/sub/party/$_currentPartyId/locations',
        callback: (frame) {
          if (frame.body != null) {
            try {
              final Map<String, dynamic> data = jsonDecode(frame.body!);
              final location = PartyMemberLocation.fromJson(data);
              // We reuse the same callback or add a new one?
              // The user request is to SEE other members.
              // MapScreen logic needs to be updated to handle this stream.
              // Let's use onMemberLocationUpdate (which was for individual) or a NEW callback.
              // PloggingSocketService has "onMemberLocationUpdate" which is generic.
              // Let's use that one or create onPartyMemberLocationUpdate.
              // Existing onMemberLocationUpdate is used for "Individual/General Callbacks".
              // Let's reuse it or better, use a specific one.
              onMemberLocationUpdate?.call(location);
            } catch (e) {
              LogService().log('❌ Party Member Location Parse Error: $e');
            }
          }
        },
      );
    } else if (_isIndividual && _currentUserId != null) {
      // 4. Individual Subscription (Assumed Endpoint)
      _client!.subscribe(
        destination: '/sub/plogging/location/user/$_currentUserId',
        callback: (frame) {
          if (frame.body != null) {
            try {
              final data = jsonDecode(frame.body!);
              final location = PartyMemberLocation.fromJson(data);
              onMemberLocationUpdate?.call(location);
            } catch (e) {
              debugPrint('❌ Individual Data Parse Error: $e');
            }
          }
        },
      );
    }
  }

  void _onError(String error) {
    isConnected = false;
    debugPrint('❌ Socket Error: $error');
    if (onConnectionError != null) {
      onConnectionError!('서버 연결 실패: $error');
    }
  }

  void _onDisconnect() {
    isConnected = false;
    debugPrint('🔌 Socket Disconnected');
  }

  void disconnect() {
    if (_client != null) {
      _client!.deactivate();
      _client = null;
    }
    isConnected = false;
  }

  void sendLocation(LocationRequest request) {
    if (_client == null || !isConnected) return;

    // 🎯 백엔드 @MessageMapping("/plogging/track")에 맞게 수정
    // 기존: /pub/plogging/location 또는 /pub/plogging/location/party/$partyId
    // 수정: /pub/plogging/track (백엔드 엔드포인트와 일치)
    const String destination = '/pub/plogging/track';

    Map<String, dynamic> payload = request.toJson();

    // 개인 플로깅인 경우 partyId를 null로 설정 (백엔드에서 null 체크)
    if (_isIndividual) {
      payload['partyId'] = null;
    }

    _client!.send(destination: destination, body: jsonEncode(payload));
    debugPrint(
      '📡 Location sent to $destination: lat=${request.lat}, lon=${request.lon}, h3=${request.currentH3Index}',
    );
  }
}
