import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../../../services/auth_service.dart';
import 'package:jupddang/features/social/models/follow_model.dart';
import '../../account/presentation/profile_screen.dart'; //화현이: 프로필 화면 import 추가

//화련 팔로우 리스트 스크린
class FollowListScreen extends StatefulWidget {
  final String userId;
  final int initialTab; // 0=팔로잉, 1=팔로워

  const FollowListScreen({
    super.key,
    required this.userId,
    this.initialTab = 0,
  });

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();

  List<FollowUser> _followingList = [];
  List<FollowUser> _followersList = [];
  bool _loading = true;
  //화현: 팔로잉 중인 유저 ID 추적
  final Set<String> _followingIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _loadFollowData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFollowData() async {
    setState(() => _loading = true);

    try {
      // 팔로잉 목록 가져오기
      final followingsData = await _authService.getFollowings(widget.userId);
      _followingList = followingsData
          .whereType<Map>()
          .map((item) => FollowUser.fromJson(item.cast<String, dynamic>()))
          .toList();

      // 팔로워 목록 가져오기
      final followersData = await _authService.getFollowers(widget.userId);
      _followersList = followersData
          .whereType<Map>()
          .map((item) => FollowUser.fromJson(item.cast<String, dynamic>()))
          .toList();

      // 팔로잉 중인 유저 ID 저장
      _followingIds.clear();
      _followingIds.addAll(_followingList.map((user) => user.userId));

      setState(() => _loading = false);
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('팔로우 정보를 불러오는데 실패했습니다.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                        ],
                      ),
                      child: const Icon(
                        Pixel.arrowleft,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'FOLLOW',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF17C964),
                indicatorWeight: 3,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('FOLLOWING'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF17C964),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Text(
                            _followingList.length.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('FOLLOWERS'),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF17C964),
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Text(
                            _followersList.length.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab Content
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF17C964),
                      ),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildFollowList(_followingList, 'FOLLOWING'),
                        _buildFollowList(_followersList, 'FOLLOWERS'),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowList(List<FollowUser> users, String type) {
    if (users.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 3),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(6, 6)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                type == 'FOLLOWING' ? Pixel.userplus : Pixel.users,
                color: Colors.black26,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                '팔로우 목록이 없음',
                style: const TextStyle(
                  color: Colors.black38,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 3),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(4, 4)),
            ],
          ),
          child: Row(
            children: [
              //화현이: 아바타와 사용자 정보 클릭 시 프로필 화면으로 이동
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(userId: user.userId),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: user.profileImage.isNotEmpty
                            ? Image.network(
                                user.profileImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Pixel.user,
                                    color: Color(0xFF17C964),
                                    size: 24,
                                  );
                                },
                              )
                            : const Icon(
                                Pixel.user,
                                color: Color(0xFF17C964),
                                size: 24,
                              ),
                      ),
                      const SizedBox(width: 12),

                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.nickname.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            if (user.intro.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                user.intro,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // User ID Badge + Follow Button
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Text(
                      user.userId,
                      style: const TextStyle(
                        color: Color(0xFF17C964),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Follow/Unfollow Button
                  GestureDetector(
                    onTap: () => _toggleFollow(user.userId),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _followingIds.contains(user.userId)
                            ? Colors.white
                            : const Color(0xFF17C964),
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(2, 2)),
                        ],
                      ),
                      child: Text(
                        _followingIds.contains(user.userId)
                            ? 'FOLLOWING'
                            : 'FOLLOW',
                        style: TextStyle(
                          color: _followingIds.contains(user.userId)
                              ? Colors.black54
                              : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 팔로우/언팔로우 토글
  Future<void> _toggleFollow(String targetId) async {
    final success = await _authService.toggleFollow(targetId);

    if (success) {
      setState(() {
        if (_followingIds.contains(targetId)) {
          // 언팔로우
          _followingIds.remove(targetId);
          // 팔로잉 목록에서 제거
          _followingList.removeWhere((user) => user.userId == targetId);
        } else {
          // 팔로우
          _followingIds.add(targetId);
          // 팔로워 목록에서 찾아서 팔로잉 목록에 추가
          final user = _followersList.firstWhere(
            (user) => user.userId == targetId,
            orElse: () => FollowUser(
              userId: targetId,
              nickname: '',
              profileImage: '',
              intro: '',
            ),
          );
          if (user.nickname.isNotEmpty) {
            _followingList.add(user);
          }
        }
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('팔로우 처리에 실패했습니다.')));
      }
    }
  }
}
