import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/pixel_button.dart';
import 'package:pixelarticons/pixelarticons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwConfirmController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _regionController = TextEditingController();

  Future<void> _signup() async {
    if (_regionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('지역을 입력해주세요.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signup(
        id: _idController.text.trim(),
        pw: _pwController.text.trim(),
        email: _emailController.text.trim(),
        nickname: _nicknameController.text.trim(),
        region: _regionController.text.trim(),
        profileImage: "",
        intro: "",
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

  void _nextStep() {
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

    if (_pwController.text != _pwConfirmController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('비밀번호가 일치하지 않습니다.')));
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Pixel.arrowleft),
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / 2,
                backgroundColor: Colors.black,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF1DCE70),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [_buildStep1(), _buildStep2()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BASIC INFO',
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
          PixelButton(text: 'NEXT STEP', onPressed: _nextStep),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YOUR REGION',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 40),
          _buildField(
            controller: _regionController,
            label: '지역 (예: 서울 강남구)',
            icon: Pixel.map,
          ),
          const SizedBox(height: 48),
          PixelButton(text: 'JOIN NOW', onPressed: _isLoading ? null : _signup),
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
