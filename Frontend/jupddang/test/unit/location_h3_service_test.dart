import 'package:flutter_test/flutter_test.dart';
import 'package:jupddang/core/network/api_client.dart';
import 'package:jupddang/services/location_h3_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:h3_flutter/h3_flutter.dart';
import 'package:h3_common/h3_common.dart';

@GenerateMocks([ApiClient, Dio, H3])
import 'location_h3_service_test.mocks.dart';

void main() {
  late LocationH3Service service;
  late MockH3 mockH3;

  setUp(() async {
    mockH3 = MockH3();
    service = LocationH3Service();
    
    // Mock polygonToCells return value (Seoul area)
    when(mockH3.polygonToCells(
      perimeter: anyNamed('perimeter'),
      resolution: anyNamed('resolution'),
    )).thenReturn([BigInt.parse('89283082803ffff', radix: 16)]);

    // Mock cellToBoundary return value
    when(mockH3.cellToBoundary(any)).thenReturn([
      GeoCoord(lat: 37.5, lon: 126.9),
      GeoCoord(lat: 37.6, lon: 126.9),
      GeoCoord(lat: 37.6, lon: 127.0),
      GeoCoord(lat: 37.5, lon: 127.0),
    ]);

    await service.init(h3: mockH3);
  });

  group('LocationH3Service Logic Tests', () {
    test('latLngToH3 should convert coordinates to H3 index', () {
      final point = LatLng(37.5665, 126.9780); // Seoul
      final h3Index = service.latLngToH3(point);
      expect(h3Index, isNotNull);
      expect(h3Index, isA<String>());
    });

    test('updatePosition should track distance in same hexagon', () {
      final pos1 = Position(
        latitude: 37.5665,
        longitude: 126.9780,
        timestamp: DateTime.now(),
        accuracy: 5,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
        floor: null,
        isMocked: false,
      );
      
      service.updatePosition(pos1);
      expect(service.occupyProgress, 0.0);

      // Moved 50m in same area (approximately)
      final pos2 = Position(
        latitude: 37.5669, // roughly 50m move
        longitude: 126.9780,
        timestamp: DateTime.now().add(const Duration(seconds: 10)),
        accuracy: 5,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 5,
        speedAccuracy: 0,
        floor: null,
        isMocked: false,
      );

      service.updatePosition(pos2);
      expect(service.occupyProgress, greaterThan(0.0));
    });
  });
}
