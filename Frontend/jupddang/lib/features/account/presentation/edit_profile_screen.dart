import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/pixel_character.dart';

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
  final _nicknameController = TextEditingController();
  final _introController = TextEditingController();

  bool _loading = true;
  bool _saving = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _userId = '';
  String _currentEmail = '';
  String? _currentProfileImage;
  File? _selectedImage;
  Color _selectedColor = const Color(0xFFE53935); // 기본 색상 (빨강)

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
    _nicknameController.dispose();
    _introController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    setState(() => _loading = true);

    try {
      // 내 프로필 조회 (/api/account/myprofile)
      final accountData = await _authService.getMyProfile();

      // API 응답 전체 확인
      print('📦 API 응답 전체: $accountData');
      print('📦 모든 키: ${accountData.keys}');

      setState(() {
        _userId = accountData['userId']?.toString() ?? '';
        _currentEmail = accountData['email']?.toString() ?? '';
        _currentProfileImage = accountData['profileImage']?.toString();
        _emailController.text = _currentEmail;
        _nicknameController.text = accountData['nickname']?.toString() ?? '';
        _introController.text = accountData['intro']?.toString() ?? '';

        // color 값 파싱 (hex string을 Color로 변환)
        final colorString = accountData['color']?.toString();
        print('🎨 로드된 색상 값: $colorString'); // 디버그 로그

        if (colorString != null && colorString.isNotEmpty) {
          try {
            // #을 제거하고 16진수로 파싱
            String hexColor = colorString.toUpperCase().replaceAll('#', '');
            if (hexColor.startsWith('0X')) {
              hexColor = hexColor.substring(2);
            }
            // FF(투명도) 부분 제거
            if (hexColor.length == 8) {
              hexColor = hexColor.substring(2);
            }

            // 6자리 hex 값인지 확인
            if (hexColor.length == 6) {
              final colorValue = int.parse(hexColor, radix: 16);
              _selectedColor = Color(0xFF000000 | colorValue);
              final rgbOnly = _selectedColor.value & 0x00FFFFFF;
              print('✅ 색상 파싱 성공:');
              print('   - 원본: #$hexColor');
              print('   - Color: 0x${_selectedColor.value.toRadixString(16).toUpperCase()}');
              print('   - RGB만: 0x${rgbOnly.toRadixString(16).toUpperCase()}');

              // availableColors에서 매칭되는지 확인
              final matchingColor = availableColors.firstWhere(
                (c) => (c.value & 0x00FFFFFF) == rgbOnly,
                orElse: () => _selectedColor,
              );
              if (matchingColor != _selectedColor) {
                print('   - 매칭된 색상: 0x${matchingColor.value.toRadixString(16).toUpperCase()}');
                _selectedColor = matchingColor;
              }
            } else {
              print('⚠️ 잘못된 색상 형식: $hexColor');
              _selectedColor = const Color(0xFFE53935);
            }
          } catch (e) {
            print('❌ 색상 파싱 에러: $e');
            _selectedColor = const Color(0xFFE53935); // 기본 색상 (빨강)
          }
        } else {
          print('⚠️ 색상 값이 null 또는 빈 문자열');
          _selectedColor = const Color(0xFFE53935);
        }

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

      // ARGB에서 RGB만 추출
      final rgbValue = _selectedColor.value & 0x00FFFFFF;
      final colorHex = '#${rgbValue.toRadixString(16).padLeft(6, '0').toUpperCase()}';

      print('🎨 저장할 색상: $_selectedColor');
      print('🎨 색상 value: 0x${_selectedColor.value.toRadixString(16)}');
      print('🎨 RGB 추출: 0x${rgbValue.toRadixString(16)}');
      print('🎨 최종 hex: $colorHex');

      final updates = <String, dynamic>{
        'nickname': _nicknameController.text,
        'email': _emailController.text,
        'intro': _introController.text,
        'color': colorHex,
      };

      // 2. 비밀번호는 입력했을 때만 추가
      if (_passwordController.text.isNotEmpty) {
        updates['pw'] = _passwordController.text;
      }

      // 3. 사진만 바꾸더라도 updates에 위 데이터들이 들어있으므로
      // if (updates.isEmpty) 체크에 걸리지 않고 정상 진행됩니다.

      await _authService.updateMyProfile(updates, _selectedImage);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('정보가 성공적으로 업데이트되었습니다.')));
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
      backgroundColor: Colors.white,
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
                            child: NesButton(
                              type: NesButtonType.normal,
                              onPressed: () => Navigator.pop(context),
                              child: const Icon(
                                Pixel.arrowleft,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'EDIT PROFILE',
                            style: TextStyle(
                              color: Colors.black,
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
                                child: NesContainer(
                                  width: 120,
                                  height: 120,
                                  padding: EdgeInsets.zero,
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
                            _buildSectionTitle('계정 아이디'),
                            const SizedBox(height: 8),
                            _buildReadOnlyField(_userId),

                            const SizedBox(height: 24),

                            // 닉네임
                            _buildSectionTitle('닉네임'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _nicknameController,
                              hint: '닉네임을 입력하세요',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '닉네임을 입력해주세요.';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 24),

                            // 소개
                            _buildSectionTitle('한 줄 소개'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _introController,
                              hint: '자기소개를 입력하세요',
                              maxLines: 3,
                            ),

                            const SizedBox(height: 24),

                            // 색상
                            _buildSectionTitle('내 지도 색상'),
                            const SizedBox(height: 8),
                            _buildColorPicker(),

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
                              child: NesButton(
                                type: NesButtonType.success,
                                onPressed: _saving ? null : _saveChanges,
                                child: Text(
                                  _saving ? 'SAVING...' : 'SAVE CHANGES',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
        color: Colors.black54,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return NesContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      backgroundColor: const Color(0xFFF0F0F0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),
          ),
          const Icon(Pixel.lock, color: Colors.black38, size: 20),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return NesContainer(
      padding: EdgeInsets.zero,
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38),
          filled: true,
          fillColor: const Color(0xFFF0F0F0),
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
    return NesContainer(
      padding: EdgeInsets.zero,
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38),
          filled: true,
          fillColor: const Color(0xFFF0F0F0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Pixel.eye : Pixel.eyeclosed,
              color: Colors.black38,
              size: 20,
            ),
            onPressed: onToggle,
          ),
        ),
        validator: validator,
      ),
    );
  }

  // 사용 가능한 색상 목록 (static으로 선언하여 재사용)
  static const List<Color> availableColors = [
    Color(0xFFE53935), // 빨강
    Color(0xFFFF6F00), // 주황
    Color(0xFFFBC02D), // 노랑
    Color(0xFF43A047), // 녹색
    Color(0xFF00ACC1), // 청록
    Color(0xFF1E88E5), // 파랑
    Color(0xFF5E35B1), // 보라
    Color(0xFFD81B60), // 핑크
    Color(0xFF6D4C41), // 갈색
    Color(0xFF546E7A), // 청회색
    Color(0xFF00897B), // 틸
    Color(0xFFF4511E), // 진한 주황
  ];

  Widget _buildColorPicker() {
    final colors = availableColors;

    return NesContainer(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: colors.map((color) {
          // RGB 값만 비교 (알파 채널 제외)
          final selectedRGB = _selectedColor.value & 0x00FFFFFF;
          final colorRGB = color.value & 0x00FFFFFF;
          final isSelected = selectedRGB == colorRGB;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
                print('🎨 색상 선택: 0x${color.value.toRadixString(16)}');
              });
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.black26,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: isSelected
                    ? [
                        const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 28,
                    )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
