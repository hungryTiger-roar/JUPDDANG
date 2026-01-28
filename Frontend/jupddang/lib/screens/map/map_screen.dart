import 'dart:async';
import 'package:flutter/foundation.dart'; // kIsWeb 사용을 위해 추가
import 'package:flutter/material.dart';
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

enum PloggingPhase { idle, plogging, paused, summary }

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LocationH3Service _h3Service = LocationH3Service();

  List<Polygon> _hexagons = [];
  LatLng? _currentPosition; // Start null to detect first fix
  bool _isInitialCenterSet = false;
  StreamSubscription<Position>? _positionStream;
  Timer? _debounceTimer;

  String? _currentH3Index;
  Timer? _stayTimer;
  PloggingPhase _phase = PloggingPhase.idle;
  bool _showCustomizer = false;
  double _occupyProgress = 0.0; // 0.0 ~ 1.0
  List<HexagonModel> _visibleHexagonModels = [];

  // Image Picker
  final ImagePicker _picker = ImagePicker();
  XFile? _beforeImage;
  XFile? _afterImage;

  // Session Data
  String? _startAddress;
  final TextEditingController _descriptionController = TextEditingController();

  // Map Customization
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

  // Session Stats
  Stopwatch _sessionStopwatch = Stopwatch();
  double _totalDistance = 0.0;
  List<LatLng> _pathPoints = [];
  int _coinsGained = 0;
  Timer? _statsTimer;

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
    _stayTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    await _h3Service.init();
    bool hasPermission = await _h3Service.checkPermission();
    if (hasPermission) {
      try {
        // 1. Get current position immediately
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _updateCurrentPosition(LatLng(position.latitude, position.longitude));
      } catch (e) {
        debugPrint("Initial location error: $e");
      }

      // 2. Listen for updates
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

    // 1. EMA Filter (Linear Interpolation) to prevent micro-jitter
    if (_currentPosition != null) {
      const double lerpFactor = 0.2; // Adjust for smoothness vs responsiveness
      newPos = LatLng(
        _currentPosition!.latitude +
            (newPos.latitude - _currentPosition!.latitude) * lerpFactor,
        _currentPosition!.longitude +
            (newPos.longitude - _currentPosition!.longitude) * lerpFactor,
      );

      // 2. Reject tiny updates to avoid jittering when stationary
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

    final h3Index = _h3Service.latLngToH3(newPos);
    if (h3Index != null) {
      if (_currentH3Index != h3Index) {
        _currentH3Index = h3Index;
        if (_phase == PloggingPhase.plogging) _startOccupationTimer();
      }
    } else {
      _stopOccupationTimer();
      _currentH3Index = null;
    }
    setState(() {});
  }

  bool get _isPlogging =>
      _phase == PloggingPhase.plogging || _phase == PloggingPhase.paused;

  void _startPlogging() {
    setState(() {
      _phase = PloggingPhase.plogging;
      _showCustomizer = false; // Close palette if open
      _sessionStopwatch.start();
      _totalDistance = 0.0;
      _pathPoints = [_currentPosition!];
      _coinsGained = 0;
      _descriptionController.clear();
      _startAddress = "Fetching address...";
      _statsTimer = Timer.periodic(
        const Duration(seconds: 1),
        (t) => setState(() {}),
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
      if (_currentH3Index != null) _startOccupationTimer();
    });
  }

  void _finishPlogging() {
    setState(() {
      _phase = PloggingPhase.summary;
      _sessionStopwatch.stop();
      _statsTimer?.cancel();
      _stopOccupationTimer();
    });
  }

  void _resetPlogging() {
    setState(() {
      _phase = PloggingPhase.idle;
      _sessionStopwatch.reset();
      _beforeImage = null;
      _afterImage = null;
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

  void _zoomIn() {
    final newZoom = _mapController.camera.zoom + 1;
    _mapController.move(_mapController.camera.center, newZoom);
  }

  void _zoomOut() {
    final newZoom = _mapController.camera.zoom - 1;
    _mapController.move(_mapController.camera.center, newZoom);
  }

  void _startOccupationTimer() {
    _stopOccupationTimer();
    _occupyProgress = 0.0;
    _stayTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      _occupyProgress += (1.0 / 60.0);
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
    _occupyProgress = 0.0;
    if (mounted) {
      setState(() {
        _generatePolygons();
      });
    }
  }

  void _conquerHexagon(String h3Index) {
    _h3Service.occupyHexagon(h3Index, "my_user_id", 0x990000FF);
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
    // Check if bounds are valid (avoiding empty bounds crash)
    if (bounds.southWest.latitude == 0 && bounds.northEast.latitude == 0)
      return;

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
    final newPolygons = _visibleHexagonModels
        .map((model) {
          final boundary = _h3Service.getHexagonBoundary(model.h3Index);
          if (boundary.isEmpty) return null;

          final points = boundary
              .map((coord) => LatLng(coord.lat, coord.lon))
              .toList();

          // Apply customization
          Color baseColor;
          if (model.ownerId == null) {
            // Unowned lands: Fixed subtle gray (the "default" look)
            baseColor = Colors.black.withOpacity(0.05 * _gridOpacity);
          } else {
            // Owned lands: Use the color selected from the palette
            baseColor = _selectedGridColor.withOpacity(_gridOpacity);
          }

          Color fillColor = baseColor;
          if (model.h3Index == _currentH3Index && _occupyProgress > 0) {
            // While occupying, fade from the unowned color to the SELECTED palette color
            final targetColor = _selectedGridColor
                .withOpacity(_gridOpacity * 1.5)
                .withAlpha((_gridOpacity * 1.5 * 255).toInt().clamp(0, 255));
            fillColor =
                Color.lerp(fillColor, targetColor, _occupyProgress) ??
                fillColor;
          }
          return Polygon(
            points: points,
            color: fillColor,
            borderColor: model.h3Index == _currentH3Index
                ? Colors.white.withOpacity(0.8)
                : Colors.black.withOpacity(0.4 * _gridOpacity),
            borderStrokeWidth: model.h3Index == _currentH3Index ? 3.0 : 2.0,
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
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const LatLng(37.5665, 126.9780),
          initialZoom: 16.0,
          minZoom: 5.0,
          maxZoom: 19.0,
          onPositionChanged: _onMapPositionChanged,
          onMapReady: () {
            _updateHexagons(_mapController.camera.visibleBounds);
          },
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
          if (_currentPosition != null)
            MarkerLayer(
              markers: [
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
                if (_currentH3Index != null)
                  Marker(
                    point: _currentPosition!,
                    width: 120,
                    height: 50,
                    child: Transform.translate(
                      offset: const Offset(
                        0,
                        -65,
                      ), // Increased gap from -50 to -65
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
          // Stats Overlay (Top)
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
                      _formatDuration(_sessionStopwatch.elapsed),
                      "TIME",
                    ),
                    _buildStatColumn(
                      Pixel.user,
                      "${(_totalDistance / 1000).toStringAsFixed(2)}km",
                      "DIST",
                    ),
                    _buildStatColumn(Pixel.coin, "$_coinsGained", "POINT"),
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
                        value: _occupyProgress,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(_selectedGridColor),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Top Left Controls (Palette) - Only visible when NOT plogging
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

          // Zoom & My Location Controls
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
              ],
            ),
          ),

          // Contextual Controls (Start/Pause/Resume/Stop)
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

          // Summary Overlay
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
          text: "START JUPKING",
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
                        _formatDuration(_sessionStopwatch.elapsed),
                        "TIME",
                      ),
                      _buildStatColumn(
                        Pixel.user,
                        "${(_totalDistance / 1000).toStringAsFixed(2)}km",
                        "DIST",
                      ),
                      _buildStatColumn(Pixel.coin, "$_coinsGained", "POINT"),
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
                      "DESCRIPTION",
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
                      hintText: "오늘의 줍킹은 어땠나요?",
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
                  const SizedBox(height: 40),
                  PixelButton(
                    text: "PUBLISH RECORD",
                    isGreen: false,
                    color: _selectedGridColor,
                    onPressed: () {
                      if (AuthService.accessToken == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("로그인 회원만 기록을 저장할 수 있습니다."),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("기록이 업로드되었습니다!")),
                      );
                      _resetPlogging();
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _resetPlogging,
                    child: const Text(
                      "CLOSE WITHOUT SAVING",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
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

  Color _getStatusColor() {
    if (_currentH3Index == null) return Colors.grey;

    final currentModel = _visibleHexagonModels.firstWhere(
      (m) => m.h3Index == _currentH3Index,
      orElse: () => HexagonModel(h3Index: _currentH3Index!, color: 0),
    );

    if (currentModel.ownerId != null || _occupyProgress > 0) {
      return _selectedGridColor;
    }

    return Colors.grey;
  }
}
