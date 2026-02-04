import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import '../../auth/presentation/splash_screen.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'profile_screen.dart';
import 'edit_profile_screen.dart';
import '../../../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SETTINGS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'MANAGE YOUR ACCOUNT',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Spacer(),
                        //화현: 로그아웃 버튼
                        GestureDetector(
                          onTap: () => _showLogoutDialog(context),
                          child: NesButton(
                            type: NesButtonType.normal,
                            onPressed: () => _showLogoutDialog(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Pixel.power,
                                  color: Colors.black,
                                  size: 14,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'LOGOUT',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Profile Section (Clickable)
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(userId: AuthService.userId ?? 'Guest'),
                    ),
                  );
                },
                child: NesContainer(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: const Icon(
                          Pixel.user,
                          color: Color(0xFF17C964),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (AuthService.userId ?? 'Guest').toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'View Profile',
                              style: TextStyle(
                                color: Color(0xFF17C964),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Pixel.chevronright,
                        color: Colors.white38,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Settings Grid Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: const Text(
                  'QUICK SETTINGS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // 2x2 Settings Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Row 1
                    Row(
                      children: [
                        Expanded(
                          child: _settingTile(
                            context,
                            icon: Pixel.edit,
                            label: '개인정보\n변경',
                            color: const Color(0xFF17C964),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfileScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _settingTile(
                            context,
                            icon: Pixel.notification,
                            label: '알림\n설정',
                            color: const Color(0xFF3B82F6),
                            onTap: () => _showComingSoon(context, '알림 설정'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Row 2
                    Row(
                      children: [
                        Expanded(
                          child: _settingTile(
                            context,
                            icon: Pixel.infobox,
                            label: '앱\n정보',
                            color: const Color(0xFFFBBF24),
                            onTap: () => _showAppInfo(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _settingTile(
                            context,
                            icon: Pixel.logout,
                            label: '회원\n탈퇴',
                            color: const Color(0xFFEF4444),
                            onTap: () => _showDeleteDialog(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _settingTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: NesContainer(
        height: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => NesDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Coming Soon',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '$feature 기능은 곧 추가될 예정입니다!',
              style: const TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            NesButton(
              type: NesButtonType.primary,
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NesDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'App Info',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'JupDDang',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            const Text(
              '© 2026 JupDDang Team',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 16),
            NesButton(
              type: NesButtonType.primary,
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NesDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Account Deletion',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '정말로 회원 탈퇴를 진행하시겠습니까?\n\n모든 데이터가 삭제되며 복구할 수 없습니다.',
              style: TextStyle(color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NesButton(
                  type: NesButtonType.normal,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                NesButton(
                  type: NesButtonType.error,
                  onPressed: () async {
                    // ... implementation retained but needs context copy ...
                    // Since the original code had complex logic inside onPressed,
                    // I will simplify this chunk replacement to just the UI part
                    // and keep logic if possible.
                    // But replacement chunk must contain the Logic.

                    // RE-INSERTING LOGIC CAREFULLY
                    final originalContext = context;
                    Navigator.pop(context);

                    showDialog(
                      context: originalContext,
                      barrierDismissible: false,
                      builder: (dialogContext) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF17C964),
                        ),
                      ),
                    );

                    final authService = AuthService();
                    final success = await authService.deleteAccount();

                    if (originalContext.mounted) {
                      Navigator.of(originalContext).pop();
                    }

                    if (success) {
                      if (originalContext.mounted) {
                        Navigator.of(originalContext).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    } else {
                      if (originalContext.mounted) {
                        NesSnackbar.show(
                          originalContext,
                          text: '회원 탈퇴에 실패했습니다. 다시 시도해주세요',
                          type: NesSnackbarType.error,
                        );
                      }
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //화현: 로그아웃 다이얼로그
  //화현: 로그아웃 다이얼로그
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NesDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '정말 로그아웃 하시겠습니까?',
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NesButton(
                  type: NesButtonType.normal,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                NesButton(
                  type: NesButtonType.warning,
                  onPressed: () {
                    Navigator.pop(context);
                    // JWT 토큰 삭제
                    AuthService.accessToken = null;
                    AuthService.userId = null;
                    AuthService.nickname = null;
                    // 스플래시 화면으로 이동 (뒤로가기 방지)
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const SplashScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
