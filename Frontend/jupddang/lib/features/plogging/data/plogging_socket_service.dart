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

    final partyId = _isIndividual ? 0 : request.partyId;

    // Party sends to /pub/plogging/location/party/$partyId
    // Individual sends to /pub/plogging/location (Assumed)

    String destination;
    if (_isIndividual) {
      destination = '/pub/plogging/location';
      // Ensure payload has partyId: 0
      Map<String, dynamic> payload = request.toJson();
      payload['partyId'] = 0;
      _client!.send(destination: destination, body: jsonEncode(payload));
    } else {
      destination = '/pub/plogging/location/party/$partyId';
      _client!.send(
        destination: destination,
        body: jsonEncode(request.toJson()),
      );
    }
  }
}
