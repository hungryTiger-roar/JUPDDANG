import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/fcm_token_request.dart';
import '../../../../core/network/api_client.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('FCM background message: ${message.notification?.title}');
}

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ApiClient _apiClient = ApiClient();
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final StreamController<Map<String, dynamic>> _notificationTapController =
      StreamController.broadcast();
  static Map<String, dynamic>? _pendingTapData;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'fcm_default',
    'FCM Notifications',
    description: 'Foreground notifications',
    importance: Importance.high,
  );

  static const String _fcmTokenPath = '/fcm/token';
  static const String _fcmDeletePath = '/fcm/delete';

  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  Stream<Map<String, dynamic>> get notificationTapStream =>
      _notificationTapController.stream;

  Map<String, dynamic>? consumePendingTapData() {
    final data = _pendingTapData;
    _pendingTapData = null;
    return data;
  }

  Future<void> initialize() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        print('FCM permission not authorized');
        return;
      }

      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _initLocalNotifications();

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        _handleMessageOpenedApp(message);
        _emitNotificationTap(message.data);
      });

      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
        _emitNotificationTap(initialMessage.data);
      }

      _firebaseMessaging.onTokenRefresh.listen(_onTokenRefresh);
    } catch (e) {
      print('FCM initialize error: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print('FCM token: ${token?.substring(0, 20)}...');
      return token;
    } catch (e) {
      print('FCM getToken error: $e');
      return null;
    }
  }

  Future<bool> sendTokenToServer({
    required String token,
  }) async {
    try {
      final deviceType = Platform.isAndroid ? 'android' : 'ios';

      final request = FcmTokenRequest(
        token: token,
        deviceType: deviceType,
      );

      final response = await _apiClient.dio.post(
        _fcmTokenPath,
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode == 200 || statusCode == 201) {
        print('FCM token send success');
        return true;
      } else {
        print('FCM token send failed: $statusCode');
        return false;
      }
    } catch (e) {
      print('FCM token send error: $e');
      return false;
    }
  }

  Future<void> registerTokenOnLogin(String userId) async {
    String? token = await getToken();
    if (token != null) {
      await sendTokenToServer(token: token);
    }
  }

  Future<void> deleteTokenOnLogout() async {
    try {
      final response = await _apiClient.dio.delete(
        _fcmDeletePath,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode == 200) {
        print('FCM token delete success');
      }
    } catch (e) {
      print('FCM token delete error: $e');
    }
  }

  void _onTokenRefresh(String newToken) async {
    print('FCM token refresh: ${newToken.substring(0, 20)}...');
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('FCM foreground message: ${message.notification?.title}');

    if (message.notification != null) {
      print('Title: ${message.notification!.title}');
      print('Body: ${message.notification!.body}');
      _showLocalNotification(message);
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        try {
          final decoded = jsonDecode(payload);
          if (decoded is Map<String, dynamic>) {
            _emitNotificationTap(decoded);
          } else if (decoded is Map) {
            _emitNotificationTap(decoded.cast<String, dynamic>());
          }
        } catch (_) {}
      },
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: jsonEncode(message.data),
    );
  }

  void _emitNotificationTap(Map<String, dynamic> data) {
    _pendingTapData = data;
    _notificationTapController.add(data);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('FCM open app: ${message.data}');

    String? type = message.data['type'];

    switch (type) {
      case 'PLOGGING_COMPLETE':
        String? ploggingId = message.data['ploggingId'];
        print('Plogging complete: $ploggingId');
        break;

      case 'NEW_COMMENT':
        String? postId = message.data['postId'];
        print('New comment: $postId');
        break;
    }
  }
}
