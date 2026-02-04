import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../widgets/pixel_button.dart';
import '../../widgets/pixel_character.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _userId = '';
  String _currentEmail = '';
  String? _currentProfileImage;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('이미지 선택 실패: $e')));
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    setState(() => _loading = true);

    try {
      // 내 프로필 조회 (/api/account/myprofile)
      final accountData = await _authService.getMyProfile();

      setState(() {
        _userId = accountData['userId']?.toString() ?? '';
        _currentEmail = accountData['email']?.toString() ?? '';
        _currentProfileImage = accountData['profileImage']?.toString();
        _emailController.text = _currentEmail;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('사용자 정보를 불러오는데 실패했습니다: $e')));
      }
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      // 1. 모든 필드를 현재 값으로 채운 updates 맵 생성
      // 서버의 AccountUpdateRequest 필드명과 정확히 일치해야 합니다.
      final updates = <String, dynamic>{
        'nickname': _userId,             // 현재 닉네임 (또는 별도 저장된 변수)
        'email': _emailController.text,  // 현재 입력된 이메일
        'intro': '플로깅 좋아합니다!',     // 기존 소개글 (변수로 관리 권장)
        'color': '#FFFFFF',              // 기본값 또는 기존 색상
      };

      // 2. 비밀번호는 입력했을 때만 추가
      if (_passwordController.text.isNotEmpty) {
        updates['pw'] = _passwordController.text;
      }

      // 3. 사진만 바꾸더라도 updates에 위 데이터들이 들어있으므로
      // if (updates.isEmpty) 체크에 걸리지 않고 정상 진행됩니다.

      await _authService.updateMyProfile(updates, _selectedImage);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('정보가 성공적으로 업데이트되었습니다.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // 에러 처리...
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF17C964)),
            )
          : SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F1F1F),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Pixel.arrowleft,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'EDIT PROFILE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ),

                  // Form
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 프로필 이미지
                            _buildSectionTitle('프로필 이미지'),
                            const SizedBox(height: 16),
                            Center(
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1F1F1F),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(6, 6),
                                      ),
                                    ],
                                  ),
                                  child: _selectedImage != null
                                      ? Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : _currentProfileImage != null &&
                                            _currentProfileImage!.isNotEmpty
                                      ? Image.network(
                                          _currentProfileImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : const Center(
                                          child: PixelCharacter(
                                            size: 80,
                                            color: Colors.blue,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: TextButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(
                                  Pixel.camera,
                                  color: Color(0xFF17C964),
                                  size: 16,
                                ),
                                label: const Text(
                                  'Change Photo',
                                  style: TextStyle(color: Color(0xFF17C964)),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // 아이디 (읽기 전용)
                            _buildSectionTitle('아이디'),
                            const SizedBox(height: 8),
                            _buildReadOnlyField(_userId),

                            const SizedBox(height: 24),

                            // 비밀번호
                            _buildSectionTitle('비밀번호 변경'),
                            const SizedBox(height: 8),
                            _buildPasswordField(
                              controller: _passwordController,
                              hint: '새 비밀번호 (변경 시에만 입력)',
                              obscure: _obscurePassword,
                              onToggle: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),

                            const SizedBox(height: 12),

                            _buildPasswordField(
                              controller: _confirmPasswordController,
                              hint: '비밀번호 확인',
                              obscure: _obscureConfirmPassword,
                              onToggle: () => setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              ),
                              validator: (value) {
                                if (_passwordController.text.isNotEmpty &&
                                    value != _passwordController.text) {
                                  return '비밀번호가 일치하지 않습니다.';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 24),

                            // 이메일
                            _buildSectionTitle('이메일'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _emailController,
                              hint: 'example@email.com',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '이메일을 입력해주세요.';
                                }
                                if (!value.contains('@')) {
                                  return '올바른 이메일 형식이 아닙니다.';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 40),

                            // 저장 버튼
                            SizedBox(
                              width: double.infinity,
                              child: PixelButton(
                                text: _saving ? 'SAVING...' : 'SAVE CHANGES',
                                onPressed: _saving ? null : _saveChanges,
                                height: 56,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ),
          const Icon(Pixel.lock, color: Colors.white38, size: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: const Color(0xFF1F1F1F),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: const Color(0xFF1F1F1F),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Pixel.eye : Pixel.eyeclosed,
              color: Colors.white38,
              size: 20,
            ),
            onPressed: onToggle,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
