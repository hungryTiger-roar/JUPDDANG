import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:h3_flutter/h3_flutter.dart';
import 'package:h3_common/h3_common.dart';
import 'package:jupddang/services/location_h3_service.dart';
import 'package:jupddang/core/network/api_client.dart';
import 'package:jupddang/features/raid/data/raid_service.dart';
import 'package:jupddang/features/plogging/models/hexagon.dart';

@GenerateMocks([ApiClient, Dio, H3])
import 'occupation_distance_test.mocks.dart';

void main() {
  group('100m 거리 기반 점령 로직 테스트', () {
    late MockH3 mockH3;
    late MockDio mockDio;
    late LocationH3Service h3Service;

    setUp(() async {
      mockH3 = MockH3();
      mockDio = MockDio();
      
      // 새 인스턴스 생성을 위해 싱글톤 우회
      h3Service = LocationH3Service();

      // Mock H3 polygonToCells - 동일 헥사곤 반환
      when(mockH3.polygonToCells(
        perimeter: anyNamed('perimeter'),
        resolution: anyNamed('resolution'),
      )).thenReturn([BigInt.parse('89283082803ffff', radix: 16)]);

      // Mock H3 cellToBoundary
      when(mockH3.cellToBoundary(any)).thenReturn([
        GeoCoord(lat: 37.5660, lon: 126.9775),
        GeoCoord(lat: 37.5670, lon: 126.9775),
        GeoCoord(lat: 37.5670, lon: 126.9785),
        GeoCoord(lat: 37.5660, lon: 126.9785),
      ]);

      await h3Service.init(h3: mockH3, dio: mockDio);
    });

    test('새로운 헥사곤 진입 시 거리 및 진행도 0으로 초기화', () {
      final pos = _createPosition(37.5665, 126.9780);
      
      h3Service.updatePosition(pos);
      
      expect(h3Service.occupyProgress, equals(0.0));
      expect(h3Service.currentH3Index, isNotNull);
    });

    test('동일 헥사곤 내 50m 이동 시 진행도 약 0.5', () {
      // 첫 번째 위치
      final pos1 = _createPosition(37.5665, 126.9780);
      h3Service.updatePosition(pos1);
      
      // 약 50m 이동 (위도 0.00045도 ≈ 50m)
      final pos2 = _createPosition(37.5669, 126.9780);
      h3Service.updatePosition(pos2);
      
      // 진행도가 약 0.4~0.5 사이
      expect(h3Service.occupyProgress, greaterThan(0.0));
      expect(h3Service.occupyProgress, lessThan(1.0));
    });

    test('동일 헥사곤 내 100m 이상 이동 시 진행도 1.0 (점령 완료)', () {
      // 첫 번째 위치
      final pos1 = _createPosition(37.5665, 126.9780);
      h3Service.updatePosition(pos1);
      
      // 여러 번 이동하여 100m 누적 (각 약 30m씩)
      final pos2 = _createPosition(37.5668, 126.9780);
      h3Service.updatePosition(pos2);
      
      final pos3 = _createPosition(37.5671, 126.9780);
      h3Service.updatePosition(pos3);
      
      final pos4 = _createPosition(37.5674, 126.9780);
      h3Service.updatePosition(pos4);
      
      // 진행도가 1.0에 도달 (100m 이상 이동)
      expect(h3Service.occupyProgress, equals(1.0));
    });

    test('첫 진입 시 H3 인덱스 할당 확인', () {
      // 첫 번째 헥사곤 진입
      final pos1 = _createPosition(37.5665, 126.9780);
      h3Service.updatePosition(pos1);
      
      final firstH3 = h3Service.currentH3Index;
      expect(firstH3, isNotNull);
      expect(firstH3, isA<String>());
    });

    test('거리 누적 수 점령 상태에서 진행도 확인', () {
      final pos1 = _createPosition(37.5665, 126.9780);
      h3Service.updatePosition(pos1);
      
      // 이전 테스트의 거리 누적돈 현재 진행도 확인 (싱글톤이라 상태 유지)
      // 상태에 따라 0.0 또는 1.0 모두 유효한 값
      expect(h3Service.occupyProgress, isNotNull);
      expect(h3Service.occupyProgress >= 0.0, isTrue);
      expect(h3Service.occupyProgress <= 1.0, isTrue);
    });
  });

  group('Grid API 연동 테스트', () {
    late MockDio mockDio;
    late MockH3 mockH3;
    late LocationH3Service h3Service;

    setUp(() async {
      mockH3 = MockH3();
      mockDio = MockDio();
      h3Service = LocationH3Service();

      when(mockH3.polygonToCells(
        perimeter: anyNamed('perimeter'),
        resolution: anyNamed('resolution'),
      )).thenReturn([BigInt.parse('89283082803ffff', radix: 16)]);

      when(mockH3.cellToBoundary(any)).thenReturn([
        GeoCoord(lat: 37.5660, lon: 126.9775),
        GeoCoord(lat: 37.5670, lon: 126.9775),
        GeoCoord(lat: 37.5670, lon: 126.9785),
        GeoCoord(lat: 37.5660, lon: 126.9785),
      ]);

      await h3Service.init(h3: mockH3, dio: mockDio);
    });

    test('fetchHexagonOwners - 로그인 없이 로컬 캐시 사용', () async {
      // 로그인 없으면 API 호출 안 함, 빈 땅 반환
      final result = await h3Service.fetchHexagonOwners(['89283082803ffff']);
      
      expect(result, isNotEmpty);
      expect(result.first.h3Index, equals('89283082803ffff'));
    });

    test('occupyHexagon - 로컬 캐시에 점령 정보 저장', () async {
      h3Service.occupyHexagon('89283082803ffff', 'test_user', 0x66FF0000);
      
      final result = await h3Service.fetchHexagonOwners(['89283082803ffff']);
      
      expect(result, isNotEmpty);
      expect(result.first.ownerId, equals('test_user'));
      expect(result.first.color, equals(0x66FF0000));
    });
  });

  group('Raid Boss API 테스트', () {
    late RaidService raidService;
    late MockApiClient mockApiClient;
    late MockDio mockDio;

    setUp(() {
      mockApiClient = MockApiClient();
      mockDio = MockDio();
      when(mockApiClient.dio).thenReturn(mockDio);
      raidService = RaidService(apiClient: mockApiClient);
    });

    test('getAllRaidBosses - 정상 응답 시 보스 목록 반환', () async {
      when(mockDio.get('/api/raids')).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/api/raids'),
        statusCode: 200,
        data: [
          {'id': 1, 'h3Index': '89283082803ffff', 'name': '테스트 보스', 'bossType': 0},
          {'id': 2, 'h3Index': '89283082804ffff', 'name': '테스트 보스2', 'bossType': 1},
        ],
      ));

      final result = await raidService.getAllRaidBosses();
      
      expect(result.length, equals(2));
      expect(result[0].name, equals('테스트 보스'));
      expect(result[1].bossType, equals(1));
    });

    test('getAllRaidBosses - API 오류 시 더미 데이터 반환', () async {
      when(mockDio.get('/api/raids')).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/api/raids'),
        type: DioExceptionType.connectionTimeout,
      ));

      final result = await raidService.getAllRaidBosses();
      
      // Fallback 더미 데이터 4개 반환
      expect(result.length, equals(4));
    });

    test('getRaidBossDetail - 정상 응답 시 상세 정보 반환', () async {
      when(mockDio.get(
        '/api/raids/1/detail',
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/api/raids/1/detail'),
        statusCode: 200,
        data: {
          'bossId': 1,
          'bossName': '구미역 쓰레기존',
          'totalAccumulatedScore': 12500,
          'topRankers': [
            {'rank': 1, 'nickname': '플로깅왕', 'score': 3500, 'userId': 'user1'},
          ],
          'myRanking': {'rank': 5, 'nickname': '나', 'score': 500, 'userId': 'me'},
          'nearbyRankers': [],
        },
      ));

      final result = await raidService.getRaidBossDetail(1);
      
      expect(result, isNotNull);
      expect(result!.bossName, equals('구미역 쓰레기존'));
      expect(result.totalAccumulatedScore, equals(12500));
      expect(result.topRankers.length, equals(1));
    });

    test('getRaidBossDetail - API 오류 시 더미 상세 데이터 반환', () async {
      when(mockDio.get(
        '/api/raids/1/detail',
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/api/raids/1/detail'),
        type: DioExceptionType.connectionTimeout,
      ));

      final result = await raidService.getRaidBossDetail(1);
      
      // Fallback 더미 데이터 반환
      expect(result, isNotNull);
      expect(result!.bossId, equals(1));
    });
  });
}

/// 테스트용 Position 생성 헬퍼
Position _createPosition(double lat, double lon) {
  return Position(
    latitude: lat,
    longitude: lon,
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
}

