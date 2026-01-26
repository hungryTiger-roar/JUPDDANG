import 'package:flutter/material.dart';
import 'package:jupddang/screens/map/map_screen.dart';
import 'package:jupddang/screens/record/ranking_screen.dart';
import 'package:jupddang/screens/feed/feed.dart'; // import 추가
import 'package:jupddang/screens/party/party_screen.dart'; // import 추가
import 'package:jupddang/screens/account/settings_screen.dart'; // import 추가
import '../../widgets/custom_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // 초기 화면: 지도 (인덱스 2)

  // 각 탭에 연결될 화면 리스트 (5개)
  final List<Widget> _screens = [
    const CommunityScreen(), // 0
    const PartyScreen(), // 1
    const MapScreen(), // 2
    const RankingScreen(), // 3
    const SettingsScreen(), // 4
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack을 사용하여 화면 전환 시 상태 유지 (지도가 매번 리로딩되지 않도록 함)
      extendBody: true, // 지도가 바 아래까지 확장되도록 설정 (투명 배경 효과)
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
