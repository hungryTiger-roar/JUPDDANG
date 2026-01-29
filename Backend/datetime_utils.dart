/// Time Type Handling Utilities for Flutter ↔ Spring Boot
/// 
/// This utility class provides helper methods for converting DateTime objects
/// to/from ISO 8601 format compatible with the Spring Boot backend.
/// 
/// **Backend Format**: "yyyy-MM-dd'T'HH:mm:ss" (ISO 8601 without milliseconds)
/// **Timezone**: Asia/Seoul (server-side)
/// 
/// ## Usage Examples
/// 
/// ### Sending DateTime to API:
/// ```dart
/// final now = DateTime.now();
/// final formatted = DateTimeUtils.toApiFormat(now);
/// // Result: "2026-01-29T12:25:00"
/// 
/// final requestBody = {
///   'startTime': formatted,
/// };
/// ```
/// 
/// ### Receiving DateTime from API:
/// ```dart
/// final dateTime = DateTimeUtils.fromApiFormat(json['createdAt']);
/// ```
/// 
/// ### Calculating Elapsed Time:
/// ```dart
/// final startTime = DateTime.now();
/// // ... user activity ...
/// final endTime = DateTime.now();
/// final elapsedSeconds = DateTimeUtils.calculateElapsedSeconds(startTime, endTime);
/// ```

class DateTimeUtils {
  /// Convert DateTime to ISO 8601 string for API requests
  /// 
  /// Removes milliseconds to match backend format: "yyyy-MM-dd'T'HH:mm:ss"
  /// 
  /// Example:
  /// ```dart
  /// final now = DateTime(2026, 1, 29, 12, 25, 0);
  /// final formatted = DateTimeUtils.toApiFormat(now);
  /// print(formatted); // "2026-01-29T12:25:00"
  /// ```
  static String toApiFormat(DateTime dateTime) {
    return dateTime.toIso8601String().split('.')[0];
  }

  /// Parse ISO 8601 string from API response
  /// 
  /// Returns null if parsing fails or input is null/empty.
  /// 
  /// Example:
  /// ```dart
  /// final dateTime = DateTimeUtils.fromApiFormat("2026-01-29T12:25:00");
  /// print(dateTime); // DateTime object
  /// ```
  static DateTime? fromApiFormat(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return null;
    return DateTime.tryParse(dateTimeString);
  }

  /// Calculate elapsed seconds between two DateTime objects
  /// 
  /// Useful for sending activity duration to backend.
  /// 
  /// Example:
  /// ```dart
  /// final start = DateTime.now();
  /// // ... 1 hour later ...
  /// final end = DateTime.now();
  /// final elapsed = DateTimeUtils.calculateElapsedSeconds(start, end);
  /// print(elapsed); // 3600
  /// ```
  static int calculateElapsedSeconds(DateTime start, DateTime end) {
    return end.difference(start).inSeconds;
  }

  /// Convert UTC DateTime to local time
  /// 
  /// Example:
  /// ```dart
  /// final utc = DateTime.utc(2026, 1, 29, 3, 25, 0);
  /// final local = DateTimeUtils.utcToLocal(utc);
  /// print(local); // 2026-01-29 12:25:00 (if timezone is Asia/Seoul)
  /// ```
  static DateTime utcToLocal(DateTime utc) {
    return utc.toLocal();
  }

  /// Convert local DateTime to UTC
  /// 
  /// Example:
  /// ```dart
  /// final local = DateTime(2026, 1, 29, 12, 25, 0);
  /// final utc = DateTimeUtils.localToUtc(local);
  /// print(utc); // 2026-01-29 03:25:00 (if timezone is Asia/Seoul)
  /// ```
  static DateTime localToUtc(DateTime local) {
    return local.toUtc();
  }

  /// Format DateTime for display in UI
  /// 
  /// Example:
  /// ```dart
  /// final now = DateTime.now();
  /// final formatted = DateTimeUtils.formatForDisplay(now);
  /// print(formatted); // "2026-01-29 12:25"
  /// ```
  static String formatForDisplay(DateTime dateTime) {
    return '${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)} '
        '${_pad(dateTime.hour)}:${_pad(dateTime.minute)}';
  }

  /// Format elapsed seconds to human-readable duration
  /// 
  /// Example:
  /// ```dart
  /// final formatted = DateTimeUtils.formatElapsedTime(3665);
  /// print(formatted); // "1h 1m 5s"
  /// ```
  static String formatElapsedTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  /// Helper method to pad single digits with leading zero
  static String _pad(int value) {
    return value.toString().padLeft(2, '0');
  }
}
