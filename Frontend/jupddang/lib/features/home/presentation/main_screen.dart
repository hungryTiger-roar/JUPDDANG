import 'package:flutter/material.dart';
import 'package:jupddang/features/plogging/presentation/map_screen.dart';
import 'package:jupddang/features/ranking/presentation/ranking_screen.dart';
import 'package:jupddang/features/social/presentation/feed.dart';
import 'package:jupddang/features/party/presentation/party_screen.dart';
import 'package:jupddang/features/account/presentation/settings_screen.dart';
import '../../../widgets/custom_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // 초기 화면: 지도 (인덱스 2)
  dynamic _ploggingResult; // 🎯 플로깅 결과 저장
  final GlobalKey<NavigatorState> _mapNavigatorKey = GlobalKey<NavigatorState>(); // 🎯 맵 네비게이터 키

  void _onItemTapped(int index) async {
    // 🎯 맵 화면에서 다른 탭으로 이동할 때 플로깅 완료 확인
    if (_selectedIndex == 2 && index != 2) {
      // 맵 화면의 네비게이터에서 결과를 받아올 수 있도록 처리
      // 만약 맵 화면이 전체 화면으로 띄워졌다면 결과가 자동으로 전달됨
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  // 🎯 플로깅 결과 처리 완료 콜백
  void _onPloggingResultProcessed() {
    setState(() {
      _ploggingResult = null;
    });
  }

  // 🎯 플로깅 결과 설정 메서드 (MapScreen에서 호출)
  void _setPloggingResult(dynamic result) {
    setState(() {
      _ploggingResult = result;
      _selectedIndex = 0; // 커뮤니티 탭으로 자동 이동
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 화면 리스트를 build 메서드 내부에서 생성 (상태 업데이트 반영)
    final List<Widget> screens = [
      CommunityScreen(),
      const PartyScreen(),
      MapScreen(
        onPloggingComplete: _setPloggingResult, // 🎯 콜백 전달
      ),
      const RankingScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      extendBody: false,
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}