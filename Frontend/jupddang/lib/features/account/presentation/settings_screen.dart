import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import '../../auth/presentation/splash_screen.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'profile_screen.dart';
import 'edit_profile_screen.dart';
import '../../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    const Text(
                      'SETTINGS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text(
                          'MANAGE YOUR ACCOUNT',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const Spacer(),
                        // 화현: 로그아웃 버튼
                        GestureDetector(
                          onTap: () => _showLogoutDialog(context),
                          child: NesButton(
                            type: NesButtonType.normal,
                            onPressed: () => _showLogoutDialog(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
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
                                    fontSize: 14,
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

            // My Profile Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: const Text(
                  'MY PROFILE',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // Profile Section (Clickable) - 괄호 오류 수정됨
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            userId: AuthService.userId ?? 'Guest'),
                      ),
                    );
                    // 프로필 화면에서 돌아온 후 UI 업데이트
                    if (mounted) setState(() {});
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
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: AuthService.profileImage != null &&
                                  AuthService.profileImage!.isNotEmpty
                              ? ClipRect(
                                  child: Image.network(
                                    AuthService.profileImage!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Pixel.user,
                                        color: Color(0xFF17C964),
                                        size: 32,
                                      );
                                    },
                                  ),
                                )
                              : const Icon(
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
                                  color: Colors.black,
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
                          color: Colors.black26,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Settings Grid Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                child: const Text(
                  'QUICK SETTINGS',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // Settings List (3 rows)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // 개인정보 변경
                    _settingTileHorizontal(
                      context,
                      icon: Pixel.edit,
                      label: '개인정보 변경',
                      color: const Color(0xFF17C964),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                        // 프로필 수정 후 돌아오면 UI 업데이트
                        if (result == true && mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // 앱 정보
                    _settingTileHorizontal(
                      context,
                      icon: Pixel.infobox,
                      label: '앱 정보',
                      color: const Color(0xFFFBBF24),
                      onTap: () => _showAppInfo(context),
                    ),
                    const SizedBox(height: 16),
                    // 회원 탈퇴
                    _settingTileHorizontal(
                      context,
                      icon: Pixel.logout,
                      label: '회원 탈퇴',
                      color: const Color(0xFFEF4444),
                      onTap: () => _showDeleteDialog(context),
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

  Widget _settingTileHorizontal(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: NesContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Icon(Pixel.chevronright, color: Colors.black26, size: 20),
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
              type: NesButtonType.success,
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                      Navigator.of(originalContext).pop(); // 로딩 닫기
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
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 화현: 로그아웃 다이얼로그
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
                    // JWT 토큰 삭제 및 정보 초기화
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
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}