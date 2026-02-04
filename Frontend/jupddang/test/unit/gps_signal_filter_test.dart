import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jupddang/services/gps_signal_filter.dart';

void main() {
  late GpsSignalFilter filter;

  setUp(() {
    filter = GpsSignalFilter();
  });

  Position createPosition({
    required double lat,
    required double lon,
    required double accuracy,
    DateTime? timestamp,
  }) {
    return Position(
      latitude: lat,
      longitude: lon,
      timestamp: timestamp ?? DateTime.now(),
      accuracy: accuracy,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
      floor: null,
      isMocked: false,
    );
  }

  group('GpsSignalFilter Tests', () {
    test('filter should reject low accuracy signal (>30m)', () {
      final pos = createPosition(lat: 37.5, lon: 127.0, accuracy: 50.0);
      final result = filter.filter(pos);
      expect(result, isNull);
    });

    test('filter should accept first valid signal', () {
      final pos = createPosition(lat: 37.5, lon: 127.0, accuracy: 10.0);
      final result = filter.filter(pos);
      expect(result, equals(pos));
    });

    test('filter should reject teleport (too fast)', () {
      final pos1 = createPosition(
          lat: 37.5, lon: 127.0, accuracy: 10.0, timestamp: DateTime(2023, 1, 1, 10, 0, 0));
      filter.filter(pos1);

      // 1초 뒤에 1km 이동 (3600km/h) -> 거절되어야 함
      final pos2 = createPosition(
          lat: 37.51, lon: 127.0, accuracy: 10.0, timestamp: DateTime(2023, 1, 1, 10, 0, 1));
      final result = filter.filter(pos2);
      expect(result, isNull);
    });

    test('filter should apply smoothing for valid signals', () {
      final initialTime = DateTime(2023, 1, 1, 10, 0, 0);
      final pos1 = createPosition(lat: 37.5, lon: 127.0, accuracy: 10.0, timestamp: initialTime);
      filter.filter(pos1);

      // 1초 뒤에 적절한 거리(약 10m) 이동
      final pos2 = createPosition(
          lat: 37.5001, lon: 127.0, accuracy: 10.0, timestamp: initialTime.add(const Duration(seconds: 1)));
      final result = filter.filter(pos2);

      expect(result, isNotNull);
      // 스무딩 결과로 위도가 중간 값이어야 함
      expect(result!.latitude, isNot(equals(37.5)));
      expect(result.latitude, isNot(equals(37.5001)));
      expect(result.latitude, closeTo(37.50008, 0.00001)); // alpha = (1 - 10/40) = 0.75. 37.5 + (37.5001 - 37.5) * 0.75 = 37.500075
    });

    test('reset should clear last position', () {
       final pos1 = createPosition(lat: 37.5, lon: 127.0, accuracy: 10.0);
       filter.filter(pos1);
       filter.reset();
       
       final pos2 = createPosition(lat: 37.6, lon: 127.1, accuracy: 10.0);
       final result = filter.filter(pos2);
       // reset 되었으므로 텔레포트 체크 없이 수용되어야 함
       expect(result, equals(pos2));
    });
  });
}
