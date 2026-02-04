import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/pixel_button.dart';
import 'package:pixelarticons/pixelarticons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

//화현이: PageView 제거하여 단일 화면으로 변경
class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  //화현이: region 제거
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwConfirmController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();

  //화현이: region 검증 및 파라미터 제거
  Future<void> _signup() async {
    // 모든 필드 검증
    if (_idController.text.isEmpty ||
        _pwController.text.isEmpty ||
        _pwConfirmController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _nicknameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 정보를 입력해주세요.')));
      return;
    }

    //화현이: 이메일 형식 검증 추가
    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 이메일 형식이 아닙니다. (@를 포함해주세요)')),
      );
      return;
    }

    if (_pwController.text != _pwConfirmController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signup(
        id: _idController.text.trim(),
        pw: _pwController.text.trim(),
        email: _emailController.text.trim(),
        nickname: _nicknameController.text.trim(),
        color: "0xFF46A140", // [Update] Default Color (Green) to match Backend requirement
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('회원가입이 완료되었습니다! 로그인해주세요.')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('회원가입 실패: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  //화현이: 단일 화면으로 변경
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SafeArea(child: _buildSignupForm()),
    );
  }

  //화현이: 단일 회원가입 폼으로 변경
  Widget _buildSignupForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'JOIN JUPDDANG',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 40),
          _buildField(
            controller: _idController,
            label: '아이디',
            icon: Pixel.user,
          ),
          const SizedBox(height: 20),
          _buildField(
            controller: _emailController,
            label: '이메일',
            icon: Pixel.mail,
            type: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildField(
            controller: _nicknameController,
            label: '닉네임',
            icon: Pixel.moodhappy,
          ),
          const SizedBox(height: 20),
          _buildField(
            controller: _pwController,
            label: '비밀번호',
            icon: Pixel.lock,
            isObscure: true,
          ),
          const SizedBox(height: 20),
          _buildField(
            controller: _pwConfirmController,
            label: '비밀번호 확인',
            icon: Icons.lock_reset_outlined,
            isObscure: true,
          ),
          const SizedBox(height: 48),
          PixelButton(
            text: 'JOIN NOW',
            isPulse: true,
            onPressed: _isLoading ? null : _signup,
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isObscure = false,
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: type,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
