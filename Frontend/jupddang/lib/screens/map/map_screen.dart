import 'dart:async';
import 'package:flutter/foundation.dart'; // kIsWeb 사용을 위해 추가
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/location_h3_service.dart';
import '../../models/hexagon.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LocationH3Service _h3Service = LocationH3Service();

  List<Polygon> _hexagons = [];
  // 초기 위치를 서울 시청으로 기본 설정 (GPS 수신 전에도 표시)
  LatLng? _currentPosition = const LatLng(37.5665, 126.9780);
  StreamSubscription<Position>? _positionStream;
  Timer? _debounceTimer;
  bool _isLoading = false;

  // 점령 로직 관련 변수
  String? _currentH3Index;
  Timer? _stayTimer;
  bool _isManualMode = false;
  double _occupyProgress = 0.0; // 0.0 ~ 1.0
  List<HexagonModel> _visibleHexagonModels = [];

  // 헥사곤 표시 최소 줌 레벨
  static const double _minZoomLevel = 15.0;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _debounceTimer?.cancel();
    _stayTimer?.cancel(); // 타이머 해제
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    // H3 라이브러리 초기화 (비동기)
    await _h3Service.init();

    bool hasPermission = await _h3Service.checkPermission();
    if (hasPermission) {
      _positionStream = _h3Service.getPositionStream().listen((
        Position position,
      ) {
        // 수동 모드일 때는 GPS 업데이트 무시
        if (_isManualMode) return;

        _updateCurrentPosition(LatLng(position.latitude, position.longitude));
      });
    }
  }

  // 위치 업데이트 및 점령 로직 처리 (GPS/수동 공통)
  void _updateCurrentPosition(LatLng newPos) {
    if (!mounted) return;

    setState(() {
      _currentPosition = newPos;
    });

    // 처음 위치 잡혔을 때 지도로 이동
    if (_hexagons.isEmpty) {
      _mapController.move(_currentPosition!, 16.0);
    }

    // --- 점령 로직 ---
    final h3Index = _h3Service.latLngToH3(newPos);

    if (h3Index != null) {
      if (_currentH3Index != h3Index) {
        // 새로운 셀 진입
        _currentH3Index = h3Index;
        _startOccupationTimer();
      }
    } else {
      // 변환 실패 시 리셋
      _stopOccupationTimer();
      _currentH3Index = null;
    }
  }

  void _startOccupationTimer() {
    _stopOccupationTimer();
    _occupyProgress = 0.0;

    // 1초마다 갱신 (60초 = 100%)
    _stayTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _occupyProgress += (1.0 / 60.0);

        if (_occupyProgress >= 1.0) {
          _occupyProgress = 1.0;
          _stopOccupationTimer();
          if (_currentH3Index != null) _conquerHexagon(_currentH3Index!);
        }

        // 진행률에 따라 색상 갱신
        _generatePolygons();
      });
    });
  }

  void _stopOccupationTimer() {
    _stayTimer?.cancel();
    _stayTimer = null;
    _occupyProgress = 0.0;
    if (mounted) {
      setState(() {
        _generatePolygons();
      });
    }
  }

  void _conquerHexagon(String h3Index) {
    // 점령 처리
    // debugPrint("헥사곤 점령 성공! $h3Index");

    // 내 땅(파란색)으로 등록
    _h3Service.occupyHexagon(h3Index, "my_user_id", 0x990000FF);

    // UI 갱신 (현재 보고 있는 영역 다시 로드)
    _updateHexagons(_mapController.camera.visibleBounds);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("땅을 점령했습니다! (1분 체류 달성)")));
  }

  // 수동 이동 함수
  void _moveManually(double latDelta, double lngDelta) {
    if (_currentPosition == null) return;

    _isManualMode = true; // 수동 모드 활성화 (GPS 무시)

    final newPos = LatLng(
      _currentPosition!.latitude + latDelta,
      _currentPosition!.longitude + lngDelta,
    );

    _updateCurrentPosition(newPos);
    _mapController.move(newPos, _mapController.camera.zoom);
  }

  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    // 줌 레벨 체크
    if (camera.zoom < _minZoomLevel) {
      if (_hexagons.isNotEmpty) {
        setState(() {
          _hexagons = [];
        });
      }
      return;
    }

    // Debounce: 카메라 이동 멈추고 0.5초 뒤 연산
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _updateHexagons(camera.visibleBounds);
    });
  }

  Future<void> _updateHexagons(LatLngBounds bounds) async {
    if (!mounted) return;

    // 1. 화면 영역 내 H3 ID 계산
    final List<String> h3Indices = _h3Service.getHexagonsInBounds(
      bounds.southWest,
      bounds.northEast,
    );

    print("지도 영역 내 헥사곤 개수: ${h3Indices.length}");

    if (h3Indices.isEmpty) return;

    // 2. 서버(Mock)에서 소유자 정보 가져오기
    // 실제로는 계산된 ID 리스트를 보냄
    final owners = await _h3Service.fetchHexagonOwners(h3Indices);

    if (!mounted) return;

    // 3. Polygon 생성 (별도 함수로 분리)
    _visibleHexagonModels = owners;
    _generatePolygons();
  }

  void _generatePolygons() {
    final newPolygons = _visibleHexagonModels.map((model) {
      final boundary = _h3Service.getHexagonBoundary(model.h3Index);
      final points = boundary
          .map((coord) => LatLng(coord.lat, coord.lon))
          .toList();

      Color fillColor = Color(model.color);

      // 현재 밟고 있는 땅이면 진행률에 따라 색상 오버레이
      if (model.h3Index == _currentH3Index && _occupyProgress > 0) {
        // 이미 내 땅이면 굳이? -> 그래도 점령 유지 보너스 느낌으로 보여줄 수 있음.
        // 여기서는 미점령(흰색/투명) -> 파란색으로 차오르는 효과

        // 투명(0x33FFFFFF) -> 파랑(0x990000FF)
        // 보간: 기본색과 타겟색(파랑) 사이를 progress만큼 섞음
        // 단, 기존 색이 이미 파랑이면 의미 없음.

        // 점령 중 색상: 파란색
        final targetColor = Colors.blueAccent.withOpacity(0.6);
        fillColor =
            Color.lerp(fillColor, targetColor, _occupyProgress) ?? fillColor;
      }

      return Polygon(
        points: points,
        color: fillColor,
        borderColor: Colors.black.withOpacity(0.2),
        borderStrokeWidth: 1.0,
      );
    }).toList();

    setState(() {
      _hexagons = newPolygons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jupddang Main'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (_currentPosition != null) {
                _mapController.move(_currentPosition!, 16.0);
              }
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const LatLng(37.5665, 126.9780), // 서울 시청
          initialZoom: 16.0,
          minZoom: 5.0,
          maxZoom: 19.0,
          onPositionChanged: _onMapPositionChanged,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.ssafy.jupddang.jupddang',
          ),
          PolygonLayer(polygons: _hexagons),
          if (_currentPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentPosition!,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.directions_walk,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                ),
                // 점령 진행률 텍스트 (항상 표시, null이면 대기중)
                if (_currentH3Index != null)
                  Marker(
                    point: _currentPosition!,
                    width: 100,
                    height: 40,
                    child: Transform.translate(
                      offset: const Offset(0, -45),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _occupyProgress > 0
                                ? Colors.blueAccent
                                : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _occupyProgress > 0
                              ? "점령중 ${(_occupyProgress * 100).toInt()}%"
                              : "진입 완료",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

          // 상단 상태 정보 패널 (디버깅용)
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Card(
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("현재 위치: ${_currentH3Index ?? '인식 불가'}"),
                    LinearProgressIndicator(value: _occupyProgress),
                    Text("진행률: ${(_occupyProgress * 100).toStringAsFixed(1)}%"),
                  ],
                ),
              ),
            ),
          ),

          // 수동 조작 컨트롤러 (웹 또는 디버그 모드에서 표시)
          if (kIsWeb || kDebugMode)
            Positioned(
              bottom: 30,
              right: 20,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: "move_up",
                    onPressed: () => _moveManually(0.0002, 0),
                    child: const Icon(Icons.arrow_upward),
                  ),
                  Row(
                    children: [
                      FloatingActionButton.small(
                        heroTag: "move_left",
                        onPressed: () => _moveManually(0, -0.0002),
                        child: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 40), // 가운데 비움
                      FloatingActionButton.small(
                        heroTag: "move_right",
                        onPressed: () => _moveManually(0, 0.0002),
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  FloatingActionButton.small(
                    heroTag: "move_down",
                    onPressed: () => _moveManually(-0.0002, 0),
                    child: const Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
