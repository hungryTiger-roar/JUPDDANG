import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // PageView Controller
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Step 1 Controllers
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwConfirmController = TextEditingController();
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();

  // Step 2 Controllers
  final _regionController = TextEditingController();
  // final _introController = TextEditingController(); // 미사용

  // 이미지 처리를 위한 변수 (미사용)
  // File? _imageFile;
  // final ImagePicker _picker = ImagePicker();

  // 이미지 선택 함수 (미사용)
  /*
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Image picker error: $e');
    }
  }

  // 이미지 소스 선택 다이얼로그 (카메라/갤러리/기본)
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF212121),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  '갤러리에서 선택',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  '카메라로 촬영',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              if (_imageFile != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.redAccent),
                  title: const Text(
                    '기본 이미지로 변경',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _imageFile = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }
  */

  Future<void> _signup() async {
    // 최종 검증 (Step 2)
    if (_regionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('지역을 입력해주세요.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // NOTE: 현재 백엔드 로직 변경으로 프로필 이미지와 자기소개는 제외하고 가입합니다.
      // 추후 필요 시 복구 예정.

      final response = await _authService.signup(
        id: _idController.text.trim(),
        pw: _pwController.text.trim(),
        email: _emailController.text.trim(),
        nickname: _nicknameController.text.trim(),
        region: _regionController.text.trim(),
        profileImage: "",
        intro: "",
      );

      // AccountResponse 확인 (서버 응답 로그 출력)
      print("========== 회원가입 성공 ==========");
      print("응답 데이터 전체: $response");
      if (response is Map) {
        print("userId: ${response['userId']}");
        print("email: ${response['email']}");
        print("nickname: ${response['nickname']}");
        print("address: ${response['address']}");
        print("createdAt: ${response['createdAt']}");
      }
      print("==================================");

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('회원가입이 완료되었습니다! 로그인해주세요.')));
      Navigator.pop(context);
    } catch (e) {
      print("========== 회원가입 실패 ==========");
      print("에러 타입: ${e.runtimeType}");
      print("에러 내용: $e");
      print("==================================");

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('회원가입 실패: ${e.toString()}')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _nextStep() {
    // Step 1 Validation
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
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_currentPage == 1) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _currentPage == 0 ? '회원가입 (1/2)' : '회원가입 (2/2)',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // 스와이프 방지
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [_buildStep1(), _buildStep2()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '기본 정보를 입력해주세요',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _buildTextField(controller: _idController, label: '아이디'),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _pwController,
            label: '비밀번호',
            isObscure: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _pwConfirmController,
            label: '비밀번호 확인',
            isObscure: true,
          ),
          const SizedBox(height: 16),
          _buildTextField(controller: _emailController, label: '이메일'),
          const SizedBox(height: 16),
          _buildTextField(controller: _nicknameController, label: '닉네임'),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAFF6A),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '다음',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '추가 정보를 입력해주세요',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _buildTextField(
            controller: _regionController,
            label: '지역 (예: 서울 강남구)',
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signup,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAFF6A),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      '회원가입 완료',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isObscure = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
