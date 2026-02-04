import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import '../../services/location_h3_service.dart';
import '../../services/auth_service.dart';
import '../../models/hexagon.dart';
import '../../widgets/pixel_button.dart';
import '../../widgets/pixel_character.dart';
import '../../models/party_models.dart';
import '../../models/plogging_models.dart';
import '../../services/party_service.dart';
import '../../services/party_socket_service.dart';
import 'package:gal/gal.dart';

enum PloggingPhase { idle, plogging, paused, summary }

class MapScreen extends StatefulWidget {
  final int? partyId;
  final Function(dynamic)? onPloggingComplete; // 🎯 추가

  const MapScreen({
    super.key,
    this.partyId,
    this.onPloggingComplete, // 🎯 추가
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final GlobalKey _mapRepaintKey = GlobalKey();
  final LocationH3Service _h3Service = LocationH3Service();

  List<Polygon> _hexagons = [];
  LatLng? _currentPosition;
  bool _isInitialCenterSet = false;
  StreamSubscription<Position>? _positionStream;
  Timer? _debounceTimer;
  bool _isLoading = false;

  final PartySocketService _socketService = PartySocketService();
  final PartyService _partyService = PartyService();
  Party? _party;
  Timer? _partyPollTimer;

  String? _currentH3Index;
  Timer? _stayTimer;
  PloggingPhase _phase = PloggingPhase.idle;
  bool _showCustomizer = false;
  double _occupyProgress = 0.0;
  List<HexagonModel> _visibleHexagonModels = [];

  final ImagePicker _picker = ImagePicker();
  XFile? _beforeImage;
  XFile? _afterImage;
  XFile? _mapImage;

  String? _startAddress;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _recordTitleController = TextEditingController();

  Color _selectedGridColor = const Color(0xFF46A140);
  double _gridOpacity = 0.5;
  final List<Color> _paletteColors = [
    const Color(0xFF46A140),
    const Color(0xFF3B82F6),
    const Color(0xFFEF4444),
    const Color(0xFF8B5CF6),
    const Color(0xFFF59E0B),
    const Color(0xFF6B7280),
  ];

  Stopwatch _sessionStopwatch = Stopwatch();
  double _totalDistance = 0.0;
  List<LatLng> _pathPoints = [];
  int _coinsGained = 0;
  Timer? _statsTimer;
  bool _isCapturingMap = false;

  static const double _minZoomLevel = 15.0;

  PartyMemberLocation? _leaderLocation;
  int get _displayElapsedSeconds {
    if (widget.partyId != null &&
        (_party?.isCurrentUserLeader ?? false) == false &&
        _leaderLocation != null) {
      return _leaderLocation!.elapsedTime;
    }
    return _sessionStopwatch.elapsed.inSeconds;
  }

  double get _displayTotalDistanceMeters {
    if (widget.partyId != null &&
        (_party?.isCurrentUserLeader ?? false) == false &&
        _leaderLocation != null) {
      return _leaderLocation!.totalDistance;
    }
    return _totalDistance;
  }

  int get _displayScore {

    if (widget.partyId != null &&
        (_party?.isCurrentUserLeader ?? false) == false &&
        _leaderLocation != null) {
      return _leaderLocation!.score;
    }

    return _coinsGained;
  }

  @override
  void initState() {
    super.initState();
    _initLocation();

    if (widget.partyId != null) {
      _loadPartyInfo();

      _socketService.onStatusUpdated = (status) {
        if (!mounted) return;
        if (status == 'COMPLETED' && _phase != PloggingPhase.summary) {
          _finishPlogging();
        } else if (status == 'IN_PROGRESS' && _phase == PloggingPhase.idle) {
          _startPlogging();
        }
      };

      _socketService.onLeaderLocationUpdated = (leaderLocation) {
        if (!mounted) return;

        print('🗺️ 맵 화면에서 파티장 위치 수신!');
        print('파티장 H3: ${leaderLocation.currentH3Index}');
        print('점령 진행도: ${(leaderLocation.occupyProgress * 100).toInt()}%');

        setState(() {
          _leaderLocation = leaderLocation;

          if (!(_party?.isCurrentUserLeader ?? false)) {
            _occupyProgress = leaderLocation.occupyProgress;
            _currentH3Index = leaderLocation.currentH3Index;

            // 🎯 파티원도 hexagon 업데이트 (점령된 그리드 반영)
            _updateHexagons(_mapController.camera.visibleBounds);
          }
        });
      };

      _socketService.connect(widget.partyId!);

      _partyPollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
        _pollPartyData();
      });
    }
  }

  Future<void> _pollPartyData() async {
    if (!mounted || widget.partyId == null) return;

    try {
      final party = await _partyService.getPartyDetail(widget.partyId!);
      if (!mounted) return;

      setState(() => _party = party);

      if (!(party.isCurrentUserLeader)) {
        if (party.status == 'IN_PROGRESS' && _phase == PloggingPhase.idle) {
          _startPlogging();
        } else if (party.status == 'COMPLETED' &&
            _phase != PloggingPhase.summary) {
          _finishPlogging();
        }

        if (_phase == PloggingPhase.plogging && party.status == 'IN_PROGRESS') {
          try {
            final activities = await _partyService.getActivityStatus(
              widget.partyId!,
            );
            final leaderActivity = activities.firstWhere(
                  (a) => a.userId == party.leaderId,
              orElse: () => activities.isNotEmpty
                  ? activities.first
                  : PartyActivity(
                userId: '',
                totalDistance: 0,
                elapsedTime: 0,
                isCompleted: false,
              ),
            );
            if (leaderActivity.isCompleted && _phase != PloggingPhase.summary) {
              _finishPlogging();
            }
          } catch (e) {
            // 활동 조회 실패 무시
          }
        }
      }
    } catch (e) {
      debugPrint("Party poll error: $e");
    }
  }

  Future<void> _loadPartyInfo() async {
    try {
      final p = await _partyService.getPartyDetail(widget.partyId!);
      if (!mounted) return;

      setState(() => _party = p);
    } catch (e) {
      debugPrint("Party load error: $e");
    }
  }

  @override
  void dispose() {
    _partyPollTimer?.cancel();
    if (widget.partyId != null) {
      _socketService.disconnect();
    }
    _positionStream?.cancel();
    _debounceTimer?.cancel();
    _stayTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    await _h3Service.init();
    bool hasPermission = await _h3Service.checkPermission();
    if (hasPermission) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _updateCurrentPosition(LatLng(position.latitude, position.longitude));
      } catch (e) {
        debugPrint("Initial location error: $e");
      }

      _positionStream = _h3Service.getPositionStream().listen((
          Position position,
          ) {
        _updateCurrentPosition(LatLng(position.latitude, position.longitude));
      });
    }
  }

  void _centerToCurrentLocation() {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 16.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("현위치를 찾을 수 없습니다. GPS를 확인해주세요.")),
      );
    }
  }

  void _updateCurrentPosition(LatLng newPos) {
    if (!mounted) return;

    if (_currentPosition != null) {
      const double lerpFactor = 0.2;
      newPos = LatLng(
        _currentPosition!.latitude +
            (newPos.latitude - _currentPosition!.latitude) * lerpFactor,
        _currentPosition!.longitude +
            (newPos.longitude - _currentPosition!.longitude) * lerpFactor,
      );

      final double distance = const Distance().distance(
        _currentPosition!,
        newPos,
      );
      if (distance < 0.5 && _phase != PloggingPhase.plogging) {
        return;
      }
    }

    if (_isPlogging && _currentPosition != null) {
      final distance = const Distance().distance(_currentPosition!, newPos);
      _totalDistance += distance;
      _pathPoints.add(newPos);
    }

    _currentPosition = newPos;

    if (!_isInitialCenterSet &&
        _currentPosition != null &&
        _mapController.camera.zoom > 0) {
      _mapController.move(_currentPosition!, 16.0);
      _isInitialCenterSet = true;
    }

    // 🎯 H3 Index 업데이트 로직 (파티장 또는 솔로만)
    if (widget.partyId == null || (_party?.isCurrentUserLeader ?? false)) {
      final h3Index = _h3Service.latLngToH3(newPos);
      if (h3Index != null) {
        if (_currentH3Index != h3Index) {
          // 🎯 H3 Index가 변경되면 진행도 초기화
          _currentH3Index = h3Index;
          _occupyProgress = 0.0;  // ✅ 진행도 초기화

          if (_phase == PloggingPhase.plogging) {
            _startOccupationTimer();
          }
        }
      } else {
        _stopOccupationTimer();
        _currentH3Index = null;
        _occupyProgress = 0.0;  // ✅ 진행도 초기화
      }
    }

    // 🎯 파티장인 경우 위치 전송
    if (widget.partyId != null && (_party?.isCurrentUserLeader ?? false)) {
      final locationRequest = LocationRequest(
        lat: newPos.latitude,
        lon: newPos.longitude,
        partyId: widget.partyId!,
        elapsedTime: _sessionStopwatch.elapsed.inSeconds,
        totalDistance: _totalDistance,
        score: _coinsGained,
        currentH3Index: _currentH3Index,
        occupyProgress: _occupyProgress,
      );
      _socketService.sendLocation(widget.partyId!, locationRequest);
    }

    setState(() {});
  }

  bool get _isPlogging =>
      _phase == PloggingPhase.plogging || _phase == PloggingPhase.paused;

  void _startPlogging() async {
    // 파티장인 경우 서버에 시작 요청
    if (widget.partyId != null && (_party?.isCurrentUserLeader ?? false)) {
      try {
        await _partyService.startParty(widget.partyId!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('파티 시작 실패: $e')),
          );
        }
        return; // 실패 시 플로깅 시작 안 함
      }
    }

    setState(() {
      _phase = PloggingPhase.plogging;
      _showCustomizer = false;
      _sessionStopwatch.start();
      _totalDistance = 0.0;
      _pathPoints = _currentPosition != null ? [_currentPosition!] : [];
      _coinsGained = 0;
      _descriptionController.clear();
      _startAddress = "Fetching address...";
      _statsTimer = Timer.periodic(
        const Duration(seconds: 1),
            (t) {
          _sendLeaderLocationIfNeeded();
          setState(() {});
        },
      );
      if (_currentH3Index != null) _startOccupationTimer();
    });
    _fetchStartAddress();
  }

  Future<void> _fetchStartAddress() async {
    if (_currentPosition == null) return;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _startAddress = "${p.locality} ${p.subLocality} ${p.thoroughfare}";
        });
      }
    } catch (e) {
      setState(() {
        _startAddress = "Address unavailable";
      });
    }
  }

  void _pausePlogging() {
    setState(() {
      _phase = PloggingPhase.paused;
      _sessionStopwatch.stop();
      _stopOccupationTimer();
    });
  }

  void _resumePlogging() {
    setState(() {
      _phase = PloggingPhase.plogging;
      _sessionStopwatch.start();

      // 🎯 파티장 또는 솔로이고, H3 Index가 있으면 타이머 재시작
      if ((widget.partyId == null || (_party?.isCurrentUserLeader ?? false)) &&
          _currentH3Index != null) {
        _startOccupationTimer();
      }
    });
  }

  Future<void> _finishPlogging() async {
    setState(() {
      _phase = PloggingPhase.summary;
      _sessionStopwatch.stop();
      _statsTimer?.cancel();
      _stopOccupationTimer();
    });

    if (widget.partyId != null && !(_party?.isCurrentUserLeader ?? false)) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
    }

    final mapPath = await _captureMapImage();
    if (!mounted) return;
    if (mapPath != null) {
      setState(() {
        _mapImage = XFile(mapPath);
      });
    }
  }

  void _resetPlogging() {
    setState(() {
      _phase = PloggingPhase.idle;
      _sessionStopwatch.reset();
      _beforeImage = null;
      _afterImage = null;
      _mapImage = null;
      _pathPoints = [];
    });
  }

  Future<void> _pickImage(bool isBefore) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isBefore)
          _beforeImage = picked;
        else
          _afterImage = picked;
      });
    }
  }

  Future<String?> _captureMapImage() async {
    if (!mounted) return null;
    final previousCenter = _mapController.camera.center;
    final previousZoom = _mapController.camera.zoom;

    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 16.0);
      await Future.delayed(const Duration(milliseconds: 250));
      await _updateHexagons(_mapController.camera.visibleBounds);
    }
    setState(() {
      _isCapturingMap = true;
    });
    await WidgetsBinding.instance.endOfFrame;
    final renderObject = _mapRepaintKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) {
      if (mounted) {
        setState(() {
          _isCapturingMap = false;
        });
      }
      return null;
    }
    final image = await renderObject.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      if (mounted) {
        setState(() {
          _isCapturingMap = false;
        });
      }
      return null;
    }
    final bytes = byteData.buffer.asUint8List();
    final file =
    File('${Directory.systemTemp.path}/map_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);
    if (mounted) {
      setState(() {
        _isCapturingMap = false;
      });
    }
    if (_currentPosition != null) {
      _mapController.move(previousCenter, previousZoom);
    }
    return file.path;
  }

  Future<void> _pickMapImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _mapImage = picked;
      });
    }
  }

  void _zoomIn() {
    final newZoom = _mapController.camera.zoom + 1;
    _mapController.move(_mapController.camera.center, newZoom);
  }

  void _zoomOut() {
    final newZoom = _mapController.camera.zoom - 1;
    _mapController.move(_mapController.camera.center, newZoom);
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) return;

      await Gal.putImage(photo.path);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('사진이 갤러리에 저장되었습니다')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('사진 저장 실패: $e')));
      }
    }
  }

  void _startOccupationTimer() {
    // 🎯 파티원인 경우 타이머 실행 안 함
    if (widget.partyId != null && !(_party?.isCurrentUserLeader ?? false)) {
      return;  // 파티원은 파티장 데이터만 사용
    }

    // 🎯 기존 타이머가 있으면 취소
    _stopOccupationTimer();

    _stayTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      // 🎯 플로깅 중이 아니면 증가 안 함
      if (_phase != PloggingPhase.plogging) {
        return;
      }

      // 🎯 현재 H3 Index가 없으면 증가 안 함
      if (_currentH3Index == null) {
        return;
      }

      // 🎯 이미 점령된 그리드면 증가 안 함
      final currentModel = _visibleHexagonModels.firstWhere(
            (m) => m.h3Index == _currentH3Index,
        orElse: () => HexagonModel(h3Index: _currentH3Index!, color: 0),
      );

      if (currentModel.ownerId != null) {
        // 이미 점령된 그리드 - 진행도 초기화
        _occupyProgress = 0.0;
        _generatePolygons();
        return;
      }

      // 🎯 여기서만 진행도 증가
      _occupyProgress += (1.0 / 60.0);  // 1분 = 60초

      // 파티장인 경우만 위치 전송
      if (widget.partyId != null && (_party?.isCurrentUserLeader ?? false) && _currentPosition != null) {
        final locationRequest = LocationRequest(
          lat: _currentPosition!.latitude,
          lon: _currentPosition!.longitude,
          partyId: widget.partyId!,
          elapsedTime: _sessionStopwatch.elapsed.inSeconds,
          totalDistance: _totalDistance,
          score: _coinsGained,
          currentH3Index: _currentH3Index,
          occupyProgress: _occupyProgress,
        );
        _socketService.sendLocation(widget.partyId!, locationRequest);
      }

      if (_occupyProgress >= 1.0) {
        _occupyProgress = 1.0;
        _stopOccupationTimer();
        if (_currentH3Index != null) _conquerHexagon(_currentH3Index!);
      }

      _generatePolygons();
    });
  }

  // 파티원은 파티장 데이터, 파티장은 자신 데이터
  double get _displayOccupyProgress {
    if (widget.partyId != null &&
        !(_party?.isCurrentUserLeader ?? false) &&
        _leaderLocation != null) {
      return _leaderLocation!.occupyProgress; // 파티원
    }
    return _occupyProgress; // 파티장
  }

  String? get _displayCurrentH3Index {
    if (widget.partyId != null &&
        !(_party?.isCurrentUserLeader ?? false) &&
        _leaderLocation != null) {
      return _leaderLocation!.currentH3Index; // 파티원
    }
    return _currentH3Index; // 파티장
  }

  void _stopOccupationTimer() {
    _stayTimer?.cancel();
    _stayTimer = null;
    if (mounted) {
      setState(() {
        _generatePolygons();
      });
    }
  }

  void _sendLeaderLocationIfNeeded() {
    if (widget.partyId == null) return;
    if (!(_party?.isCurrentUserLeader ?? false)) return;
    if (_currentPosition == null) return;

    final locationRequest = LocationRequest(
      lat: _currentPosition!.latitude,
      lon: _currentPosition!.longitude,
      partyId: widget.partyId!,
      elapsedTime: _sessionStopwatch.elapsed.inSeconds,
      totalDistance: _totalDistance,
      score: _coinsGained,
      currentH3Index: _currentH3Index,
      occupyProgress: _occupyProgress,
    );
    _socketService.sendLocation(widget.partyId!, locationRequest);
  }

  void _conquerHexagon(String h3Index) {
    _h3Service.occupyHexagon(h3Index, "my_user_id", 0x990000FF);

    // 🎯 점령 완료 후 진행도 초기화
    _occupyProgress = 0.0;
    _coinsGained += 5;  // 점수 추가

    _updateHexagons(_mapController.camera.visibleBounds);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("땅을 점령했습니다! (1분 체류 달성)")));
  }

  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    if (camera.zoom < _minZoomLevel) {
      if (_hexagons.isNotEmpty) {
        setState(() {
          _hexagons = [];
        });
      }
      return;
    }
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _updateHexagons(camera.visibleBounds);
    });
  }

  Future<void> _updateHexagons(LatLngBounds bounds) async {
    if (!mounted) return;

    try {
      if (bounds.southWest.latitude == 0 && bounds.northEast.latitude == 0)
        return;
    } catch (e) {
      return;
    }

    final List<String> h3Indices = _h3Service.getHexagonsInBounds(
      bounds.southWest,
      bounds.northEast,
    );
    if (h3Indices.isEmpty) return;
    final owners = await _h3Service.fetchHexagonOwners(h3Indices);
    if (!mounted) return;
    _visibleHexagonModels = owners;
    _generatePolygons();
  }

  void _generatePolygons() {

    String? targetH3Index = _displayCurrentH3Index;
    double targetProgress = _displayOccupyProgress;

    final newPolygons = _visibleHexagonModels
        .map((model) {
      final boundary = _h3Service.getHexagonBoundary(model.h3Index);
      if (boundary.isEmpty) return null;

      final points = boundary
          .map((coord) => LatLng(coord.lat, coord.lon))
          .toList();

      Color baseColor;
      if (model.ownerId == null) {
        baseColor = Colors.black.withOpacity(0.05 * _gridOpacity);
      } else {
        baseColor = _selectedGridColor.withOpacity(_gridOpacity);
      }

      Color fillColor = baseColor;

      if (model.h3Index == targetH3Index && targetProgress > 0) {
        final targetColor = _selectedGridColor
            .withOpacity(_gridOpacity * 1.5)
            .withAlpha((_gridOpacity * 1.5 * 255).toInt().clamp(0, 255));
        fillColor =
            Color.lerp(fillColor, targetColor, targetProgress) ??
                fillColor;
      }
      return Polygon(
        points: points,
        color: fillColor,
        borderColor: model.h3Index == targetH3Index
            ? Colors.white.withOpacity(0.8)
            : Colors.black.withOpacity(0.4 * _gridOpacity),
        borderStrokeWidth: model.h3Index == targetH3Index ? 3.0 : 2.0,
      );
    })
        .whereType<Polygon>()
        .toList();

    if (mounted) {
      setState(() {
        _hexagons = newPolygons;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              key: _mapRepaintKey,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(37.5665, 126.9780),
                  initialZoom: 16.0,
                  minZoom: 5.0,
                  maxZoom: 19.0,
                  onPositionChanged: _onMapPositionChanged,
                  onMapReady: () {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        _updateHexagons(_mapController.camera.visibleBounds);
                      }
                    });
                  },
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  if (_pathPoints.isNotEmpty && !_isCapturingMap)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _pathPoints.isEmpty
                              ? [const LatLng(0, 0), const LatLng(0, 0)]
                              : _pathPoints,
                          color: _selectedGridColor.withOpacity(0.6),
                          strokeWidth: 5.0,
                          borderColor: Colors.white,
                          borderStrokeWidth: 2.0,
                        ),
                      ],
                    ),
                  PolygonLayer(
                    key: ValueKey('grid_${_selectedGridColor.value}_$_gridOpacity'),
                    polygons: _hexagons,
                  ),
                  if (_currentPosition != null)
                    MarkerLayer(
                      markers: [
                        // 1. 내 캐릭터
                        Marker(
                          point: _currentPosition!,
                          width: 48,
                          height: 48,
                          child: PixelCharacter(
                            size: 48,
                            color: _selectedGridColor,
                            isMoving: _phase == PloggingPhase.plogging,
                          ),
                        ),

                        // 2. 파티장 캐릭터 (파티원인 경우만)
                        if (_leaderLocation != null && !(_party?.isCurrentUserLeader ?? false))
                          Marker(
                            point: LatLng(_leaderLocation!.lat, _leaderLocation!.lon),
                            width: 48,
                            height: 48,
                            child: Column(
                              children: [
                                const Icon(Icons.stars, color: Colors.amber, size: 20),
                                PixelCharacter(
                                  size: 32,
                                  color: Colors.amber,
                                  isMoving: true,
                                ),
                              ],
                            ),
                          ),

                        // 3. 상태 라벨 (조건부)
                        if (!_isCapturingMap && _shouldShowStatusLabel())
                          Marker(
                            point: _getStatusLabelPosition(),
                            width: 120,
                            height: 50,
                            child: Transform.translate(
                              offset: const Offset(0, -65),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                    color: _getStatusColor(),
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  _getStatusLabel(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (_isPlogging)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  border: Border.all(color: _selectedGridColor, width: 3),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54, offset: Offset(4, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      Pixel.clock,
                      _formatDuration(Duration(seconds: _displayElapsedSeconds)),
                      "TIME",
                    ),
                    _buildStatColumn(
                      Pixel.user,
                      "${(_displayTotalDistanceMeters / 1000).toStringAsFixed(2)}km",
                      "DIST",
                    ),
                    _buildStatColumn(
                      Pixel.coin,
                      "$_displayScore",
                      "SCORE",
                    ),
                  ],
                ),
              ),
            ),

          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: _isPlogging ? Colors.black : Colors.transparent,
                border: _isPlogging
                    ? Border.all(color: Colors.white24, width: 2.0)
                    : null,
                boxShadow: _isPlogging
                    ? const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                ]
                    : null,
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  if (_isPlogging) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 8,
                      child: LinearProgressIndicator(
                        value: _displayOccupyProgress,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(_selectedGridColor),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_phase == PloggingPhase.idle)
            Positioned(
              left: 20,
              top: 60,
              child: _showCustomizer
                  ? _buildMapCustomizer()
                  : _manualMoveButton(
                Pixel.paintbucket,
                "palette_toggle",
                    () => setState(() => _showCustomizer = true),
              ),
            ),

          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              children: [
                _manualMoveButton(Pixel.plus, "zoom_in", _zoomIn),
                const SizedBox(height: 12),
                _manualMoveButton(Pixel.minus, "zoom_out", _zoomOut),
                const SizedBox(height: 24),
                _manualMoveButton(
                  Pixel.gps,
                  "my_location",
                  _centerToCurrentLocation,
                ),
                if (_isPlogging) ...[
                  const SizedBox(height: 24),
                  _manualMoveButton(Pixel.camera, "take_photo", _takePhoto),
                ],
              ],
            ),
          ),

          if (widget.partyId == null || (_party?.isCurrentUserLeader ?? false))
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildPloggingControls(),
                ),
              ),
            ),

          if (_phase == PloggingPhase.summary) _buildSummaryOverlay(),
        ],
      ),
    );
  }

  Widget _buildPloggingControls() {
    if (_phase == PloggingPhase.idle) {
      return SizedBox(
        width: 200,
        child: PixelButton(
          text: "START JUPDDANG",
          isGreen: false,
          color: _selectedGridColor,
          onPressed: _startPlogging,
        ),
      );
    } else if (_phase == PloggingPhase.plogging) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 140,
            child: PixelButton(
              text: "PAUSE",
              isGreen: false,
              color: _selectedGridColor,
              onPressed: _pausePlogging,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 140,
            child: PixelButton(
              text: "FINISH",
              isGreen: false,
              color: _selectedGridColor,
              onPressed: _finishPlogging,
            ),
          ),
        ],
      );
    } else if (_phase == PloggingPhase.paused) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 140,
            child: PixelButton(
              text: "RESUME",
              isGreen: false,
              color: _selectedGridColor,
              onPressed: _resumePlogging,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 140,
            child: PixelButton(
              text: "FINISH",
              isGreen: false,
              color: _selectedGridColor,
              onPressed: _finishPlogging,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSummaryOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(8, 8)),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "SESSION REVIEW",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(
                        Pixel.clock,
                        _formatDuration(Duration(seconds: _displayElapsedSeconds)),
                        "TIME",
                      ),
                      _buildStatColumn(
                        Pixel.user,
                        "${(_displayTotalDistanceMeters / 1000).toStringAsFixed(2)}km",
                        "DIST",
                      ),
                      _buildStatColumn(
                        Pixel.coin,
                        "$_displayScore",
                        "SCORE",
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (_startAddress != null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Icon(Pixel.gps, size: 14, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "START: $_startAddress",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CONTENT",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: "오늘의 줍땅은 어땠나요?",
                      hintStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                      fillColor: Colors.black.withOpacity(0.05),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "MAP PHOTO",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPhotoSlot(
                          "MAP",
                          _mapImage,
                              () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "BEFORE / AFTER PHOTOS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPhotoSlot(
                          "BEFORE",
                          _beforeImage,
                              () => _pickImage(true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPhotoSlot(
                          "AFTER",
                          _afterImage,
                              () => _pickImage(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "RECORD NAME",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _recordTitleController,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: "ex) 한강 플로깅",
                      hintStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                      fillColor: Colors.black.withOpacity(0.05),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PixelButton(
                    text: "PUBLISH RECORD",
                    isGreen: false,
                    color: _selectedGridColor,
                    onPressed: () async {
                      if (AuthService.accessToken == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("로그인 회원만 기록을 저장할 수 있습니다."),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      // ✅ _mapImage가 없으면 에러 (이미 _finishPlogging에서 캡처했어야 함)
                      if (_mapImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("맵 이미지 생성 중입니다. 잠시 후 다시 시도해주세요.")),
                        );
                        return;
                      }

                      if (_beforeImage == null || _afterImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Before/After 사진을 선택해주세요.")),
                        );
                        return;
                      }

                      if (_recordTitleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("기록 제목을 입력해주세요.")),
                        );
                        return;
                      }

                      // 🎯 로딩 표시
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF17C964),
                          ),
                        ),
                      );

                      final request = PloggingEndRequest(
                        distance: _totalDistance / 1000.0,
                        content: _descriptionController.text.trim(),
                        times: _sessionStopwatch.elapsed.inSeconds,
                        endTime: _formatEndTime(DateTime.now()),
                        partyId: widget.partyId,
                        recordTitle: _recordTitleController.text.trim().isEmpty
                            ? '플로깅 활동'
                            : _recordTitleController.text.trim(),
                      );

                      // 🎯 기록 업로드 (이미 캡처된 이미지 사용)
                      dynamic response;
                      try {
                        if (widget.partyId != null) {
                          response = await _partyService.completeActivity(
                            widget.partyId!,
                            request,
                            _beforeImage!,
                            _afterImage!,
                            _mapImage!, // ✅ 이미 캡처된 이미지
                          );
                        } else {
                          response = await AuthService().endPlogging(
                            requestData: request,
                            beforeImagePath: _beforeImage!.path,
                            afterImagePath: _afterImage!.path,
                            mapImagePath: _mapImage!.path, // ✅ 이미 캡처된 이미지
                          );
                        }

                        // 🎯 로딩 닫기
                        if (mounted) Navigator.of(context).pop();

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("기록이 업로드되었습니다!")),
                          );
                        }

                        // 🎯 솔로 플로깅인 경우 콜백으로 결과 전달
                        if (widget.partyId == null && response != null && widget.onPloggingComplete != null) {
                          _resetPlogging();
                          widget.onPloggingComplete!(response);
                          return;
                        }

                      } catch (e) {
                        // 🎯 로딩 닫기
                        if (mounted) Navigator.of(context).pop();

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("업로드 실패: $e")),
                          );
                        }
                        return;
                      }

                      _resetPlogging();

                      if (widget.partyId != null && mounted) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () async {
                      if (AuthService.accessToken == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("로그인 후에 임시 저장할 수 있습니다."),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      // 🎯 이미지 유효성 검사 (PUBLISH RECORD와 동일)
                      if (_mapImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("맵 이미지 생성 중입니다. 잠시 후 다시 시도해주세요.")),
                        );
                        return;
                      }

                      // if (_beforeImage == null || _afterImage == null) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text("Before/After 사진을 선택해주세요.")),
                      //   );
                      //   return;
                      // }

                      if (_recordTitleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("기록 제목을 입력해주세요.")),
                        );
                        return;
                      }

                      // 🎯 로딩 표시
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF59E0B),  // 주황색 (임시 저장 색상)
                          ),
                        ),
                      );

                      final trimmedContent = _descriptionController.text.trim();
                      final trimmedTitle = _recordTitleController.text.trim();
                      final distanceKm = _totalDistance / 1000.0;
                      final elapsedSeconds = _sessionStopwatch.elapsed.inSeconds;

                      final hasAnyData = distanceKm > 0 ||
                          elapsedSeconds > 0 ||
                          trimmedContent.isNotEmpty ||
                          trimmedTitle.isNotEmpty;

                      final request = TempPloggingRequest(
                        distance: distanceKm > 0 ? distanceKm : null,
                        content: trimmedContent.isNotEmpty ? trimmedContent : null,
                        times: elapsedSeconds > 0 ? elapsedSeconds : null,
                        endTime: hasAnyData ? _formatEndTime(DateTime.now()) : null,
                        partyId: widget.partyId,
                        recordTitle: trimmedTitle.isNotEmpty ? trimmedTitle : null,
                      );

                      dynamic response;

                      try {
                        // 🎯 임시 저장 API 호출
                        response = await AuthService().savePloggingTemp(
                          requestData: request,
                          beforeImagePath: _beforeImage?.path,
                          afterImagePath: _afterImage?.path,
                          mapImagePath: _mapImage?.path,
                        );

                        // 🎯 로딩 닫기
                        if (mounted) Navigator.of(context).pop();

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("플로깅 기록이 임시 저장되었습니다."),
                              backgroundColor: Color(0xFFF59E0B),  // 주황색
                            ),
                          );
                        }

                        // 🎯 솔로 플로깅인 경우 콜백으로 결과 전달 (PUBLISH RECORD와 동일)
                        // if (widget.partyId == null && response != null && widget.onPloggingComplete != null) {
                        //   _resetPlogging();
                        //   widget.onPloggingComplete!(response);
                        //   return;
                        // }

                        // 🎯 파티 플로깅인 경우 첫 화면으로 이동 (PUBLISH RECORD와 동일)
                        _resetPlogging();

                        if (widget.partyId != null && mounted) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }

                      } catch (e) {
                        // 🎯 로딩 닫기
                        if (mounted) Navigator.of(context).pop();

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("임시 저장 실패: $e")),
                          );
                        }
                        return;
                      }
                    },
                    child: const Text(
                      "SAVE TEMPORARILY",
                      style: TextStyle(color: Colors.orange, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSlot(String label, XFile? file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: file == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Pixel.camera, color: Colors.grey),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          )
              : Image.file(File(file.path), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _manualMoveButton(IconData icon, String tag, VoidCallback onPressed) {
    return FloatingActionButton.small(
      heroTag: tag,
      onPressed: onPressed,
      backgroundColor: Colors.black,
      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildStatColumn(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: _selectedGridColor.withOpacity(0.9), size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 8)),
      ],
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String mm = twoDigits(d.inMinutes.remainder(60));
    String ss = twoDigits(d.inSeconds.remainder(60));
    return "$mm:$ss";
  }

  String _formatEndTime(DateTime dt) {
    final iso = dt.toIso8601String();
    return iso.split('.').first;
  }

  Widget _buildMapCustomizer() {
    return Container(
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(maxWidth: 160),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        border: Border.all(color: _selectedGridColor, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black45, offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "CUSTOMIZE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _showCustomizer = false),
                child: const Icon(Pixel.close, color: Colors.white, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "GRID OPACITY",
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 120,
            height: 20,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 2,
                activeTrackColor: const Color(0xFFF9D698),
                inactiveTrackColor: Colors.white24,
                thumbColor: Colors.white,
              ),
              child: Slider(
                value: _gridOpacity,
                onChanged: (val) {
                  setState(() {
                    _gridOpacity = val;
                    _generatePolygons();
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "COLOR PALETTE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _paletteColors.map((color) {
              final isSelected = _selectedGridColor == color;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGridColor = color;
                    _generatePolygons();
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.black,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: isSelected
                        ? [const BoxShadow(color: Colors.white, blurRadius: 4)]
                        : [],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel() {
    // 파티 플로깅인 경우
    if (widget.partyId != null) {
      if (_party == null) return "로딩 중...";

      if (_party!.isCurrentUserLeader) {
        // 파티장: 자신의 데이터 사용
        if (_currentH3Index == null) return "위치 확인 중";

        final currentModel = _visibleHexagonModels.firstWhere(
              (m) => m.h3Index == _currentH3Index,
          orElse: () => HexagonModel(h3Index: _currentH3Index!, color: 0),
        );

        if (currentModel.ownerId != null) {
          return "플로깅 중!";
        }

        if (_occupyProgress > 0) {
          return "점령 중 ${(_occupyProgress * 100).toInt()}%";
        }

        return "준비";
      } else {
        // 🎯 파티원: 파티장 데이터 사용
        if (_leaderLocation == null || _leaderLocation!.currentH3Index == null) {
          return "파티장 위치 대기 중";
        }

        final targetH3Index = _leaderLocation!.currentH3Index;
        final targetProgress = _leaderLocation!.occupyProgress;

        // 점령 완료 판단: progress가 0이고 이전에 점령 중이었던 경우
        if (targetProgress == 0.0 && targetH3Index != null) {
          // 서버에서 업데이트된 hexagon 정보 확인
          final currentModel = _visibleHexagonModels.firstWhere(
                (m) => m.h3Index == targetH3Index,
            orElse: () => HexagonModel(h3Index: targetH3Index, color: 0),
          );

          // 🎯 이미 점령된 그리드면 "플로깅 중!"
          if (currentModel.ownerId != null) {
            return "플로깅 중!";
          }
        }

        // 점령 진행 중
        if (targetProgress > 0) {
          return "점령 중 ${(targetProgress * 100).toInt()}%";
        }

        return "준비";
      }
    } else {
      // 솔로 플로깅: 자신의 데이터 사용
      if (_currentH3Index == null) return "위치 확인 중";

      final currentModel = _visibleHexagonModels.firstWhere(
            (m) => m.h3Index == _currentH3Index,
        orElse: () => HexagonModel(h3Index: _currentH3Index!, color: 0),
      );

      if (currentModel.ownerId != null) {
        return "플로깅 중!";
      }

      if (_occupyProgress > 0) {
        return "점령 중 ${(_occupyProgress * 100).toInt()}%";
      }

      return "준비";
    }
  }

  bool _shouldShowStatusLabel() {
    // 플로깅 중이 아니면 표시 안 함
    if (_phase != PloggingPhase.plogging) {
      return false;
    }

    if (widget.partyId != null) {
      // 파티 플로깅인 경우
      if (_party?.isCurrentUserLeader ?? false) {
        // 파티장: 자신의 H3 Index가 있어야 함
        return _currentH3Index != null;
      } else {
        // 파티원: 파티장의 H3 Index가 있어야 함
        return _leaderLocation?.currentH3Index != null;
      }
    } else {
      // 솔로 플로깅: 자신의 H3 Index가 있어야 함
      return _currentH3Index != null;
    }
  }

// 🎯 상태 라벨이 표시될 위치
  LatLng _getStatusLabelPosition() {
    if (widget.partyId != null &&
        !(_party?.isCurrentUserLeader ?? false) &&
        _leaderLocation != null) {
      // 파티원: 파티장 위치
      return LatLng(_leaderLocation!.lat, _leaderLocation!.lon);
    } else {
      // 파티장 또는 솔로: 자신의 위치
      return _currentPosition!;
    }
  }

  Color _getStatusColor() {
    // 파티 플로깅인 경우
    if (widget.partyId != null) {
      if (_party == null) return Colors.grey;

      if (_party!.isCurrentUserLeader) {

        // 파티장: 자신의 데이터 사용
        if (_currentH3Index == null) return Colors.grey;

        final currentModel = _visibleHexagonModels.firstWhere(
              (m) => m.h3Index == _currentH3Index,
          orElse: () => HexagonModel(h3Index: _currentH3Index!, color: 0),
        );

        if (currentModel.ownerId != null || _occupyProgress > 0) {
          return _selectedGridColor;
        }
      } else {
        // 파티원: 파티장 데이터 사용
        if (_leaderLocation == null || _leaderLocation!.currentH3Index == null) {
          return Colors.grey;
        }

        final targetH3Index = _leaderLocation!.currentH3Index;
        final targetProgress = _leaderLocation!.occupyProgress;

        final currentModel = _visibleHexagonModels.firstWhere(
              (m) => m.h3Index == targetH3Index,
          orElse: () => HexagonModel(h3Index: targetH3Index!, color: 0),
        );

        if (currentModel.ownerId != null || targetProgress > 0) {
          return _selectedGridColor;
        }

      }
    } else {
      // 솔로 플로깅: 자신의 데이터 사용
      if (_currentH3Index == null) return Colors.grey;

      final currentModel = _visibleHexagonModels.firstWhere(
            (m) => m.h3Index == _currentH3Index,
        orElse: () => HexagonModel(h3Index: _currentH3Index!, color: 0),
      );

      if (currentModel.ownerId != null || _occupyProgress > 0) {
        return _selectedGridColor;
      }
    }

    return Colors.grey;
  }
}
