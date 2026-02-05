import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'package:nes_ui/nes_ui.dart';

import '../../../services/auth_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false; // 로딩 상태
  String? _errorMessage; // 에러 메시지

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final AuthService _authService = AuthService();

  void _onSearch() async {
    final targetId = _searchController.text.trim();
    if (targetId.isEmpty) return;

    // 키보드 내리기
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.searchUser(targetId);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // 프로필 화면으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userId: targetId),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = "해당 계정이 없습니다. 아이디를 다시 확인해 주세요.";
      });

      print('검색 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          '계정 검색',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 24,
            letterSpacing: 2.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  0,
                ), // Pixel style usually sharp or slight radius
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                ],
              ),
              child: TextField(
                controller: _searchController,
                cursorColor: const Color(0xFF17C964),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NeoDunggeunmo',
                ),
                decoration: InputDecoration(
                  hintText: '아이디를 입력해주세요.',
                  hintStyle: const TextStyle(color: Colors.black38),
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black54,
                    size: 32,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black54),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {}); // X 버튼 누르면 화면 갱신해서 아이콘 숨기기
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) => setState(() {}),
                onSubmitted: (_) => _onSearch(),
              ),
            ),

            const SizedBox(height: 12),

            // 2. 에러 메시지 (있을 때만 보임)
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // 3. 검색 버튼 (NES Button)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: NesButton(
                type: NesButtonType.success,
                onPressed: (_isLoading || _searchController.text.isEmpty)
                    ? null
                    : _onSearch,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'SEARCH',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
