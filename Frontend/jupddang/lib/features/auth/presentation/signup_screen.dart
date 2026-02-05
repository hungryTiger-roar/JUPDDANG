import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/pixel_button.dart';
import '../../../widgets/nes_input_field.dart';
import 'package:pixelarticons/pixelarticons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwConfirmController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();

  Future<void> _signup() async {
    // 모든 필드 검증
    if (_idController.text.isEmpty ||
        _pwController.text.isEmpty ||
        _pwConfirmController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _nicknameController.text.isEmpty) {
      NesSnackbar.show(
        context,
        text: '모든 정보를 입력해주세요.',
        type: NesSnackbarType.warning,
      );
      return;
    }

    // 이메일 형식 검증 추가
    if (!_emailController.text.contains('@')) {
      NesSnackbar.show(
        context,
        text: '올바른 이메일 형식이 아닙니다. (@를 포함해주세요)',
        type: NesSnackbarType.warning,
      );
      return;
    }

    if (_pwController.text != _pwConfirmController.text) {
      NesSnackbar.show(
        context,
        text: '비밀번호가 일치하지 않습니다.',
        type: NesSnackbarType.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signup(
        id: _idController.text.trim(),
        pw: _pwController.text.trim(),
        email: _emailController.text.trim(),
        nickname: _nicknameController.text.trim(),
        color: "0xFF46A140", // Default Color (Green)
      );

      if (!mounted) return;
      NesSnackbar.show(
        context,
        text: '회원가입이 완료되었습니다! 로그인해주세요.',
        type: NesSnackbarType.success,
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      NesSnackbar.show(
        context,
        text: '회원가입 실패: $e',
        type: NesSnackbarType.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Pixel.arrowleft, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              const Text(
                'JOIN JUPDDANG',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              NesInputField(
                controller: _idController,
                label: '아이디',
                prefixIcon: Pixel.user,
              ),
              const SizedBox(height: 16),
              NesInputField(
                controller: _emailController,
                label: '이메일',
                prefixIcon: Pixel.mail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              NesInputField(
                controller: _nicknameController,
                label: '닉네임',
                prefixIcon: Pixel.moodhappy,
              ),
              const SizedBox(height: 16),
              NesInputField(
                controller: _pwController,
                label: '비밀번호',
                prefixIcon: Pixel.lock,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              NesInputField(
                controller: _pwConfirmController,
                label: '비밀번호 확인',
                prefixIcon: Icons.lock_reset_outlined,
                obscureText: true,
              ),
              const SizedBox(height: 48),
              PixelButton(
                text: 'JOIN NOW',
                isPulse: true,
                onPressed: _isLoading ? null : _signup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
