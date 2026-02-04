import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import '../../../services/auth_service.dart';
import '../../home/presentation/main_screen.dart';
import '../../../widgets/pixel_button.dart';
import '../../../widgets/nes_input_field.dart';
import 'package:pixelarticons/pixelarticons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _login() async {
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();

    if (id.isEmpty || pw.isEmpty) {
      NesSnackbar.show(
        context,
        text: '아이디와 비밀번호를 입력해주세요.',
        type: NesSnackbarType.warning,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.login(id, pw);
      print("Login Success: $response");

      if (!mounted) return;

      // 로그인 성공 시 메인 화면으로 이동 (모두 지우고 이동)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      NesSnackbar.show(
        context,
        text: '로그인 실패! 아이디나 비밀번호를 확인해주세요.',
        type: NesSnackbarType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Pixel.arrowleft),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              const Text(
                'WELCOME BACK!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please sign in to continue.',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  fontSize: 14,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 56),

              // ID 입력
              NesInputField(
                controller: _idController,
                label: '아이디',
                prefixIcon: Pixel.user,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),

              // PW 입력
              NesInputField(
                controller: _pwController,
                label: '비밀번호',
                prefixIcon: Pixel.lock,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 48),

              // 로그인 버튼
              PixelButton(
                text: 'LOGIN',
                isPulse: true,
                onPressed: _isLoading ? null : _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
