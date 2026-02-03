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
  String _profileNickname = '';

  // Mock stats - replace with actual API calls
  final Map<String, int> _stats = {
    'posts': 0,
    'comments': 0,
    'likes': 0,
    'followers': 0,
    'following': 0,
    'score': 0, //화현이: 사용자 점수 추가
  };

  //화현이: 본인 게시글 표시 및 이미지 순환을 위한 변수
  List<CommunityPost> _myPosts = [];
  bool _loadingPosts = false;
  final Map<String, int> _currentImageIndex = {}; // postId -> image index

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

      //화현이: 프로필 정보를 한 번에 가져오기 (최적화: 3번 호출 -> 1번 호출)
      final profileData = await _authService.getProfileById(widget.userId);
      final totalScore = profileData['totalScore'] ?? 0;
      final followerCount = profileData['followerCount'] ?? 0;
      final followingCount = profileData['followingCount'] ?? 0;
      final fetchedNickname = profileData['nickname'] ?? widget.userId;

      setState(() {
        _profileNickname = fetchedNickname;
        _stats['posts'] = userPosts.length;
        _stats['comments'] = commentCount;
        _stats['likes'] = totalLikes;
        _stats['followers'] = followerCount is int
            ? followerCount
            : (followerCount as num).toInt(); //화현이: follower 수
        _stats['following'] = followingCount is int
            ? followingCount
            : (followingCount as num).toInt(); //화현이: following 수
        _stats['score'] = totalScore is int
            ? totalScore
            : (totalScore as num).toInt(); //화현이: score 저장
        _loading = false;
      });

      //화현이: 본인 게시글 로드
      await _loadMyPosts();
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('프로필 정보를 불러오는데 실패했습니다.')));
      }
    }
  }

  //화현이: 본인 작성 게시글 로드
  Future<void> _loadMyPosts() async {
    setState(() => _loadingPosts = true);

    try {
      final postsData = await _authService.getMyPosts();
      final posts = postsData
          .whereType<Map>()
          .map(
            (item) => CommunityPost.fromPostJson(item.cast<String, dynamic>()),
          )
          .toList();

      // createdAt 기준 최신순 정렬
      posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _myPosts = posts;
        _loadingPosts = false;
      });
    } catch (e) {
      setState(() => _loadingPosts = false);
      print('My Posts Load Error: $e');
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
                          Text(
                            widget.userId.toUpperCase(),
                            style: const TextStyle(
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

                  // 화현이: 본인 게시글 그리드
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                      child: Text(
                        'MY POSTS',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  // Posts Grid
                  SliverToBoxAdapter(
                    child: _loadingPosts
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: CircularProgressIndicator(
                                color: Color(0xFF17C964),
                              ),
                            ),
                          )
                        : _buildPostsGrid(),
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
              (_profileNickname.isEmpty ? widget.userId : _profileNickname).toUpperCase(),
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

          const SizedBox(height: 12), //화현이: 간격 조정
          //화현이: Score 표시 추가
          Text(
            'SCORE: ${_formatNumber(_stats['score']!)}',
            style: const TextStyle(
              color: Color(0xFF17C964),
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
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

  //화현이: 숫자 천 단위 콤마 포맷 함수
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
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

  //화현이: 본인 게시글 그리드 빌더
  Widget _buildPostsGrid() {
    if (_myPosts.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(6, 6)),
          ],
        ),
        child: Column(
          children: const [
            Icon(Pixel.file, color: Colors.white24, size: 48),
            SizedBox(height: 16),
            Text(
              '작성한 게시글이 없습니다',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1,
        ),
        itemCount: _myPosts.length,
        itemBuilder: (context, index) => _buildGridItem(_myPosts[index]),
      ),
    );
  }

  //화현이: 그리드 아이템 빌더 (이미지 순환 기능 포함)
  Widget _buildGridItem(CommunityPost post) {
    // 이미지 순서: afterImageUrl → beforeImageUrl → mapImageUrl
    final List<String> availableImages = [];

    if (post.imageUrls.isNotEmpty) {
      // after 이미지 찾기
      for (var url in post.imageUrls) {
        if (url.toLowerCase().contains('after')) {
          availableImages.add(url);
          break;
        }
      }
      // before 이미지 찾기
      for (var url in post.imageUrls) {
        if (url.toLowerCase().contains('before')) {
          availableImages.add(url);
          break;
        }
      }
      // map 이미지 찾기
      for (var url in post.imageUrls) {
        if (url.toLowerCase().contains('map')) {
          availableImages.add(url);
          break;
        }
      }

      // 아무것도 없으면 모든 이미지 추가
      if (availableImages.isEmpty) {
        availableImages.addAll(post.imageUrls);
      }
    }

    // 현재 표시할 이미지 인덱스
    final currentIndex = _currentImageIndex[post.id] ?? 0;
    final imageUrl = availableImages.isNotEmpty
        ? availableImages[currentIndex % availableImages.length]
        : null;

    return GestureDetector(
      onTap: () {
        if (availableImages.isNotEmpty) {
          // 다음 이미지로 순환
          setState(() {
            _currentImageIndex[post.id] =
                (currentIndex + 1) % availableImages.length;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 이미지
            if (imageUrl != null)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF2A2A2A),
                    child: const Icon(
                      Pixel.image,
                      color: Colors.white24,
                      size: 32,
                    ),
                  );
                },
              )
            else
              Container(
                color: const Color(0xFF2A2A2A),
                child: const Icon(Pixel.file, color: Colors.white24, size: 32),
              ),

            // 좋아요 & 댓글 오버레이 (아이콘 크기 16px로 확대)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Pixel.heart, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          post.likeCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Pixel.message,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post.comments.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 이미지 순환 인디케이터 (여러 이미지가 있을 경우)
            if (availableImages.length > 1)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${currentIndex + 1}/${availableImages.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
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
