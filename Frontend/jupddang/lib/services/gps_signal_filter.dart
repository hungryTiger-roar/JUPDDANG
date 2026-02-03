import 'package:geolocator/geolocator.dart';

/// GPS 신호 튀는 현상(Jitter)을 방지하기 위한 필터 클래스
/// 위도/경도뿐만 아니라 정확도(accuracy)와 시간(timestamp)을 기반으로 유효성을 검증합니다.
class GpsSignalFilter {
  Position? _lastApprovedPosition;
  DateTime? _lastApprovedTime;

  /// GPS 신호를 받아 필터링합니다.
  /// - null 반환: 신뢰할 수 없는 데이터 (무시하세요)
  /// - Position 반환: 보정된 안전한 데이터 (사용하세요)
  Position? filter(Position newPos) {
    // -------------------------------------------------------------------------
    // 1. 정확도 필터 (Accuracy Gate)
    // -------------------------------------------------------------------------
    // 기기가 보고한 오차 범위가 30m보다 크면 위치 정보를 신뢰할 수 없음
    // (예: 실내, 깊은 골목, 지하 등)
    if (newPos.accuracy > 30.0) {
      return null;
    }

    // 첫 데이터는 비교 대상이 없으므로 무조건 수용
    if (_lastApprovedPosition == null || _lastApprovedTime == null) {
      _lastApprovedPosition = newPos;
      _lastApprovedTime = newPos.timestamp;
      return newPos;
    }

    // -------------------------------------------------------------------------
    // 2. 텔레포트 감지 (Speed/Distance Check)
    // -------------------------------------------------------------------------
    // 이전 위치와의 거리(m)와 시간차(s) 계산
    final double distMeters = Geolocator.distanceBetween(
      _lastApprovedPosition!.latitude,
      _lastApprovedPosition!.longitude,
      newPos.latitude,
      newPos.longitude,
    );

    // 시간차 (milliseconds)
    final int timeDiffMs =
        newPos.timestamp.difference(_lastApprovedTime!).inMilliseconds;

    // 시간이 너무 짧으면(0.5초 미만) 튀는 값일 확률 높음 -> 버림
    // (GPS 갱신 주기가 보통 1초인데, 그 사이에 들어오는 건 노이즈일 가능성)
    if (timeDiffMs < 500) return null;

    final double speedMPS = distMeters / (timeDiffMs / 1000.0);

    // 보행 앱 기준, 20m/s (72km/h) 이상이면 텔레포트 오류로 간주 -> 버림
    // (사람이 우사인 볼트보다 빠를 수 없음)
    if (speedMPS > 20.0) {
      return null;
    }

    // -------------------------------------------------------------------------
    // 3. 적응형 스무딩 (Adaptive Smoothing / Kalman-like)
    // -------------------------------------------------------------------------
    // 정확도가 높을수록(값이 작을수록) 새 데이터를 더 많이 신뢰
    // 공식: alpha = (1.0 - (accuracy / 40.0))
    // - accuracy 5m -> alpha 0.875 (새 위치 87% 반영, 빠릿함)
    // - accuracy 20m -> alpha 0.5 (새 위치 50% 반영, 반반 섞기)
    // - accuracy 35m -> (이미 단계 1에서 걸러짐)
    // 최소 0.1, 최대 0.9로 제한하여 완전 정지나 완전 점프 방지
    double alpha = (1.0 - (newPos.accuracy / 40.0)).clamp(0.1, 0.9);

    double newLat = _lastApprovedPosition!.latitude +
        (newPos.latitude - _lastApprovedPosition!.latitude) * alpha;
    double newLng = _lastApprovedPosition!.longitude +
        (newPos.longitude - _lastApprovedPosition!.longitude) * alpha;

    // 보정된 값을 새 Position 객체로 생성 (Return 타입 유지)
    Position correctedPos = Position(
      latitude: newLat,
      longitude: newLng,
      timestamp: newPos.timestamp,
      accuracy: newPos.accuracy,
      altitude: newPos.altitude,
      altitudeAccuracy: newPos.altitudeAccuracy,
      heading: newPos.heading,
      headingAccuracy: newPos.headingAccuracy,
      speed: newPos.speed,
      speedAccuracy: newPos.speedAccuracy,
      floor: newPos.floor,
      isMocked: newPos.isMocked,
    );

    _lastApprovedPosition = correctedPos;
    _lastApprovedTime = newPos.timestamp;

    return correctedPos;
  }

  /// 필터 초기화 (플로깅 새로 시작 시 호출 등)
  void reset() {
    _lastApprovedPosition = null;
    _lastApprovedTime = null;
  }
}
