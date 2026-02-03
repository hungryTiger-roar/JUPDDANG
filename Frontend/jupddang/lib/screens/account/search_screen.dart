import 'package:flutter/material.dart';
import 'package:jupddang/screens/account/profile_screen.dart';

import '../../services/auth_service.dart';

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
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          '유저 검색',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '아이디를 입력하세요',
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {}); // X 버튼 누르면 화면 갱신해서 아이콘 숨기기
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) => setState(() {}),
                // 글자 칠 때마다 상태 갱신 (X버튼 처리용)
                onSubmitted: (_) => _onSearch(), // 키보드 엔터 누르면 검색
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
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // 3. 검색 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (_isLoading || _searchController.text.isEmpty)
                    ? null // 로딩 중이거나 빈칸이면 버튼 비활성화
                    : _onSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF17C964), // 줍땅 시그니처 초록색
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: const Color(0xFF2C2C2C),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        '검색',
                        style: TextStyle(
                          fontSize: 16,
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