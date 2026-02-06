import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv import 추가
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gal/gal.dart';

// --- Project Imports (경로는 프로젝트에 맞게 유지해주세요) ---
import '../../../services/location_h3_service.dart';
import '../../../services/gps_signal_filter.dart';
import '../../../services/auth_service.dart';
import 'package:jupddang/features/plogging/models/hexagon.dart';
import '../../../widgets/pixel_button.dart';
import '../../../widgets/pixel_character.dart';
import '../../party/models/party_models.dart';
import '../../party/data/party_service.dart';
import '../data/plogging_socket_service.dart';
import '../../raid/models/raid_models.dart';
import '../../raid/data/raid_service.dart';
import '../../raid/presentation/boss_detail_screen.dart';
import '../../../widgets/animated_boss_widget.dart';
import '../../trashcan/data/trashcan_service.dart';
import '../../trashcan/models/trashcan_model.dart';
import 'package:jupddang/features/plogging/models/plogging_models.dart';
import '../../quest/data/quest_service.dart';

import '../../quest/presentation/quest_widgets.dart';

// ==========================================
// 2. Map Screen Widget
// ==========================================

enum PloggingPhase { idle, plogging, paused, summary }

class MapScreen extends StatefulWidget {
  final int? partyId;
  final Function(dynamic)? onPloggingComplete;

  const MapScreen({super.key, this.partyId, this.onPloggingComplete});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // --- Controllers & Services ---
  final MapController _mapController = MapController();
  final GlobalKey _mapRepaintKey = GlobalKey();
  final LocationH3Service _h3Service = LocationH3Service();
  final GpsSignalFilter _gpsFilter = GpsSignalFilter();
  final PloggingSocketService _socketService = PloggingSocketService();
  final AuthService _authService = AuthService();
  final PartyService _partyService = PartyService();
  final RaidService _raidService = RaidService();
  final TrashcanService _trashcanService = TrashcanService();
  final ImagePicker _picker = ImagePicker();
  final QuestService _questService = QuestService();

  // --- Map State ---
  List<Polygon> _hexagons = [];
  LatLng? _currentPosition;
  bool _isInitialCenterSet = false;
  StreamSubscription<Position>? _positionStream;
  Timer? _debounceTimer;
  static const double _minZoomLevel = 15.0;

  // --- Party & Raid State ---
  Party? _party;
  Timer? _partyPollTimer;
  List<RaidBossModel> _raidBosses = [];
  List<TrashcanModel> _trashcans = [];
  PartyMemberLocation? _leaderLocation;

  // --- Plogging Logic State ---
  String? _currentH3Index;
  Timer? _stayTimer;
  PloggingPhase _phase = PloggingPhase.idle;
  bool _showCustomizer = false;
  double _occupyProgress = 0.0; // 0.0 ~ 1.0
  List<HexagonModel> _visibleHexagonModels = [];
  double _hexagonDistance = 0.0; // 현재 헥사곤 내 이동 거리 (100m 기준)

  // --- Session Data ---
  XFile? _beforeImage;
  XFile? _afterImage;
  String? _startAddress;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _recordTitleController = TextEditingController();
  File? _mapImage; // 맵 캡쳐 이미지

  // --- Map Customization ---
  // 기본 색상은 AuthService.userColor를 사용 (DB에 저장된 내 색)
  late Color _selectedGridColor;
  double _gridOpacity = 0.5;
  final List<Color> _paletteColors = [
    const Color(0xFF46A140),
    const Color(0xFF3B82F6),
    const Color(0xFFEF4444),
    const Color(0xFF8B5CF6),
    const Color(0xFFF59E0B),
    const Color(0xFF6B7280),
  ];

  // --- Stats ---
  final Stopwatch _sessionStopwatch = Stopwatch();
  double _totalDistance = 0.0;
  List<LatLng> _pathPoints = [];
  int _coinsGained = 0;
  Timer? _statsTimer;

  // --- Quest State ---
  bool _questCompleted = false;
  bool _showQuestModal = false;
  bool _showQuestTutorial = false;
  XFile? _questBeforeImage;
  XFile? _questAfterImage;
  LatLng? _questBeforeLocation;
  LatLng? _questAfterLocation;
  int? _beforeTrashCount;
  int? _afterTrashCount;

  // --- Getters for Display Logic (Party vs Solo) ---
  bool get _isPlogging =>
      _phase == PloggingPhase.plogging || _phase == PloggingPhase.paused;
  bool get _isLeader =>
      widget.partyId == null || (_party?.isCurrentUserLeader ?? false);

  // 파티원이면 리더의 정보를, 아니면 내 정보를 표시
  int get _displayElapsedSeconds => !_isLeader && _leaderLocation != null
      ? _leaderLocation!.elapsedTime
      : _sessionStopwatch.elapsed.inSeconds;

  double get _displayTotalDistanceMeters =>
      !_isLeader && _leaderLocation != null
      ? _leaderLocation!.totalDistance
      : _totalDistance;

  double get _displayOccupyProgress => !_isLeader && _leaderLocation != null
      ? _leaderLocation!.occupyProgress
      : _occupyProgress;

  String? get _displayCurrentH3Index => !_isLeader && _leaderLocation != null
      ? _leaderLocation!.currentH3Index
      : _currentH3Index;

  // ==========================================
  // Lifecycle Methods
  // ==========================================

  @override
  @override
  void initState() {
    super.initState();
    // 기본 색상을 DB에 저장된 사용자 색상으로 설정
    _selectedGridColor = AuthService.userColor != null
        ? Color(AuthService.userColor!)
        : const Color(0xFF46A140); // 기본값: 초록색

    // 색상 변경 리스너 등록 (프로필에서 변경 시 즉시 반영)
    AuthService.userColorNotifier.addListener(_onUserColorChanged);

    _initializeServices();
  }

  void _onUserColorChanged() {
    setState(() {
      _selectedGridColor = Color(AuthService.userColor!);
      debugPrint("🎨 지도 화면 색상 업데이트: $_selectedGridColor");
    });
    // 헥사곤 색상도 즉시 업데이트 (필요 시)
    if (_currentPosition != null) {
      _generatePolygons();
    }
  }

  Future<void> _initializeServices() async {
    await _initLocation();
    await _loadRaidBosses();
    await _setupSocketLogic(); // Generalize setup
    if (widget.partyId != null) {
      await _loadPartyInfo();
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
    _statsTimer?.cancel();
    // 리스너 해제 (중요)
    AuthService.userColorNotifier.removeListener(_onUserColorChanged);
    _mapController.dispose();
    _descriptionController.dispose();
    _recordTitleController.dispose();
    super.dispose();
  }

  // ==========================================
  // Service Initialization Logic
  // ==========================================

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
        final Position? correctedPos = _gpsFilter.filter(position);
        if (correctedPos == null) return;
        _updateCurrentPosition(
          LatLng(correctedPos.latitude, correctedPos.longitude),
        );
      });
    }
  }

  Future<void> _loadRaidBosses() async {
    try {
      final bosses = await _raidService.getAllRaidBosses();
      if (!mounted) return;
      setState(() {
        _raidBosses = bosses;
      });
    } catch (e) {
      debugPrint("❌ Failed to load raid bosses: $e");
    }
  }

  Future<void> _setupSocketLogic() async {
    // 1. 공통 리스너 (에러/연결성공)
    _socketService.onConnectionError = (message) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    };

    _socketService.onConnected = () {
      if (!mounted) return;
      // 개인 모드일 때도 연결 성공 메시지 표시 (또는 스킵 가능하지만 사용자 피드백 위해 유지)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ 서버에 연결되었습니다.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // 연결 후 현재 위치 전송 시작 (플로깅 중이라면)
      if (_phase == PloggingPhase.plogging) {
        _sendLocation();
      }
    };

    // 2. 파티 전용 리스너
    if (widget.partyId != null) {
      _socketService.onPartyActivityUpdate = (activity) {
        if (!mounted) return;
        // 활동 업데이트 처리 (종료/시작 등)
        if (activity.isCompleted && _phase != PloggingPhase.summary) {
          _finishPlogging();
        } 
        // 필요한 경우 activity.currentLatitude 등 활용
      };

      _socketService.onMemberLocationUpdate = (memberLocation) {
        if (!mounted) return;
        setState(() {
          _leaderLocation = memberLocation;
          if (!_isLeader) {
            _occupyProgress = memberLocation.occupyProgress;
            _currentH3Index = memberLocation.currentH3Index;
            _updateHexagons(_mapController.camera.visibleBounds);
          }
        });
      };
    }

    // 3. 연결 시작
    // UserId 확보
    String userId = AuthService.userId ?? 'unknown';
    if (userId == 'unknown') {
      try {
        final profile = await _authService.getMyProfile();
        userId = profile['userId'];
        AuthService.userId = userId;
      } catch (_) {}
    }
    
    _socketService.connect(userId: userId, partyId: widget.partyId);

    // 4. 파티 폴링 (파티 모드일 때만)
    if (widget.partyId != null) {
      _partyPollTimer = Timer.periodic(
        const Duration(seconds: 2),
        (_) => _pollPartyData(),
      );
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

  Future<void> _pollPartyData() async {
    if (!mounted || widget.partyId == null) return;
    try {
      final party = await _partyService.getPartyDetail(widget.partyId!);
      if (!mounted) return;
      setState(() => _party = party);

      if (!party.isCurrentUserLeader) {
        if (party.status == 'IN_PROGRESS' && _phase == PloggingPhase.idle) {
          _startPlogging();
        } else if (party.status == 'COMPLETED' &&
            _phase != PloggingPhase.summary) {
          _finishPlogging();
        }
      }
    } catch (e) {
      debugPrint("Party poll error: $e");
    }
  }

  // ==========================================
  // Location & Map Logic
  // ==========================================

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

    // [이중 보정 제거] GpsSignalFilter에서 이미 스무딩이 적용되므로
    // 여기서 추가 Lerp를 하면 위치가 너무 느리게 따라옴
    // 따라서 거리 기반 필터링만 수행

    if (_currentPosition != null) {
      final double distance = const Distance().distance(
        _currentPosition!,
        newPos,
      );
      // 플로깅 중이 아닐 때만 작은 움직임 무시 (0.5m 미만)
      if (distance < 0.5 && _phase != PloggingPhase.plogging) return;
    }

    if (_isPlogging && _currentPosition != null) {
      final distance = const Distance().distance(_currentPosition!, newPos);
      _totalDistance += distance;
      _pathPoints.add(newPos);

      // 100m 거리 기반 점령 로직: 헥사곤 내 이동 거리 누적
      if (_isLeader && distance < 100.0) {
        _hexagonDistance += distance;
        _updateOccupyProgress();
      }
    }

    _currentPosition = newPos;

    if (!_isInitialCenterSet &&
        _currentPosition != null &&
        _mapController.camera.zoom > 0) {
      _mapController.move(_currentPosition!, 16.0);
      _isInitialCenterSet = true;
    }

    // H3 Logic (Leader or Solo)
    if (_isLeader) {
      final h3Index = _h3Service.latLngToH3(newPos);
      if (h3Index != null) {
        if (_currentH3Index != h3Index) {
          // 새로운 헥사곤 진입: 거리 및 진행도 초기화
          _currentH3Index = h3Index;
          _hexagonDistance = 0.0;
          _occupyProgress = 0.0;
        }
      } else {
        _currentH3Index = null;
        _hexagonDistance = 0.0;
        _occupyProgress = 0.0;
      }

      // Send Location (Both Individual and Party Leader)
      _sendLocation();
    }

    setState(() {});
  }

  void _sendLocation() {
    if (_currentPosition == null) return;
    final userId = AuthService.userId ?? '';
    
    final locationRequest = LocationRequest(
      lat: _currentPosition!.latitude,
      lon: _currentPosition!.longitude,
      partyId: widget.partyId ?? 0, // 0 for individual
      elapsedTime: _sessionStopwatch.elapsed.inSeconds,
      totalDistance: _totalDistance,
      score: _coinsGained,
      currentH3Index: _currentH3Index,
      occupyProgress: _occupyProgress,
      userId: userId,
    );
    _socketService.sendLocation(locationRequest);
  }

  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    if (camera.zoom < _minZoomLevel) {
      if (_hexagons.isNotEmpty) setState(() => _hexagons = []);
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

    // Hexagons
    final List<String> h3Indices = _h3Service.getHexagonsInBounds(
      bounds.southWest,
      bounds.northEast,
    );
    if (h3Indices.isNotEmpty) {
      final owners = await _h3Service.fetchHexagonOwners(h3Indices);
      if (mounted) {
        _visibleHexagonModels = owners;
        _generatePolygons();
      }
    }

    // Trashcans
    _updateTrashcans(bounds);
  }

  Future<void> _updateTrashcans(LatLngBounds bounds) async {
    try {
      final trashcans = await _trashcanService.getTrashcansInArea(
        minLat: bounds.southWest.latitude,
        maxLat: bounds.northEast.latitude,
        minLng: bounds.southWest.longitude,
        maxLng: bounds.northEast.longitude,
      );
      if (mounted) setState(() => _trashcans = trashcans);
    } catch (e) {
      debugPrint("Failed to load trashcans: $e");
    }
  }

  void _generatePolygons() {
    String? targetH3Index = _displayCurrentH3Index;
    double targetProgress = _displayOccupyProgress;

    // [수정] 현재 헥사곤이 visibleHexagonModels에 없으면 추가
    List<HexagonModel> hexagonsToRender = List.from(_visibleHexagonModels);

    if (targetH3Index != null) {
      bool currentExists = hexagonsToRender.any(
        (m) => m.h3Index == targetH3Index,
      );
      if (!currentExists) {
        // 현재 헥사곤을 리스트에 추가 (투명 색상으로)
        hexagonsToRender.add(HexagonModel(h3Index: targetH3Index, color: 0));
        debugPrint("🔷 현재 헥사곤 추가: $targetH3Index");
      }
    }

    final newPolygons = hexagonsToRender
        .map((model) {
          final boundary = _h3Service.getHexagonBoundary(model.h3Index);
          if (boundary.isEmpty) return null;

          final points = boundary
              .map((coord) => LatLng(coord.lat, coord.lon))
              .toList();

          Color fillColor = model.color == 0
              ? Colors.transparent
              : Color(model.color).withOpacity(_gridOpacity);

          // 현재 점령 중인 헥사곤 하이라이트
          bool isCurrentHexagon = model.h3Index == targetH3Index;
          if (isCurrentHexagon) {
            // 점령 진행도에 따라 색상 변화 (0%라도 테두리는 표시)
            final targetColor = _selectedGridColor
                .withOpacity(_gridOpacity * 1.5)
                .withAlpha((_gridOpacity * 1.5 * 255).toInt().clamp(0, 255));
            fillColor =
                Color.lerp(fillColor, targetColor, targetProgress) ?? fillColor;
          }

          return Polygon(
            points: points,
            color: fillColor,
            borderColor: isCurrentHexagon
                ? Colors.white.withOpacity(0.9) // 현재 헥사곤: 흰색 테두리
                : Colors.black.withOpacity(0.4 * _gridOpacity),
            borderStrokeWidth: isCurrentHexagon ? 4.0 : 2.0, // 현재 헥사곤: 더 굵은 테두리
          );
        })
        .whereType<Polygon>()
        .toList();

    if (mounted) setState(() => _hexagons = newPolygons);
  }

  // ==========================================
  // Plogging Actions (Start, Pause, Finish)
  // ==========================================

  void _startPlogging() {
    // 1. 현재 GPS 위치에서 H3 헥사곤 인덱스 먼저 계산
    String? startH3Index;
    if (_currentPosition != null && _isLeader) {
      startH3Index = _h3Service.latLngToH3(_currentPosition!);
      debugPrint("🎯 START: 현재 위치 $_currentPosition → 헥사곤 $startH3Index");
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

      // Quest 초기화
      _questCompleted = false;
      _questBeforeImage = null;
      _questAfterImage = null;
      _questBeforeLocation = null;
      _questAfterLocation = null;
      _beforeTrashCount = null;
      _afterTrashCount = null;
      _showQuestTutorial = true;

      // 헥사곤 점령 상태 즉시 초기화
      if (startH3Index != null) {
        _currentH3Index = startH3Index;
        _hexagonDistance = 0.0;
        _occupyProgress = 0.0;
        debugPrint("✅ 헥사곤 점령 시작: $_currentH3Index (0%)");
      } else {
        _currentH3Index = null;
        _hexagonDistance = 0.0;
        _occupyProgress = 0.0;
        debugPrint("⚠️ 헥사곤을 찾을 수 없음 (위치: $_currentPosition)");
      }

      _statsTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        _sendLocation();
        setState(() {});
      });
    });

    // 2. UI 즉시 업데이트 (헥사곤 렌더링)
    _generatePolygons();

    // 3. 헥사곤 데이터 새로고침 (서버에서 가져오기)
    if (_currentPosition != null) {
      _updateHexagons(_mapController.camera.visibleBounds);
    }

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
        setState(
          () => _startAddress =
              "${p.locality} ${p.subLocality} ${p.thoroughfare}",
        );
      }
    } catch (e) {
      setState(() => _startAddress = "Address unavailable");
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
      if (_isLeader && _currentH3Index != null) _startOccupationTimer();
    });
  }

  Future<void> _finishPlogging() async {
    setState(() {
      _phase = PloggingPhase.summary;
      _sessionStopwatch.stop();
      _statsTimer?.cancel();
      _stopOccupationTimer();
    });

    final captured = await _captureMapImage();
    if (!mounted) return;
    if (captured != null) {
      setState(() => _mapImage = captured);
    }

    // 파티원은 자동 종료 후 이동
    if (!_isLeader) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
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

  // ==========================================
  // Occupation Logic (100m 거리 기반)
  // ==========================================

  /// 100m 거리 기반 점령 진행도 업데이트
  void _updateOccupyProgress() {
    if (!_isLeader) return;
    if (!mounted) return;
    if (_phase != PloggingPhase.plogging) return;
    if (_currentH3Index == null) return;

    // 이미 점령된 땅인지 확인
    final currentModel = _visibleHexagonModels.firstWhere(
      (m) => m.h3Index == _currentH3Index,
      orElse: () => HexagonModel(h3Index: _currentH3Index!, color: 0),
    );

    if (currentModel.ownerId != null) {
      // 이미 점령된 땅: 진행도 초기화
      _occupyProgress = 0.0;
      _hexagonDistance = 0.0;
      _generatePolygons();
      return;
    }

    // 100m 기준 점령 진행도 계산
    _occupyProgress = (_hexagonDistance / 100.0).clamp(0.0, 1.0);

    // 파티장/개인인 경우 위치 전송
    _sendLocation();

    // 100m 달성 시 점령 처리
    if (_hexagonDistance >= 100.0) {
      _occupyProgress = 1.0;
      if (_currentH3Index != null) _conquerHexagon(_currentH3Index!);
    }

    _generatePolygons();
  }

  /// 레거시 타이머 호환용 (파티원 동기화 목적)
  void _startOccupationTimer() {
    // 100m 거리 기반으로 변경되어 타이머 불필요
    // 위치 업데이트 시 _updateOccupyProgress()가 호출됨
  }

  void _stopOccupationTimer() {
    _stayTimer?.cancel();
    _stayTimer = null;
    if (mounted) setState(() => _generatePolygons());
  }

  void _conquerHexagon(String h3Index) {
    final userId = AuthService.userId ?? "my_user_id";
    final userColor = AuthService.userColor ?? 0x990000FF;
    _h3Service.occupyHexagon(h3Index, userId, userColor);
    _hexagonDistance = 0.0;
    _occupyProgress = 0.0;
    _coinsGained += 5;
    _updateHexagons(_mapController.camera.visibleBounds);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("땅을 점령했습니다! (100m 이동 달성)")));
  }

  // ==========================================
  // Trashcan & Report Logic
  // ==========================================

  Future<void> _onReportTrashcan() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("위치를 찾을 수 없습니다.")));
      return;
    }

    // Nearest Check logic
    const distanceCalc = Distance();
    TrashcanModel? closest;
    double minDst = double.infinity;

    for (var t in _trashcans) {
      final dst = distanceCalc.as(
        LengthUnit.Meter,
        _currentPosition!,
        LatLng(t.latitude, t.longitude),
      );
      if (dst <= 10.0 && dst < minDst) {
        minDst = dst;
        closest = t;
      }
    }

    if (closest != null) {
      if (closest.status == TrashcanStatus.VERIFIED ||
          closest.status == TrashcanStatus.OFFICIAL) {
        _showNesAlertDialog("알림", "이미 근처에 등록된 쓰레기통이 있습니다.");
      } else {
        _showNesConfirmDialog(
          "쓰레기통 인증",
          "근처에 제보된 쓰레기통이 있습니다.\n이 쓰레기통이 맞나요?",
          () async {
            await _verifyTrashcan(closest!.id);
          },
        );
      }
    } else {
      _showNesConfirmDialog("쓰레기통 제보", "현재 위치에 새로운 쓰레기통을 제보하시겠습니까?", () async {
        await _createTrashcan(_currentPosition!);
      }, confirmText: "제보하기");
    }
  }

  Future<void> _verifyTrashcan(int id) async {
    try {
      await _trashcanService.verifyTrashcan(id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("인증되었습니다!")));
      _updateTrashcans(_mapController.camera.visibleBounds);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("인증 실패: $e")));
    }
  }

  Future<void> _createTrashcan(LatLng pos) async {
    try {
      String address = "Unknown Address";
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
        );
        if (placemarks.isNotEmpty)
          address =
              "${placemarks.first.locality} ${placemarks.first.thoroughfare}"
                  .trim();
      } catch (_) {}

      final req = TrashcanCreateRequest(
        latitude: pos.latitude,
        longitude: pos.longitude,
        address: address,
      );
      final newTrashcan = await _trashcanService.createTrashcan(req);
      try {
        await _trashcanService.verifyTrashcan(newTrashcan.id);
      } catch (_) {} // Auto verify

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("새로운 쓰레기통이 제보되었습니다!")));
      _updateTrashcans(_mapController.camera.visibleBounds);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("제보 실패: $e")));
    }
  }

  // ==========================================
  // Helpers (Image, Dialog, Utils)
  // ==========================================

  Future<void> _pickImage(bool isBefore) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => isBefore ? _beforeImage = picked : _afterImage = picked);
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (photo == null) return;
      await Gal.putImage(photo.path);
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('사진이 갤러리에 저장되었습니다')));
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('사진 저장 실패: $e')));
    }
  }

  Future<File?> _captureMapImage() async {
    final renderObject = _mapRepaintKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) return null;

    final prevCenter = _mapController.camera.center;
    final prevZoom = _mapController.camera.zoom;
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, prevZoom);
      await Future.delayed(const Duration(milliseconds: 250));
    }

    final image = await renderObject.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final bytes = byteData.buffer.asUint8List();
    final file = File(
      '${Directory.systemTemp.path}/map_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);

    _mapController.move(prevCenter, prevZoom);
    return file;
  }

  void _showNesAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: NesContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: NesButton(
                  type: NesButtonType.success,
                  onPressed: () => Navigator.pop(ctx),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      "확인",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNesConfirmDialog(
    String title,
    String content,
    VoidCallback onConfirm, {
    String confirmText = "확인",
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: NesContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Pixel.trash,
                    color: Color(0xFF17C964),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: NesButton(
                      type: NesButtonType.success,
                      onPressed: () {
                        Navigator.pop(ctx);
                        onConfirm();
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            confirmText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NesButton(
                      type: NesButtonType.normal,
                      onPressed: () => Navigator.pop(ctx),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            "취소",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "확인",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(
    String title,
    String content,
    VoidCallback onConfirm, {
    String confirmText = "확인",
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "취소",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _zoomIn() => _mapController.move(
    _mapController.camera.center,
    _mapController.camera.zoom + 1,
  );
  void _zoomOut() => _mapController.move(
    _mapController.camera.center,
    _mapController.camera.zoom - 1,
  );

  LatLng? _getHexagonCenter(String h3Index) {
    final boundary = _h3Service.getHexagonBoundary(h3Index);
    if (boundary.isEmpty) return null;
    double lat =
        boundary.map((c) => c.lat).reduce((a, b) => a + b) / boundary.length;
    double lon =
        boundary.map((c) => c.lon).reduce((a, b) => a + b) / boundary.length;
    return LatLng(lat, lon);
  }

  // ==========================================
  // UI BUILD METHODS
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드로 인한 화면 리사이즈 방지
      body: Stack(
        children: [
          // 1. Base Map
          _buildMapLayer(),

          // 2. Overlays
          if (_isPlogging) _buildStatsOverlay(),
          // 컬러 팔레트는 프로필에서 설정하므로 제거
          // if (_showCustomizer) _buildCustomizerOverlay(),

          // 3. Floating Buttons
          _buildReportButton(),
          _buildControlButtonsRight(),
          // 컬러 팔레트 버튼 제거 (프로필에서 색상 변경)
          // if (_phase == PloggingPhase.idle) _buildPaletteButton(),

          // 4. Main Plogging Controls (Bottom)
          if (_isLeader) _buildBottomControls(),

          // 5. Summary Modal
          if (_phase == PloggingPhase.summary) _buildSummaryOverlay(),

          // 6. Quest Modals
          if (_showQuestTutorial)
            QuestTutorialModal(
              onClose: () => setState(() => _showQuestTutorial = false),
            ),
          if (_showQuestModal)
            QuestModal(
              beforeImage: _questBeforeImage,
              afterImage: _questAfterImage,
              beforeTrashCount: _beforeTrashCount ?? 0,
              afterTrashCount: _afterTrashCount ?? 0,
              onClose: () => setState(() => _showQuestModal = false),
              onTakeBeforePhoto: () => _takeQuestPhoto(true),
              onTakeAfterPhoto: () => _takeQuestPhoto(false),
              onValidate: _validateQuest,
            ),
        ],
      ),
    );
  }

  Widget _buildMapLayer() {
    return RepaintBoundary(
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
              if (mounted) _updateHexagons(_mapController.camera.visibleBounds);
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/light-v10/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
            additionalOptions: {
              'accessToken': dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '',
            },
            userAgentPackageName: 'com.ssafy.jupddang.app',
          ),
          if (_pathPoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _pathPoints,
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
          MarkerLayer(markers: _buildMarkers()),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    // Boss Markers
    markers.addAll(
      _raidBosses.asMap().entries.map((entry) {
        final index = entry.key;
        final boss = entry.value;
        LatLng? center = _getHexagonCenter(boss.h3Index);
        if (center == null) {
          // Fallback position logic
          final baseLatitude = 36.109648;
          final baseLongitude = 128.417922;
          center = LatLng(
            baseLatitude + (index * 0.001),
            baseLongitude + (index * 0.001),
          );
        }
        return Marker(
          point: center,
          width: 70,
          height: 70,
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BossDetailScreen(bossId: boss.id, boss: boss),
              ),
            ),
            child: AnimatedBossWidget(
              bossType: BossType.trashCan,
              size: 60,
            ), // Type logic simplified
          ),
        );
      }),
    );

    // Trashcan Markers
    markers.addAll(
      _trashcans.map(
        (t) => Marker(
          point: LatLng(t.latitude, t.longitude),
          width: 48,
          height: 48,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 4,
                left: 4,
                child: Container(width: 40, height: 40, color: Colors.black26),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: Center(
                  child: Icon(
                    Pixel.trash,
                    size: 24,
                    color: _getTrashcanColor(t.status),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // User Marker
    if (_currentPosition != null) {
      markers.add(
        Marker(
          point: _currentPosition!,
          width: 48,
          height: 48,
          child: PixelCharacter(
            size: 48,
            color: _selectedGridColor,
            isMoving: _isPlogging,
          ),
        ),
      );
    }

    // Leader Marker (if not me)
    if (_leaderLocation != null && !_isLeader) {
      markers.add(
        Marker(
          point: LatLng(_leaderLocation!.lat, _leaderLocation!.lon),
          width: 48,
          height: 48,
          child: Column(
            children: [
              const Icon(Icons.stars, color: Colors.amber, size: 20),
              PixelCharacter(size: 32, color: Colors.amber, isMoving: true),
            ],
          ),
        ),
      );
    }

    // Status Label
    if (_shouldShowStatusLabel()) {
      markers.add(
        Marker(
          point: _getStatusLabelPosition(),
          width: 120,
          height: 50,
          child: Transform.translate(
            offset: const Offset(0, -65),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: _getStatusColor(), width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4)),
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
      );
    }

    return markers;
  }

  Widget _buildStatsOverlay() {
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: Center(
        child: NesContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _statItem(
                Pixel.clock,
                _formatDuration(Duration(seconds: _displayElapsedSeconds)),
              ),
              const SizedBox(width: 16),
              _statItem(
                Pixel.user,
                "${(_displayTotalDistanceMeters / 1000).toStringAsFixed(2)}km",
              ),
              const SizedBox(width: 16),
              _statItem(Pixel.coin, "$_coinsGained"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String val) => Row(
    children: [
      Icon(icon, color: _selectedGridColor, size: 16),
      const SizedBox(width: 4),
      Text(
        val,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ],
  );

  Widget _buildCustomizerOverlay() {
    return Positioned(
      top: 100,
      right: 16,
      child: NesContainer(
        padding: const EdgeInsets.all(12),
        // constraints: const BoxConstraints(maxWidth: 160), // NesContainer might handle width differently
        child: SizedBox(
          width: 160,
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
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showCustomizer = false),
                    child: const Icon(
                      Pixel.close,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "GRID OPACITY",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                  trackHeight: 2,
                  activeTrackColor: const Color(0xFFF9D698),
                  thumbColor: Colors.white,
                ),
                child: Slider(
                  value: _gridOpacity,
                  onChanged: (val) => setState(() {
                    _gridOpacity = val;
                    _generatePolygons();
                  }),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "COLOR PALETTE",
                style: TextStyle(
                  color: Colors.black,
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
                    onTap: () => setState(() {
                      _selectedGridColor = color;
                      _generatePolygons();
                    }),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.black,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton() {
    return Positioned(
      bottom: _phase == PloggingPhase.idle ? 100 : 160,
      right: 20,
      child: FloatingActionButton(
        heroTag: 'report_trashcan',
        backgroundColor: Colors.white,
        shape: const BeveledRectangleBorder(
          side: BorderSide(color: Colors.black, width: 3),
          borderRadius: BorderRadius.zero,
        ),
        onPressed: _onReportTrashcan,
        child: const Icon(Pixel.trash, color: Colors.black),
      ),
    );
  }

  Widget _buildPaletteButton() {
    return Positioned(
      left: 20,
      top: 60,
      child: _showCustomizer
          ? const SizedBox.shrink()
          : _manualMoveButton(
              Pixel.paintbucket,
              "palette_toggle",
              () => setState(() => _showCustomizer = true),
            ),
    );
  }

  Widget _buildControlButtonsRight() {
    return Positioned(
      right: 20,
      // 플로깅 중일 때 더 위로 올려서 쓰레기통 버튼과 겹치지 않도록
      top: _isPlogging
          ? MediaQuery.of(context).size.height * 0.15
          : MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: [
          // Q 버튼은 플로깅 중일 때 최상단에 표시
          if (_isPlogging) ...[
            QuestButton(
              isCompleted: _questCompleted,
              onTap: _openQuestModal,
              isHighlighted: _showQuestTutorial,
            ),
            const SizedBox(height: 12),
          ],
          _manualMoveButton(Pixel.plus, "zoom_in", _zoomIn),
          const SizedBox(height: 12),
          _manualMoveButton(Pixel.minus, "zoom_out", _zoomOut),
          const SizedBox(height: 24),
          _manualMoveButton(Pixel.gps, "my_location", _centerToCurrentLocation),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildPhaseButtons(),
        ),
      ),
    );
  }

  Widget _buildPhaseButtons() {
    switch (_phase) {
      case PloggingPhase.idle:
        return SizedBox(
          width: 200,
          child: PixelButton(
            text: "START",
            isGreen: false,
            color: _selectedGridColor,
            onPressed: _startPlogging,
          ),
        );
      case PloggingPhase.plogging:
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
            Opacity(
              opacity: _questCompleted ? 1.0 : 0.5,
              child: SizedBox(
                width: 140,
                child: PixelButton(
                  text: "FINISH",
                  isGreen: false,
                  color: _questCompleted
                      ? _selectedGridColor
                      : Colors.grey[600]!,

                  onPressed: _questCompleted ? _finishPlogging : _showQuestHint,
                ),
              ),
            ),
          ],
        );
      case PloggingPhase.paused:
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
            Opacity(
              opacity: _questCompleted ? 1.0 : 0.5,
              child: SizedBox(
                width: 140,
                child: PixelButton(
                  text: "FINISH",
                  isGreen: false,
                  color: _questCompleted
                      ? _selectedGridColor
                      : Colors.grey[600]!,

                  onPressed: _questCompleted ? _finishPlogging : _showQuestHint,
                ),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSummaryOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            // [UX Fix] Add padding for keyboard
            padding: EdgeInsets.fromLTRB(
              32.0, 
              32.0, 
              32.0, 
              32.0 + MediaQuery.of(context).viewInsets.bottom
            ),
            child: NesContainer(
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
                      _summaryStat(
                        Pixel.clock,
                        _formatDuration(_sessionStopwatch.elapsed),
                        "TIME",
                      ),
                      _summaryStat(
                        Pixel.user,
                        "${(_totalDistance / 1000).toStringAsFixed(2)}km",
                        "DIST",
                      ),
                      _summaryStat(Pixel.coin, "$_coinsGained", "POINT"),
                    ],
                  ),
                  // 파티 모드일 때 보너스 점수 상세 표시
                  if (widget.partyId != null) ...[
                    const SizedBox(height: 16),
                    _buildPartyBonusInfo(),
                  ],
                  const SizedBox(height: 32),
                  if (_startAddress != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        "START: $_startAddress",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                  _summaryLabel("DESCRIPTION"),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    decoration: _inputDeco("오늘의 줍킹은 어땠나요?"),
                  ),
                  const SizedBox(height: 24),

                  _summaryLabel("MAP PHOTO"),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _mapPhotoSlot("MAP", _mapImage)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _summaryLabel("BEFORE / AFTER PHOTOS"),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _photoSlot(
                          "BEFORE",
                          _beforeImage,
                          () => _pickImage(true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _photoSlot(
                          "AFTER",
                          _afterImage,
                          () => _pickImage(false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _summaryLabel("RECORD NAME"),
                  TextField(
                    controller: _recordTitleController,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                    decoration: _inputDeco("ex) 한강 플로깅"),
                  ),
                  const SizedBox(height: 24),

                  PixelButton(
                    text: "PUBLISH RECORD",
                    isGreen: false,
                    color: _selectedGridColor,
                    onPressed: _handlePublish,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _handleTempSave,
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

  // ==========================================
  // Summary Handlers
  // ==========================================

  Future<void> _handlePublish() async {
    if (AuthService.accessToken == null)
      return _snack("로그인 회원만 기록을 저장할 수 있습니다.", isError: true);
    if (_beforeImage == null || _afterImage == null)
      return _snack("Before/After 사진을 선택해주세요.");
    if (_recordTitleController.text.trim().isEmpty)
      return _snack("기록 제목을 입력해주세요.");

    // Ensure userId is available
    if (AuthService.userId == null || AuthService.userId!.isEmpty) {
      try {
        final profile = await _authService.getMyProfile();
        AuthService.userId = profile['userId'];
      } catch (e) {
        return _snack("회원 정보를 불러올 수 없습니다. 다시 로그인해주세요.", isError: true);
      }
    }

    if (_mapImage == null) {
      final captured = await _captureMapImage();
      if (captured != null) {
        _mapImage = captured;
      }
    }
    if (_mapImage == null) return _snack("맵 이미지 생성 중입니다. 잠시 후 다시 시도해주세요.");

    _showLoading(const Color(0xFF17C964));
    try {
      final request = PloggingEndRequest(
        distance: _totalDistance / 1000.0,
        content: _descriptionController.text.trim(),
        times: _sessionStopwatch.elapsed.inSeconds,
        endTime:
            "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}T${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}",
        partyId: widget.partyId,
        recordTitle: _recordTitleController.text.trim(),
        score: _coinsGained,
      );

      final response = await _authService.endPlogging(
        requestData: request,
        beforeImagePath: _beforeImage!.path,
        afterImagePath: _afterImage!.path,
        mapImagePath: _mapImage!.path,
      );

      if (mounted) Navigator.pop(context);
      _snack("기록이 업로드되었습니다!");
      if (widget.onPloggingComplete != null) {
        widget.onPloggingComplete!(_extractPostId(response));
      }

      _resetPlogging();

      // 파티 모드일 때는 메인 화면으로 바로 이동
      if (widget.partyId != null && mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _snack("업로드 실패: $e", isError: true);
    }
  }

  Future<void> _handleTempSave() async {
    if (AuthService.accessToken == null)
      return _snack("로그인 후에 임시 저장할 수 있습니다.", isError: true);
    if (_mapImage == null) return _snack("맵 이미지 생성 중입니다.");
    if (_recordTitleController.text.trim().isEmpty)
      return _snack("기록 제목을 입력해주세요.");

    // Ensure userId is available
    if (AuthService.userId == null || AuthService.userId!.isEmpty) {
      try {
        final profile = await _authService.getMyProfile();
        AuthService.userId = profile['userId'];
      } catch (e) {
        return _snack("회원 정보를 불러올 수 없습니다. 다시 로그인해주세요.", isError: true);
      }
    }

    _showLoading(const Color(0xFFF59E0B));

    try {
      final request = TempPloggingRequest(
        distance: _totalDistance / 1000.0,
        content: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        times: _sessionStopwatch.elapsed.inSeconds,
        endTime:
            "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}T${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}",
        partyId: widget.partyId,
        recordTitle: _recordTitleController.text.trim(),
      );

      await _authService.savePloggingTemp(
        requestData: request,
        beforeImagePath: _beforeImage?.path,
        afterImagePath: _afterImage?.path,
        mapImagePath: _mapImage?.path,
      );

      if (mounted) Navigator.pop(context);
      _snack("플로깅 기록이 임시 저장되었습니다.");

      _resetPlogging();
      if (widget.partyId != null && mounted)
        Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showAlertDialog("임시 저장 실패", "$e");
    }
  }

  // ==========================================
  // Minor Components
  // ==========================================

  Widget _summaryStat(IconData icon, String val, String label) => Column(
    children: [
      Icon(icon, color: _selectedGridColor.withOpacity(0.9), size: 18),
      Text(
        val,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 8)),
    ],
  );

  // 파티 보너스 점수 상세 정보 위젯 (NES UI 스타일)
  Widget _buildPartyBonusInfo() {
    final memberCount = _party?.members.length ?? 1;
    final multiplier = memberCount >= 2 ? 1.0 + (memberCount - 1) * 0.2 : 1.0;
    final bonusPoints = (_coinsGained * (multiplier - 1.0)).toInt();
    final finalScore = (_coinsGained * multiplier).toInt();

    return NesContainer(
      backgroundColor: const Color(0xFFFFF9E6),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Pixel.coin, color: const Color(0xFFFBBF24), size: 16),
              const SizedBox(width: 8),
              Text(
                'PARTY BONUS (${memberCount}명 x${multiplier.toStringAsFixed(1)})',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _bonusStatItem('BASE', '$_coinsGained'),
              const Text(
                '+',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _bonusStatItem('BONUS', '+$bonusPoints'),
              const Text(
                '=',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _bonusStatItem('TOTAL', '$finalScore', isHighlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bonusStatItem(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: isHighlight
          ? BoxDecoration(
              color: const Color(0xFF17C964),
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(2, 2)),
              ],
            )
          : null,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: isHighlight ? Colors.white : Colors.black87,
              fontSize: isHighlight ? 14 : 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isHighlight ? Colors.white70 : Colors.black54,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryLabel(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    ),
  );

  Widget _photoSlot(String label, XFile? file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: NesContainer(
          padding: EdgeInsets.zero,
          child: file == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Pixel.camera, color: Colors.grey),
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

  Widget _mapPhotoSlot(String label, File? file) {
    return AspectRatio(
      aspectRatio: 1,
      child: NesContainer(
        padding: EdgeInsets.zero,
        child: file == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Pixel.map, color: Colors.grey),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              )
            : Image.file(file, fit: BoxFit.cover),
      ),
    );
  }

  String? _extractPostId(dynamic response) {
    if (response is Map) {
      final direct =
          response['postId'] ?? response['post_id'] ?? response['id'];
      if (direct != null) return direct.toString();
      final data = response['data'];
      if (data is Map) {
        final nested = data['postId'] ?? data['post_id'] ?? data['id'];

        if (nested != null) return nested.toString();
      }
    }
    return null;
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

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 10, color: Colors.grey),
    fillColor: Colors.black.withOpacity(0.05),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Colors.black, width: 2),
    ),
  );

  // ==========================================
  // Utils
  // ==========================================

  String _formatDuration(Duration d) =>
      "${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";

  String _formatEndTime(DateTime time) =>
      time.toIso8601String().split('.').first;

  Color _getTrashcanColor(TrashcanStatus status) {
    switch (status) {
      case TrashcanStatus.VERIFIED:
        return Colors.blueAccent;
      case TrashcanStatus.PENDING:
        return Colors.orangeAccent;
      case TrashcanStatus.OFFICIAL:
        return Colors.green;
    }
  }

  bool _shouldShowStatusLabel() {
    if (_phase != PloggingPhase.plogging) return false;
    if (_isLeader) return _currentH3Index != null;
    return _leaderLocation?.currentH3Index != null;
  }

  LatLng _getStatusLabelPosition() => _isLeader
      ? _currentPosition!
      : LatLng(_leaderLocation!.lat, _leaderLocation!.lon);

  Color _getStatusColor() {
    final h3 = _displayCurrentH3Index;
    if (h3 == null) return Colors.grey;

    // Check if occupied or in progress
    final model = _visibleHexagonModels.firstWhere(
      (m) => m.h3Index == h3,
      orElse: () => HexagonModel(h3Index: h3, color: 0),
    );
    if (model.ownerId != null || _displayOccupyProgress > 0)
      return _selectedGridColor;
    return Colors.grey;
  }

  String _getStatusLabel() {
    if (_isLeader) {
      if (_currentH3Index == null) return "위치 확인 중";
      if (_occupyProgress > 0)
        return "점령 중 ${(_occupyProgress * 100).toInt()}%";
    } else {
      if (_leaderLocation == null) return "파티장 대기 중";
      if (_leaderLocation!.occupyProgress > 0)
        return "점령 중 ${(_leaderLocation!.occupyProgress * 100).toInt()}%";
    }
    return "준비";
  }

  void _snack(String msg, {bool isError = false}) {
    if (mounted) {
      NesSnackbar.show(
        context,
        text: msg,
        type: isError ? NesSnackbarType.error : NesSnackbarType.normal,
      );
    }
  }

  void _showLoading(Color color) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator(color: color)),
    );
  }

  // Quest UI Components and Methods
  // Note: UI 컴포넌트들은 quest_widgets.dart로 분리됨
  void _openQuestModal() => setState(() => _showQuestModal = true);
  void _showQuestHint() => setState(() => _showQuestTutorial = true);

  Future<void> _takeQuestPhoto(bool isBefore) async {
    // 포커스 해제하여 키보드 관련 이슈 방지
    FocusScope.of(context).unfocus();

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo == null) return;
      final currentLocation = _currentPosition;
      if (currentLocation == null) {
        _snack("현재 위치를 확인할 수 없습니다", isError: true);
        return;
      }
      setState(() {
        if (isBefore) {
          _questBeforeImage = photo;
          _questBeforeLocation = currentLocation;
        } else {
          _questAfterImage = photo;
          _questAfterLocation = currentLocation;
        }
      });
      await Gal.putImage(photo.path);
      _snack("사진이 저장되었습니다");
    } catch (e) {
      _snack("사진 촬영 실패: $e", isError: true);
    }
  }

  Future<void> _validateQuest() async {
    if (_questBeforeImage == null || _questAfterImage == null) {
      _snack("두 사진을 모두 촬영해주세요", isError: true);
      return;
    }
    if (_questBeforeLocation == null || _questAfterLocation == null) {
      _snack("위치 정보를 확인할 수 없습니다", isError: true);
      return;
    }
    _showLoading(const Color(0xFF3B82F6));
    try {
      final response = _questService.validateLocally(
        beforeLocation: _questBeforeLocation!,
        afterLocation: _questAfterLocation!,
      );

      if (mounted) Navigator.pop(context);
      if (response.isValid) {
        setState(() {
          _questCompleted = true;
          _beforeTrashCount = response.beforeTrashCount;
          _afterTrashCount = response.afterTrashCount;
          _beforeImage = _questBeforeImage;
          _afterImage = _questAfterImage;
          _showQuestModal = false;
        });
        _snack("퀘스트 완료! 이제 플로깅을 종료할 수 있습니다");
      } else {
        _snack(response.message ?? "검증 실패", isError: true);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _snack("검증 중 오류 발생: $e", isError: true);
    }
  }
}
