import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/pixel_character.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../../models/community_models.dart';
import 'follow_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  bool _loading = true;

  // Mock stats - replace with actual API calls
  final Map<String, int> _stats = {
    'posts': 0,
    'comments': 0,
    'likes': 0,
    'followers': 0,
    'following': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);

    try {
      // 모든 게시글 가져오기
      final postsData = await _authService.getPosts();
      final allPosts = postsData
          .whereType<Map>()
          .map(
            (item) => CommunityPost.fromPostJson(item.cast<String, dynamic>()),
          )
          .toList();

      // 해당 유저의 게시글만 필터링 (userId 또는 nickname으로)
      final userPosts = allPosts
          .where(
            (post) =>
                post.userId == widget.userId || post.nickname == widget.userId,
          )
          .toList();

      // 해당 유저가 작성한 댓글 카운트
      int commentCount = 0;
      for (var post in allPosts) {
        commentCount += post.comments
            .where((comment) => comment.nickname == widget.userId)
            .length;
      }

      // 받은 좋아요 수 (작성한 게시글의 likeCount 합계)
      int totalLikes = userPosts.fold(0, (sum, post) => sum + post.likeCount);

      //화현: 팔로워/팔로잉 수 가져오기
      final followings = await _authService.getFollowings(widget.userId);
      final followers = await _authService.getFollowers(widget.userId);

      setState(() {
        _stats['posts'] = userPosts.length;
        _stats['comments'] = commentCount;
        _stats['likes'] = totalLikes;
        _stats['followers'] = followers.length;
        _stats['following'] = followings.length;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('프로필 정보를 불러오는데 실패했습니다.')));
      }
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
                  // Header with back button
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
                            'PROFILE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 40), // Balance the back button
                        ],
                      ),
                    ),
                  ),

                  // Profile Header
                  SliverToBoxAdapter(child: _buildProfileHeader()),

                  // Stats Grid
                  SliverToBoxAdapter(child: _buildStatsGrid()),

                  // Recent Activity Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                      child: const Text(
                        'RECENT ACTIVITY',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  // Activity List (placeholder)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Coming Soon',
                          style: TextStyle(color: Colors.white38, fontSize: 14),
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

  Widget _buildProfileHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(4, 4)),
              ],
            ),
            child: const Center(
              child: PixelCharacter(size: 64, color: Colors.blueAccent),
            ),
          ),

          const SizedBox(height: 16),

          // Nickname
          Text(
            widget.userId.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          // Tier Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: const Text(
              'BRONZE 5',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 20),

          //화현: 팔로워/팔로잉 클릭 시 목록 화면으로 이동
          // Follow Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowListScreen(
                        userId: widget.userId,
                        initialTab: 1, // 팔로워 탭으로 시작
                      ),
                    ),
                  );
                },
                child: _statBadge('FOLLOWERS', _stats['followers']!),
              ),
              Container(width: 2, height: 30, color: Colors.white24),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowListScreen(
                        userId: widget.userId,
                        initialTab: 0, // 팔로잉 탭으로 시작
                      ),
                    ),
                  );
                },
                child: _statBadge('FOLLOWING', _stats['following']!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBadge(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            color: Color(0xFF17C964),
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _statCard(Pixel.file, 'POSTS', _stats['posts']!)),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(Pixel.message, 'COMMENTS', _stats['comments']!),
          ),
          const SizedBox(width: 12),
          Expanded(child: _statCard(Pixel.heart, 'LIKES', _stats['likes']!)),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String label, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF17C964), size: 28),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
