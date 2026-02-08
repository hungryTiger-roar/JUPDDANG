import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jupddang/features/plogging/presentation/map_screen.dart';
import 'package:jupddang/features/ranking/presentation/ranking_screen.dart';
import 'package:jupddang/features/social/presentation/feed.dart';
import 'package:jupddang/features/fcm/data/fcm_service.dart';
import 'package:jupddang/features/party/presentation/party_screen.dart';
import 'package:jupddang/features/account/presentation/settings_screen.dart';
import 'package:jupddang/features/account/presentation/profile_screen.dart';
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
  final GlobalKey<State<CommunityScreen>> _communityKey = GlobalKey<State<CommunityScreen>>(); // 🎯 커뮤니티 스크롤 제어용
  StreamSubscription<Map<String, dynamic>>? _notificationSub;

  @override
  void initState() {
    super.initState();
    final fcm = FcmService();
    _notificationSub = fcm.notificationTapStream.listen(_handleNotificationTap);
    final pending = fcm.consumePendingTapData();
    if (pending != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotificationTap(pending);
      });
    }
  }

  @override
  void dispose() {
    _notificationSub?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) async {
    // 🎯 커뮤니티 탭을 다시 누르면 스크롤을 맨 위로 이동
    if (_selectedIndex == 0 && index == 0) {
      final communityState = _communityKey.currentState;
      if (communityState != null) {
        try {
          (communityState as dynamic).scrollToTop();
        } catch (e) {
          // scrollToTop 메서드가 없을 경우 무시
        }
      }
      return;
    }

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
  Future<void> _handleNotificationTap(Map<String, dynamic> data) async {
    final type = data['type']?.toString();
    if (type == 'NEW_COMMENT') {
      final postId = data['postId']?.toString();
      await _focusCommunityPost(postId);
      if (postId != null) {
        final communityState = _communityKey.currentState;
        if (communityState != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            try {
              await (communityState as dynamic).openCommentsByPostId(postId);
            } catch (_) {}
          });
        }
      }
      return;
    }
    if (type == 'FOLLOW' || type == 'NEW_FOLLOWER' || type == 'FOLLOWER_ADDED') {
      final followerId =
          data['followerId']?.toString() ??
          data['fromUserId']?.toString() ??
          data['userId']?.toString() ??
          data['targetId']?.toString();
      if (followerId != null && followerId.isNotEmpty) {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(userId: followerId),
          ),
        );
      } else {
        await _focusCommunityPost(null);
      }
      return;
    }
    if (type == 'PLOGGING_COMPLETE') {
      final postId = data['postId']?.toString();
      await _focusCommunityPost(postId);
      return;
    }
    await _focusCommunityPost(null);
  }

  Future<void> _focusCommunityPost(String? postId) async {
    final communityState = _communityKey.currentState;
    if (communityState != null) {
      try {
        await (communityState as dynamic).refreshAndFocus(postId);
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() {
      _ploggingResult = postId;
      _selectedIndex = 0;
    });
  }

  Future<void> _setPloggingResult(dynamic result) async {
    final String? postId = result is String ? result as String? : null;
    final communityState = _communityKey.currentState;
    if (communityState != null) {
      try {
        await (communityState as dynamic).refreshAndFocus(postId);
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _ploggingResult = result;
      _selectedIndex = 0; // 커뮤니티 탭으로 자동 이동
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 화면 리스트를 build 메서드 내부에서 생성 (상태 업데이트 반영)
    final String? focusPostId =
        _ploggingResult is String ? _ploggingResult as String? : null;
    final List<Widget> screens = [

      CommunityScreen(
        key: _communityKey,
        focusPostId: focusPostId,
        onFocusHandled: _onPloggingResultProcessed,
      ),
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






