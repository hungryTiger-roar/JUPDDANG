import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:jupddang/features/quest/data/quest_service.dart';
import 'package:jupddang/features/quest/models/quest_models.dart';

void main() {
  late QuestService service;

  setUp(() {
    service = QuestService();
  });

  group('QuestService - calculateDistance', () {
    test('동일한 위치에서 거리가 0이어야 함', () {
      final point = const LatLng(37.5665, 126.9780);
      final distance = service.calculateDistance(point, point);
      expect(distance, equals(0.0));
    });

    test('가까운 두 지점의 거리 계산 (약 10m 이내)', () {
      // 서울시청 근처 두 지점 (약 5-10m 거리)
      final point1 = const LatLng(37.5665, 126.9780);
      final point2 = const LatLng(37.56655, 126.97805);
      
      final distance = service.calculateDistance(point1, point2);
      
      // 약 7m 정도 예상
      expect(distance, lessThan(15.0));
      expect(distance, greaterThan(0.0));
    });

    test('먼 두 지점의 거리 계산 (10m 초과)', () {
      // 서울시청에서 약 100m 떨어진 지점
      final point1 = const LatLng(37.5665, 126.9780);
      final point2 = const LatLng(37.5675, 126.9790);
      
      final distance = service.calculateDistance(point1, point2);
      
      // 약 130m 정도 예상
      expect(distance, greaterThan(10.0));
    });

    test('Haversine 공식 정확도 검증 (서울-부산 약 325km)', () {
      final seoul = const LatLng(37.5665, 126.9780);
      final busan = const LatLng(35.1796, 129.0756);
      
      final distance = service.calculateDistance(seoul, busan);
      
      // 약 325km (325000m) ± 10%
      expect(distance, greaterThan(300000.0));
      expect(distance, lessThan(350000.0));
    });
  });

  group('QuestService - validateLocally', () {
    test('10m 이내 거리에서 검증 성공', () {
      // 매우 가까운 두 지점
      final beforeLocation = const LatLng(37.5665, 126.9780);
      final afterLocation = const LatLng(37.56652, 126.97802);
      
      final response = service.validateLocally(
        beforeLocation: beforeLocation,
        afterLocation: afterLocation,
      );
      
      expect(response.isValid, isTrue);
      expect(response.distanceMeters, lessThan(10.0));
    });

    test('10m 초과 거리에서 검증 실패', () {
      // 멀리 떨어진 두 지점
      final beforeLocation = const LatLng(37.5665, 126.9780);
      final afterLocation = const LatLng(37.5675, 126.9790);
      
      final response = service.validateLocally(
        beforeLocation: beforeLocation,
        afterLocation: afterLocation,
      );
      
      expect(response.isValid, isFalse);
      expect(response.distanceMeters, greaterThan(10.0));
      expect(response.message, contains('너무 멀리'));
    });

    test('검증 응답에 거리 정보 포함', () {
      final beforeLocation = const LatLng(37.5665, 126.9780);
      final afterLocation = const LatLng(37.56655, 126.97805);
      
      final response = service.validateLocally(
        beforeLocation: beforeLocation,
        afterLocation: afterLocation,
      );
      
      expect(response.distanceMeters, isNotNull);
      expect(response.distanceMeters, greaterThanOrEqualTo(0.0));
    });

    test('로컬 검증 시 쓰레기 개수는 0으로 반환', () {
      final beforeLocation = const LatLng(37.5665, 126.9780);
      final afterLocation = const LatLng(37.56652, 126.97802);
      
      final response = service.validateLocally(
        beforeLocation: beforeLocation,
        afterLocation: afterLocation,
      );
      
      // 로컬 검증에서는 AI 분석 없이 거리만 확인
      expect(response.beforeTrashCount, equals(0));
      expect(response.afterTrashCount, equals(0));
    });
  });

  group('QuestValidationResponse - fromJson', () {
    test('JSON 파싱 정상 동작', () {
      final json = {
        'isValid': true,
        'beforeTrashCount': 5,
        'afterTrashCount': 2,
        'distanceMeters': 3.5,
        'message': '검증 성공',
      };
      
      final response = QuestValidationResponse.fromJson(json);
      
      expect(response.isValid, isTrue);
      expect(response.beforeTrashCount, equals(5));
      expect(response.afterTrashCount, equals(2));
      expect(response.distanceMeters, equals(3.5));
      expect(response.message, equals('검증 성공'));
    });

    test('누락된 필드에 기본값 적용', () {
      final json = <String, dynamic>{};
      
      final response = QuestValidationResponse.fromJson(json);
      
      expect(response.isValid, isFalse);
      expect(response.beforeTrashCount, equals(0));
      expect(response.afterTrashCount, equals(0));
      expect(response.distanceMeters, equals(0.0));
      expect(response.message, isNull);
    });
  });
}
