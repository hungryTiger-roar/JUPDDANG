import 'package:h3_flutter/h3_flutter.dart';
import 'package:h3_common/h3_common.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';
import '../models/hexagon.dart';
import 'auth_service.dart';

class LocationH3Service {
  late final H3 _h3;
  final int resolution = 9;
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AuthService.apiBase,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  static final LocationH3Service _instance = LocationH3Service._internal();
  factory LocationH3Service() => _instance;
  LocationH3Service._internal();

  bool _isInitialized = false;

  // 로컬 점령 정보 저장소 (H3 Index -> HexagonModel)
  final Map<String, HexagonModel> _occupiedHexagons = {};

  // 점령 진행도 관련 상태
  String? _currentTrackingH3;
  double _accumulatedDistance = 0.0;
  Position? _lastPosition;

  // 현재 헥사곤의 점령 진행도 (0.0 ~ 1.0)
  double get occupyProgress => (_accumulatedDistance / 100.0).clamp(0.0, 1.0);
  String? get currentH3Index => _currentTrackingH3;

  Future<void> init() async {
    if (_isInitialized) return;
    _h3 = const H3Factory().load();
    _isInitialized = true;
  }

  Stream<Position> getPositionStream() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 3,
    );
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  List<String> getHexagonsInBounds(LatLng southWest, LatLng northEast) {
    if (!_isInitialized) return [];

    final polygon = [
      GeoCoord(lat: southWest.latitude, lon: southWest.longitude),
      GeoCoord(lat: northEast.latitude, lon: southWest.longitude),
      GeoCoord(lat: northEast.latitude, lon: northEast.longitude),
      GeoCoord(lat: southWest.latitude, lon: northEast.longitude),
      GeoCoord(lat: southWest.latitude, lon: southWest.longitude),
    ];

    try {
      final hexagons = _h3.polygonToCells(
        perimeter: polygon,
        resolution: resolution,
      );
      return hexagons.map((h) => h.toRadixString(16)).toList();
    } catch (e) {
      // print("Polyfill Error: $e");
      return [];
    }
  }

  List<GeoCoord> getHexagonBoundary(String h3Index) {
    if (!_isInitialized) return [];
    try {
      BigInt h3Int = BigInt.parse(h3Index, radix: 16);
      return _h3.cellToBoundary(h3Int);
    } catch (e) {
      return [];
    }
  }

  String? latLngToH3(LatLng point) {
    if (!_isInitialized) return null;
    try {
      final double lat = point.latitude;
      final double lon = point.longitude;
      final double d = 0.002;

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

      BigInt? bestHex;
      double minDistance = double.infinity;

      for (var hex in hexagons) {
        BigInt h3Int = hex;
        List<GeoCoord> boundary = _h3.cellToBoundary(h3Int);
        if (boundary.isEmpty) continue;

        double avgLat = 0, avgLon = 0;
        for (var coord in boundary) {
          avgLat += coord.lat;
          avgLon += coord.lon;
        }
        avgLat /= boundary.length;
        avgLon /= boundary.length;

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
      return null;
    }
  }

  /// 헥사곤 점령 처리 (복구됨)
  void occupyHexagon(String h3Index, String ownerId, int color) {
    _occupiedHexagons[h3Index] = HexagonModel(
      h3Index: h3Index,
      ownerId: ownerId,
      color: color,
    );
  }

  /// 위치 업데이트 및 이동 거리 계산 (점령 로직)
  String? updatePosition(Position pos) {
    if (!_isInitialized) return null;

    String? h3Index = latLngToH3(LatLng(pos.latitude, pos.longitude));
    if (h3Index == null) return null;

    if (_currentTrackingH3 != h3Index) {
      _currentTrackingH3 = h3Index;
      _accumulatedDistance = 0.0;
      _lastPosition = pos;
    } else {
      if (_lastPosition != null) {
        double dist = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          pos.latitude,
          pos.longitude,
        );
        if (dist < 100.0) {
          _accumulatedDistance += dist;
        }
      }
      _lastPosition = pos;

      // 100m 달성 시 점령 처리 (로컬)
      if (_accumulatedDistance >= 100.0) {
        // 내가 점령한 것으로 처리
        // 만약 이미 내 땅이면 굳이? 그래도 갱신.
        String myId = AuthService.userId ?? "me";

        if (!_occupiedHexagons.containsKey(h3Index) ||
            _occupiedHexagons[h3Index]!.ownerId != myId) {
          int colorInt = 0x66FF0000; // 기본값 (빨강 반투명)

          if (AuthService.userColor != null) {
            // 사용자의 고유 색상에 투명도(0x66) 적용
            colorInt = (AuthService.userColor! & 0x00FFFFFF) | 0x66000000;
          }

          occupyHexagon(h3Index, myId, colorInt);
        }
      }
    }
    return h3Index;
  }

  /// 서버 API 사용하여 헥사곤 상태 조회
  Future<List<HexagonModel>> fetchHexagonOwners(List<String> h3Indices) async {
    List<HexagonModel> results = [];
    final token = AuthService.accessToken;
    final userId = AuthService.userId ?? "guest";

    if (token == null) {
      // 로그인 안 된 경우 로컬 맵만 반환
      for (var id in h3Indices) {
        if (_occupiedHexagons.containsKey(id)) {
          results.add(_occupiedHexagons[id]!);
        } else {
          results.add(HexagonModel(h3Index: id, color: 0x00000000));
        }
      }
      return results;
    }

    // API 호출 (병렬)
    List<Future> futures = [];
    for (var index in h3Indices) {
      // 로컬 화면 갱신을 위해 API 호출
      // (로컬에 이미 100m 달성으로 점령된게 있어도, 서버 상태 확인은 필요할 수 있음.
      // 하지만 여기서는 로컬 점령(방금 내가 먹은거)을 유지하는게 UX상 좋음)

      if (_occupiedHexagons.containsKey(index)) {
        // 내가 방금 점령했거나 로컬 캐시된 내용
        results.add(_occupiedHexagons[index]!);
        continue;
      }

      futures.add(() async {
        try {
          final response = await _dio.get(
            '/v1/plogging/grid/status',
            queryParameters: {'h3Index': index},
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                // userId 헤더 필수 (Backend GridStatusController line 25)
                'userId': userId,
              },
            ),
          );

          if (response.statusCode == 200) {
            final data = response.data;
            if (data != null) {
              bool isClaimable = data['isClaimable'] ?? true;
              if (!isClaimable) {
                // 이미 점령됨 (남이 먹었거나 내가 예전에 먹었거나)
                final model = HexagonModel(
                  h3Index: index,
                  color: 0x66888888, // 회색 (남의 땅)
                  ownerId: "occupied",
                );
                // 캐시 생략 or 저장 (여기서는 결과 리스트에만 추가)
                results.add(model);
              } else {
                // 빈 땅
                results.add(HexagonModel(h3Index: index, color: 0x00000000));
              }
            }
          }
        } catch (e) {
          // 에러 시 빈 땅 취급
          results.add(HexagonModel(h3Index: index, color: 0x00000000));
        }
      }());
    }

    await Future.wait(futures);
    return results;
  }
}
