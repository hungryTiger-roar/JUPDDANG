import 'package:flutter/foundation.dart';

class LogService {
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  LogService._internal();

  final List<String> _logs = [];
  final ValueNotifier<List<String>> logsNotifier = ValueNotifier([]);

  // 최대 로그 저장 개수
  static const int _maxLogs = 1000;

  void log(String message) {
    // 디버그 모드에서만 콘솔 출력
    if (kDebugMode) {
      print("[In-App] $message");
    }

    final timestamp = DateTime.now().toIso8601String().split('T').last;
    final formattedLog = '[$timestamp] $message';

    _logs.insert(0, formattedLog); // 최신 로그가 위로 오도록
    if (_logs.length > _maxLogs) {
      _logs.removeLast();
    }
    
    // UI 업데이트 알림
    logsNotifier.value = List.from(_logs);
  }

  void clear() {
    _logs.clear();
    logsNotifier.value = [];
  }
}
