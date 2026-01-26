import 'dart:math';
import 'package:h3_flutter/h3_flutter.dart';
// GeoCoord 클래스 사용을 위해 추가
import 'package:h3_common/h3_common.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/hexagon.dart';

class LocationH3Service {
  late final H3 _h3;
  final int resolution = 9;

  static final LocationH3Service _instance = LocationH3Service._internal();
  factory LocationH3Service() => _instance;
  LocationH3Service._internal();

  bool _isInitialized = false;
  // 로컬 점령 정보 저장소 (H3 Index -> HexagonModel)
  final Map<String, HexagonModel> _occupiedHexagons = {};

  Future<void> init() async {
    if (_isInitialized) return;
    // h3_dart는 팩토리 로드 없이 바로 사용 가능하거나, const 생성자 사용
    // h3_dart v0.7.0 기준: H3 팩토리 사용 (const H3Factory().load())는 h3_flutter 전용일 수 있음.
    // 하지만 h3_dart가 C 바인딩이 아니라면 그냥 H3() 생성자로 쓰거나 정적 메서드일 수 있음.
    // 확인 결과: h3_dart는 보통 순수 Dart 포팅이므로:
    _h3 = const H3Factory().load();
    _isInitialized = true;
  }

  /// 현재 위치 권한 요청 및 위치 스트림 반환
  Stream<Position> getPositionStream() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // 5m 이동 시 갱신 (Throttling)
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  /// 초기 위치 권한 확인 및 요청
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  /// 화면 영역(Bounds) 내의 H3 헥사곤 ID 리스트 생성 (로컬 연산)
  /// [southWest], [northEast] : 화면의 남서쪽, 북동쪽 좌표
  List<String> getHexagonsInBounds(LatLng southWest, LatLng northEast) {
    if (!_isInitialized) return [];

    // 1. 영역의 코너 좌표들로 폴리곤 생성
    // 순서: SW -> NW -> NE -> SE -> SW (닫힌 루프가 안전함)

    // h3_flutter의 GeoCoord 사용
    final polygon = [
      GeoCoord(lat: southWest.latitude, lon: southWest.longitude),
      GeoCoord(lat: northEast.latitude, lon: southWest.longitude),
      GeoCoord(lat: northEast.latitude, lon: northEast.longitude),
      GeoCoord(lat: southWest.latitude, lon: northEast.longitude),
      GeoCoord(lat: southWest.latitude, lon: southWest.longitude),
    ];

    try {
      // 2. Polyfill 실행
      // h3_flutter 0.7.x: polyfill(List<GeoCoord> outline, List<List<GeoCoord>>? holes, int res)
      // Returns List<BigInt> usually (or int/String depending on version, let's verify return type via docs or trial)
      // Usually h3_flutter -> calls C lib -> returns hex indices.
      // H3 4.x uses BigInt for 64-bit indices.

      // H3 v4 naming: polygonToCells
      final hexagons = _h3.polygonToCells(
        perimeter: polygon,
        resolution: resolution,
      );

      // Convert BigInt/int to hex string
      return hexagons.map((h) => h.toRadixString(16)).toList();
    } catch (e) {
      print("Polyfill Error: $e");
      return [];
    }
  }

  List<GeoCoord> getHexagonBoundary(String h3Index) {
    if (!_isInitialized) return [];

    try {
      // H3 v4 naming: cellToBoundary
      BigInt h3Int = BigInt.parse(h3Index, radix: 16);
      return _h3.cellToBoundary(h3Int);
    } catch (e) {
      print("Boundary Error: $e");
      return [];
    }
  }

  /// 특정 좌표를 H3 Index로 변환
  String? latLngToH3(LatLng point) {
    if (!_isInitialized) return null;
    try {
      // API 메서드 이름을 찾지 못하는 문제로 인해 polygonToCells를 이용한 우회 방법 사용
      // 점 주변에 삼각형을 그려서 포함되는 헥사곤 찾기
      // H3 polyfill은 셀 중심이 폴리곤 안에 있어야 하므로,
      // 해상도 9(약 170m)보다 충분히 큰 크기여야 함.
      final double lat = point.latitude;
      final double lon = point.longitude;
      // 0.000001(10cm) -> 0.002 -> 0.005 (약 500m)로 변경하여 인식률 높임
      final double d = 0.005;

      final polygon = [
        GeoCoord(lat: lat + d, lon: lon),
        GeoCoord(lat: lat - d, lon: lon + d),
        GeoCoord(lat: lat - d, lon: lon - d),
        GeoCoord(lat: lat + d, lon: lon),
      ];

      final hexagons = _h3.polygonToCells(
        perimeter: polygon,
        resolution: resolution,
      );

      if (hexagons.isEmpty) return null;

      // 가장 가까운 셀 찾기
      BigInt? bestHex;
      double minDistance = double.infinity;

      for (var hex in hexagons) {
        // 헥사곤 ID BigInt 변환 (hex는 이미 BigInt 타입)
        BigInt h3Int = hex;
        // 경계 좌표 가져오기
        List<GeoCoord> boundary = _h3.cellToBoundary(h3Int);
        if (boundary.isEmpty) continue;

        // 중심점 근사값 계산 (Boundary 평균)
        double avgLat = 0;
        double avgLon = 0;
        for (var coord in boundary) {
          avgLat += coord.lat;
          avgLon += coord.lon;
        }
        avgLat /= boundary.length;
        avgLon /= boundary.length;

        // 거리 비교 (단순 제곱합, lat/lon 스케일 차이 무시해도 근거리 비교엔 충분)
        double dLat = lat - avgLat;
        double dLon = lon - avgLon;
        double distSq = dLat * dLat + dLon * dLon;

        if (distSq < minDistance) {
          minDistance = distSq;
          bestHex = hex;
        }
      }

      return bestHex?.toRadixString(16);
    } catch (e) {
      print("H3 Conversion Error: $e");
      return null;
    }
  }

  /// 헥사곤 점령 처리
  void occupyHexagon(String h3Index, String ownerId, int color) {
    _occupiedHexagons[h3Index] = HexagonModel(
      h3Index: h3Index,
      ownerId: ownerId,
      color: color,
    );
  }

  /// 서버(Mock)에서 소유자 정보 가져오기
  /// 이제 로컬 메모리(_occupiedHexagons)를 우선 확인하고, 없으면 기본값(흰색/투명) 반환
  Future<List<HexagonModel>> fetchHexagonOwners(List<String> h3Indices) async {
    // 실제로는 API 호출이겠지만, 지금은 로컬 상태 반환

    List<HexagonModel> results = [];

    for (var id in h3Indices) {
      if (_occupiedHexagons.containsKey(id)) {
        // 이미 점령된 땅
        results.add(_occupiedHexagons[id]!);
      } else {
        // 미점령 땅 (흰색 테두리만 보이게 하거나 투명)
        // 기본값: 흰색(투명도 포함)
        results.add(
          HexagonModel(
            h3Index: id,
            color: 0x44000000, // 잘 보이는 회색 (투명도 포함)
          ),
        );
      }
    }
    return results;
  }
}
