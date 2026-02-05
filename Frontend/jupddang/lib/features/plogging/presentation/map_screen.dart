import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gal/gal.dart';
import 'dart:ui' as ui;

// --- Project Imports (경로는 프로젝트에 맞게 유지해주세요) ---
import '../../../services/location_h3_service.dart';
import '../../../services/gps_signal_filter.dart';
import '../../../services/auth_service.dart';
import 'package:jupddang/features/plogging/models/hexagon.dart';
import '../../../widgets/pixel_button.dart';
import '../../../widgets/pixel_character.dart';
import '../../party/models/party_models.dart';
import '../../party/data/party_service.dart';
import '../../party/data/party_socket_service.dart';
import '../../raid/models/raid_models.dart';
import '../../raid/data/raid_service.dart';
import '../../raid/presentation/boss_detail_screen.dart';
import '../../../widgets/animated_boss_widget.dart';
import '../../trashcan/data/trashcan_service.dart';
import '../../trashcan/models/trashcan_model.dart';
import 'package:jupddang/features/plogging/models/plogging_models.dart';

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
  final PartySocketService _socketService = PartySocketService();
  final AuthService _authService = AuthService();
  final PartyService _partyService = PartyService();
  final RaidService _raidService = RaidService();
  final TrashcanService _trashcanService = TrashcanService();
  final ImagePicker _picker = ImagePicker();

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

  // --- Session Data ---
  XFile? _beforeImage;
  XFile? _afterImage;
  String? _startAddress;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _recordTitleController = TextEditingController();
  File? _mapImage; // 맵 캡쳐 이미지

  // --- Map Customization ---
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

  // --- Stats ---
  final Stopwatch _sessionStopwatch = Stopwatch();
  double _totalDistance = 0.0;
  List<LatLng> _pathPoints = [];
  int _coinsGained = 0;
  Timer? _statsTimer;

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
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _initLocation();
    await _loadRaidBosses();
    if (widget.partyId != null) {
      await _setupPartyLogic();
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

  Future<void> _setupPartyLogic() async {
    await _loadPartyInfo();

    // WebSocket Event Listeners
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
      setState(() {
        _leaderLocation = leaderLocation;
        if (!_isLeader) {
          _occupyProgress = leaderLocation.occupyProgress;
          _currentH3Index = leaderLocation.currentH3Index;
          _updateHexagons(_mapController.camera.visibleBounds);
        }
      });
    };

    _socketService.connect(widget.partyId!);
    // Polling fallback
    _partyPollTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _pollPartyData(),
    );
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

    // Linear Interpolation for smoothness
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
      if (distance < 0.5 && _phase != PloggingPhase.plogging) return;
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

    // H3 Logic (Leader or Solo)
    if (_isLeader) {
      final h3Index = _h3Service.latLngToH3(newPos);
      if (h3Index != null) {
        if (_currentH3Index != h3Index) {
          _currentH3Index = h3Index;
          _occupyProgress = 0.0;
          if (_phase == PloggingPhase.plogging) _startOccupationTimer();
        }
      } else {
        _stopOccupationTimer();
        _currentH3Index = null;
        _occupyProgress = 0.0;
      }

      // Send Location if Party Leader
      if (widget.partyId != null) {
        _sendLeaderLocation();
      }
    }

    setState(() {});
  }

  void _sendLeaderLocation() {
    final locationRequest = LocationRequest(
      lat: _currentPosition!.latitude,
      lon: _currentPosition!.longitude,
      partyId: widget.partyId!,
      elapsedTime: _sessionStopwatch.elapsed.inSeconds,
      totalDistance: _totalDistance,
      score: _coinsGained,
      currentH3Index: _currentH3Index,
      occupyProgress: _occupyProgress,
      userId: '',
    );
    _socketService.sendLocation(widget.partyId!, locationRequest);
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

    final newPolygons = _visibleHexagonModels
        .map((model) {
          final boundary = _h3Service.getHexagonBoundary(model.h3Index);
          if (boundary.isEmpty) return null;

          final points = boundary
              .map((coord) => LatLng(coord.lat, coord.lon))
              .toList();

          Color fillColor = model.color == 0
              ? Colors.transparent
              : Color(model.color).withOpacity(_gridOpacity);

          if (model.h3Index == targetH3Index && targetProgress > 0) {
            final targetColor = _selectedGridColor
                .withOpacity(_gridOpacity * 1.5)
                .withAlpha((_gridOpacity * 1.5 * 255).toInt().clamp(0, 255));
            fillColor =
                Color.lerp(fillColor, targetColor, targetProgress) ?? fillColor;
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

    if (mounted) setState(() => _hexagons = newPolygons);
  }

  // ==========================================
  // Plogging Actions (Start, Pause, Finish)
  // ==========================================

  void _startPlogging() {
    setState(() {
      _phase = PloggingPhase.plogging;
      _showCustomizer = false;
      _sessionStopwatch.start();
      _totalDistance = 0.0;
      _pathPoints = _currentPosition != null ? [_currentPosition!] : [];
      _coinsGained = 0;
      _descriptionController.clear();
      _startAddress = "Fetching address...";

      _statsTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_isLeader && widget.partyId != null) _sendLeaderLocation();
        setState(() {});
      });

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
  // Occupation Logic
  // ==========================================

  void _startOccupationTimer() {
    if (!_isLeader) return;
    _stopOccupationTimer();

    _stayTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_phase != PloggingPhase.plogging) return;
      if (_currentH3Index == null) return;

      final currentModel = _visibleHexagonModels.firstWhere(
        (m) => m.h3Index == _currentH3Index,
        orElse: () => HexagonModel(h3Index: _currentH3Index!, color: 0),
      );

      if (currentModel.ownerId != null) {
        _occupyProgress = 0.0;
        _generatePolygons();
        return;
      }

      _occupyProgress += (1.0 / 60.0); // 1 minute to occupy

      if (widget.partyId != null) _sendLeaderLocation();

      if (_occupyProgress >= 1.0) {
        _occupyProgress = 1.0;
        _stopOccupationTimer();
        if (_currentH3Index != null) _conquerHexagon(_currentH3Index!);
      }
      _generatePolygons();
    });
  }

  void _stopOccupationTimer() {
    _stayTimer?.cancel();
    _stayTimer = null;
    if (mounted) setState(() => _generatePolygons());
  }

  void _conquerHexagon(String h3Index) {
    _h3Service.occupyHexagon(h3Index, "my_user_id", 0x990000FF);
    _occupyProgress = 0.0;
    _coinsGained += 5;
    _updateHexagons(_mapController.camera.visibleBounds);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("땅을 점령했습니다! (1분 체류 달성)")));
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
        _showAlertDialog("알림", "이미 근처에 등록된 쓰레기통이 있습니다.");
      } else {
        _showConfirmDialog(
          "쓰레기통 인증",
          "근처에 제보된 쓰레기통이 있습니다.\n이 쓰레기통이 맞나요?",
          () async {
            await _verifyTrashcan(closest!.id);
          },
        );
      }
    } else {
      _showConfirmDialog("쓰레기통 제보", "현재 위치에 새로운 쓰레기통을 제보하시겠습니까?", () async {
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

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("확인"),
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
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(confirmText),
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
      body: Stack(
        children: [
          // 1. Base Map
          _buildMapLayer(),

          // 2. Overlays
          if (_isPlogging) _buildStatsOverlay(),
          if (_showCustomizer) _buildCustomizerOverlay(),

          // 3. Floating Buttons
          _buildReportButton(),
          _buildControlButtonsRight(),
          if (_phase == PloggingPhase.idle) _buildPaletteButton(),

          // 4. Main Plogging Controls (Bottom)
          if (_isLeader) _buildBottomControls(),

          // 5. Summary Modal
          if (_phase == PloggingPhase.summary) _buildSummaryOverlay(),
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
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName:
                'com.ssafy.jupddang', // Updated to avoid OSM block
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
      top: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: [
          _manualMoveButton(Pixel.plus, "zoom_in", _zoomIn),
          const SizedBox(height: 12),
          _manualMoveButton(Pixel.minus, "zoom_out", _zoomOut),
          const SizedBox(height: 24),
          _manualMoveButton(Pixel.gps, "my_location", _centerToCurrentLocation),
          if (_isPlogging) ...[
            const SizedBox(height: 24),
            _manualMoveButton(Pixel.camera, "take_photo", _takePhoto),
          ],
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
            padding: const EdgeInsets.all(32.0),
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
                    style: const TextStyle(fontSize: 12),
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
                    style: const TextStyle(fontSize: 12),
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

    if (_mapImage == null) {
      final captured = await _captureMapImage();
      if (captured != null) {
        _mapImage = captured;
      }
    }
    if (_mapImage == null) return _snack("맵 이미지 생성 중입니다. 잠시 후 다시 시도해주세요.");

    _showLoading(const Color(0xFF17C964));
    try {
      final route = _pathPoints
          .map((p) => '${p.latitude},${p.longitude}')
          .toList(growable: false);
      final request = PloggingEndRequest(
        userId: AuthService.userId ?? '',
        totalDistance: _totalDistance / 1000.0,
        content: _descriptionController.text.trim(),
        totalTime: _sessionStopwatch.elapsed.inSeconds,
        endTime: _formatEndTime(DateTime.now()),
        partyId: widget.partyId,
        recordTitle: _recordTitleController.text.trim(),
        score: _coinsGained,
        route: route,
      );

      await _authService.endPlogging(
        requestData: request,
        beforeImagePath: _beforeImage!.path,
        afterImagePath: _afterImage!.path,
        mapImagePath: _mapImage!.path,
      );

      if (mounted) Navigator.pop(context);
      _snack("기록이 업로드되었습니다!");
      _resetPlogging();
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

    _showLoading(const Color(0xFFF59E0B));

    try {
      final request = TempPloggingRequest(
        userId: AuthService.userId ?? '',
        totalDistance: _totalDistance / 1000.0,
        content: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        totalTime: _sessionStopwatch.elapsed.inSeconds,
        endTime: _formatEndTime(DateTime.now()),
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
      _snack("임시 저장 실패: $e");
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
      "${time.year}.${time.month.toString().padLeft(2, '0')}.${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

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
}
