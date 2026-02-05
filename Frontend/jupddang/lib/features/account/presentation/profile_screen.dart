import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/pixel_character.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../../social/models/community_models.dart';
import '../../social/presentation/follow_list_screen.dart';
import '../../social/presentation/my_comments_screen.dart';
import '../../../main.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with WidgetsBindingObserver, RouteAware {
  final AuthService _authService = AuthService();
  bool _loading = true;
  String _profileNickname = '';
  bool _isFollowing = false;

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
    WidgetsBinding.instance.addObserver(this);
    _loadProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // RouteObserver 구독
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 앱이 다시 활성화되면 프로필 정보 갱신
    if (state == AppLifecycleState.resumed) {
      _loadProfile();
    }
  }

  // 다른 화면에서 돌아올 때 호출됨 (중요!)
  @override
  void didPopNext() {
    // feed에서 댓글 작성 후 돌아왔을 때, 또는 다른 화면에서 돌아왔을 때 갱신
    _loadProfile();
  }

  // 이 화면으로 처음 push되었을 때 호출됨
  @override
  void didPush() {
    // 필요시 구현
  }

  // 이 화면에서 다른 화면으로 push했을 때 호출됨
  @override
  void didPushNext() {
    // 필요시 구현
  }

  // 이 화면이 pop되었을 때 호출됨
  @override
  void didPop() {
    // 필요시 구현
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);

    try {
      // 병렬로 데이터 가져오기
      final results = await Future.wait([
        _authService.getPosts(allPosts: true), // 전체 게시글 (해당 유저의 게시글 필터링을 위해)
        _authService.getMyComments(), // 내 댓글
        _authService.getProfileById(widget.userId), // 프로필 정보
      ]);

      final postsData = results[0] as List<dynamic>;
      final commentsData = results[1] as List<dynamic>;
      final profileData = results[2] as Map<String, dynamic>;

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

      // 내가 작성한 댓글 개수 (API에서 직접 가져오기)
      final commentCount = commentsData.length;

      // 받은 좋아요 수 (작성한 게시글의 likeCount 합계)
      int totalLikes = userPosts.fold(0, (sum, post) => sum + post.likeCount);

      // 팔로우 상태 확인
      bool realIsFollowing = false;
      if (AuthService.userId != null) {
        try {
          final myFollowings = await _authService.getFollowings(
            AuthService.userId!,
          );
          // 내 팔로잉 목록에 이 사람(widget.userId)이 있는지 확인!
          realIsFollowing = myFollowings.any(
            (user) =>
                user['userId'] == widget.userId ||
                user['followerId'] == widget.userId,
          );
        } catch (e) {
          print('팔로잉 목록 확인 실패: $e');
          // 실패하면 원래대로 profileData 값 사용
          realIsFollowing = profileData['isFollowing'] ?? false;
        }
      }

      final totalScore = profileData['totalScore'] ?? 0;
      final followerCount = profileData['followerCount'] ?? 0;
      final followingCount = profileData['followingCount'] ?? 0;
      final fetchedNickname = profileData['nickname'] ?? widget.userId;

      print(
        '서버 isFollowing: ${profileData['isFollowing']} / 내 검증 결과: $realIsFollowing',
      );

      setState(() {
        _profileNickname = fetchedNickname;
        _isFollowing = realIsFollowing;
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

  // 팔로우/언팔로우 토글 함수
  Future<void> _toggleFollow() async {
    if (widget.userId == AuthService.userId) return; // 내 프로필이면 무시

    // 현재 상태를 기준으로 토글
    final wasFollowing = _isFollowing;
    final currentFollowers = _stats['followers'] ?? 0;

    // UI 선반영 (Optimistic UI Update)
    setState(() {
      _isFollowing = !wasFollowing;
      if (_isFollowing) {
        _stats['followers'] = currentFollowers + 1;
      } else {
        _stats['followers'] = currentFollowers - 1;
      }
    });

    try {
      final success = await _authService.toggleFollow(widget.userId);

      // 요청 실패 시 롤백
      if (!success) {
        setState(() {
          _isFollowing = wasFollowing;
          _stats['followers'] = currentFollowers;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('요청 처리에 실패했습니다.')));
        }
      }
    } catch (e) {
      print('Follow toggle error: $e');
      // 에러 발생 시 롤백
      setState(() {
        _isFollowing = wasFollowing;
        _stats['followers'] = currentFollowers;
      });
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
                  // Header with back button
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
                          Text(
                            widget.userId.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
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
                          color: Colors.black54,
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
    return NesContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(4, 4)),
              ],
            ),
            child: const Center(
              child: PixelCharacter(size: 64, color: const Color(0xFF17C964)),
            ),
          ),

          const SizedBox(height: 16),

          // Nickname
          Text(
            (_profileNickname.isEmpty ? widget.userId : _profileNickname)
                .toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 8),

          // Tier Badge
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFFFD700),
          //     border: Border.all(color: Colors.black, width: 2),
          //   ),
          //   child: const Text(
          //     'BRONZE 5',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 12,
          //       fontWeight: FontWeight.w900,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 16),

          if (widget.userId != AuthService.userId)
            SizedBox(
              width: 140,
              child: NesButton(
                type: _isFollowing
                    ? NesButtonType.normal
                    : NesButtonType.success,
                onPressed: _toggleFollow,
                child: Center(
                  child: Text(
                    _isFollowing ? 'UNFOLLOW' : 'FOLLOW',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              Container(width: 2, height: 30, color: Colors.black12),
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
            color: Colors.black54,
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
            child: GestureDetector(
              onTap: () async {
                // 내 프로필일 때만 댓글 목록 화면으로 이동
                if (widget.userId == AuthService.userId ||
                    widget.userId == AuthService.nickname) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyCommentsScreen(userId: widget.userId),
                    ),
                  );
                  // 댓글 목록 화면에서 돌아오면 프로필 정보 갱신
                  _loadProfile();
                }
              },
              child: _statCard(Pixel.message, 'COMMENTS', _stats['comments']!),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: _statCard(Pixel.heart, 'LIKES', _stats['likes']!)),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String label, int count) {
    return NesContainer(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF17C964), size: 28),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
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
      return NesContainer(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: const [
            Icon(Pixel.file, color: Colors.black26, size: 48),
            SizedBox(height: 16),
            Text(
              '작성한 게시글이 없습니다',
              style: TextStyle(
                color: Colors.black38,
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
          color: const Color(0xFFF0F0F0),
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
                    color: Colors.white,
                    child: const Icon(
                      Pixel.image,
                      color: Colors.black26,
                      size: 32,
                    ),
                  );
                },
              )
            else
              Container(
                color: Colors.white,
                child: const Icon(Pixel.file, color: Colors.black26, size: 32),
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
