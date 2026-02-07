import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/pixel_character.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../../social/models/community_models.dart';
import '../../social/presentation/follow_list_screen.dart';
import '../../social/presentation/my_comments_screen.dart';
import '../../../main.dart';
import '../../../core/utils/tier_utils.dart';
import '../../ranking/data/ranking_service.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with WidgetsBindingObserver, RouteAware {
  final AuthService _authService = AuthService();
  final RankingService _rankingService = RankingService();
  bool _loading = true;
  String _profileNickname = '';
  String? _profileImage; // 프로필 이미지 URL
  String _intro = ''; // 한줄 소개
  String _realUserId = ''; // 실제 userId
  bool _isFollowing = false;
  String _tier = ''; // 티어 정보

  // Mock stats - replace with actual API calls
  final Map<String, int> _stats = {
    'posts': 0,
    'comments': 0,
    'likes': 0,
    'followers': 0,
    'following': 0,
  };

  // 본인 게시글 표시 및 이미지 순환을 위한 변수
  List<CommunityPost> _myPosts = [];
  bool _loadingPosts = false;
  final Map<String, int> _currentImageIndex = {}; // postId -> image index
  bool _isGridView = true; // 그리드/피드 뷰 토글
  final Set<String> _likedPostIds = {}; // 좋아요한 게시글 ID
  Set<String> _totalTop3UserIds = {}; // 누적 랭킹 top 3 userId 저장

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTopRanking(); // 누적 랭킹 top 3 로드
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
      final fetchedUserId = profileData['userId'] ?? widget.userId; // 실제 userId
      final profileImageUrl = profileData['profileImage'] as String?; // 프로필 이미지 URL
      final introText = profileData['intro'] ?? ''; // 한줄 소개
      final tierInfo = profileData['tier'] ?? ''; // 티어 정보

      print(
        '서버 isFollowing: ${profileData['isFollowing']} / 내 검증 결과: $realIsFollowing',
      );

      setState(() {
        _profileNickname = fetchedNickname;
        _realUserId = fetchedUserId; // 실제 userId 저장
        _profileImage = profileImageUrl; // 프로필 이미지 저장
        _intro = introText; // 한줄 소개 저장
        _tier = tierInfo; // 티어 정보 저장
        _isFollowing = realIsFollowing;
        _stats['posts'] = userPosts.length;
        _stats['comments'] = commentCount;
        _stats['likes'] = totalLikes;
        _stats['followers'] = followerCount is int
            ? followerCount
            : (followerCount as num).toInt(); // follower 수
        _stats['following'] = followingCount is int
            ? followingCount
            : (followingCount as num).toInt(); // following 수
        _loading = false;

        // userPosts를 _myPosts에 직접 저장
        _myPosts = userPosts;
        _loadingPosts = false;
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

  // 누적 랭킹 top 3 userId 로드
  Future<void> _loadTopRanking() async {
    try {
      final totalRanking = await _rankingService.getTotalRanking();
      setState(() {
        _totalTop3UserIds = totalRanking.topRankers
            .take(3)
            .map((ranker) => ranker.userId)
            .toSet();
      });
    } catch (e) {
      print('❌ Failed to fetch total ranking for legend badges: $e');
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
      // 실제 userId를 사용하여 팔로우 요청
      final targetId = _realUserId.isNotEmpty ? _realUserId : widget.userId;
      print('팔로우 요청: targetId=$targetId, widget.userId=${widget.userId}');
      final success = await _authService.toggleFollow(targetId);

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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: _buildProfileHeader(),
                    ),
                  ),

                  // 본인 게시글 헤더 (타이틀 + 토글 버튼)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '내 게시물',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          // 그리드/피드 토글 버튼
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isGridView = true;
                                  });
                                },
                                icon: Icon(
                                  Pixel.grid,
                                  size: 20,
                                  color: _isGridView ? Colors.black : Colors.black38,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isGridView = false;
                                  });
                                },
                                icon: Icon(
                                  Pixel.list,
                                  size: 20,
                                  color: !_isGridView ? Colors.black : Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Posts Grid or Feed
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
                        : _isGridView ? _buildPostsGrid() : _buildPostsFeed(),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 60)),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return NesContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인스타그램 스타일: 왼쪽 프로필 사진, 오른쪽 통계
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar (왼쪽)
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
                child: _profileImage != null && _profileImage!.isNotEmpty
                    ? ClipRect(
                        child: Image.network(
                          _profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: PixelCharacter(
                                size: 48,
                                color: Color(0xFF17C964),
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: PixelCharacter(
                          size: 48,
                          color: Color(0xFF17C964),
                        ),
                      ),
              ),

              const SizedBox(width: 10),

              // Stats (오른쪽)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    // 티어 뱃지 + 티어명 (가로 배치)
                    if (_tier.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Image.asset(
                              TierUtils.getTierBadgePath(_tier),
                              width: 30,
                              height: 30,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox(width: 40, height: 40);
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _tier,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    if (_tier.isNotEmpty) const SizedBox(height: 1),
                    // 닉네임 (게시물 텍스트와 시작점 맞춤)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        (_profileNickname.isEmpty ? widget.userId : _profileNickname)
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // 게시글, 팔로워, 팔로잉 수
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn('게시물', _stats['posts']!),
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
                          child: _buildStatColumn('팔로워', _stats['followers']!),
                        ),
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
                          child: _buildStatColumn('팔로잉', _stats['following']!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // 한줄 소개 (intro)
          if (_intro.isNotEmpty)
            Text(
              _intro,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

          // 팔로우/언팔로우 버튼 (다른 사용자 프로필일 때만)
          if (widget.userId != AuthService.userId)
            const SizedBox(height: 16),
          if (widget.userId == AuthService.userId && _intro.isNotEmpty)
            const SizedBox(height: 1),
          if (widget.userId != AuthService.userId) ...[
            const SizedBox(height: 1),
            SizedBox(
              width: double.infinity,
              child: NesButton(
                type: _isFollowing
                    ? NesButtonType.normal
                    : NesButtonType.success,
                onPressed: _toggleFollow,
                child: Center(
                  child: Text(
                    _isFollowing ? 'UNFOLLOW' : 'FOLLOW',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 통계 컬럼 (게시글, 팔로워, 팔로잉)
  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          _formatNumber(count),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // 숫자 천 단위 콤마 포맷 함수
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // 본인 게시글 그리드 빌더
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

  // 그리드 아이템 빌더 (이미지 순환 기능 포함)
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

  // 피드 형식으로 게시글 표시
  Widget _buildPostsFeed() {
    if (_myPosts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: NesContainer(
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
        ),
      );
    }

    return Column(
      children: _myPosts.map((post) => _buildFeedItem(post)).toList(),
    );
  }

  // 피드 아이템 (feed.dart의 _buildPostCard와 동일)
  Widget _buildFeedItem(CommunityPost post) {
    final String currentUserId = AuthService.userId?.toString() ?? '';
    final String postUserId = post.userId?.toString() ?? '';
    final isMine = postUserId.isNotEmpty && postUserId == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: NesContainer(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      final targetId = post.userId?.isNotEmpty == true
                          ? post.userId!
                          : post.nickname;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(userId: targetId),
                        ),
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2.0),
                      ),
                      child: post.profileImage != null && post.profileImage!.isNotEmpty
                          ? ClipRect(
                              child: Image.network(
                                post.profileImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: PixelCharacter(
                                      size: 24,
                                      color: _getColorForNickname(post.nickname),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: PixelCharacter(
                                size: 24,
                                color: _getColorForNickname(post.nickname),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (post.tier.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Image.asset(
                                  _totalTop3UserIds.contains(post.userId)
                                      ? TierUtils.getTierBadgePath('legend')
                                      : TierUtils.getTierBadgePath(post.tier),
                                  width: 28,
                                  height: 28,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(width: 28, height: 28);
                                  },
                                ),
                              ),
                            Flexible(
                              child: Text(
                                post.nickname.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatPostTime(post.createdAt).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Images
            if (post.imageUrls.isNotEmpty) _buildPostImages(post),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: _buildPostContent(post),
            ),

            // Actions (좋아요, 댓글)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Row(
                children: [
                  _actionButton(
                    Pixel.heart,
                    post.likeCount.toString(),
                    onTap: () => _toggleLike(post),
                    isActive: _likedPostIds.contains(post.id),
                  ),
                  const SizedBox(width: 20),
                  _actionButton(
                    Pixel.message,
                    post.comments.length.toString(),
                    onTap: () => _showComments(post),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPostTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return '방금';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';

    return '${time.month}/${time.day}';
  }

  // feed.dart와 동일한 메서드들
  Widget _actionButton(
    IconData icon,
    String label, {
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 200),
            tween: Tween(begin: 1.0, end: isActive ? 1.3 : 1.0),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Icon(
                  icon,
                  color: isActive && icon == Pixel.heart
                      ? Colors.redAccent
                      : (isActive ? const Color(0xFF17C964) : Colors.black38),
                  size: 22,
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleLike(CommunityPost post) async {
    if (AuthService.accessToken == null) return;

    setState(() {
      final idx = _myPosts.indexWhere((p) => p.id == post.id);
      if (idx != -1) {
        final currentPost = _myPosts[idx];
        if (_likedPostIds.contains(post.id)) {
          _likedPostIds.remove(post.id);
          _myPosts[idx] = currentPost.copyWith(
            likeCount: currentPost.likeCount - 1,
          );
        } else {
          _likedPostIds.add(post.id);
          _myPosts[idx] = currentPost.copyWith(
            likeCount: currentPost.likeCount + 1,
          );
          _authService
              .likePost(post.id)
              .catchError((e) => print('Like error: $e'));
        }
      }
    });
  }

  void _showComments(CommunityPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints.loose(
        Size.fromHeight(MediaQuery.of(context).size.height * 0.9),
      ),
      builder: (context) => _CommentBottomSheet(
        post: post,
        authService: _authService,
        onCommentAdded: () => _loadProfile(),
        totalTop3UserIds: _totalTop3UserIds,
      ),
    );
  }

  Widget _buildPostImages(CommunityPost post) {
    final images = post.imageUrls;
    if (images.isEmpty) return const SizedBox.shrink();

    final currentIndex = _currentImageIndex[post.id] ?? 0;

    // 이미지가 정확히 2개인 경우 (전/후 이미지로 간주), 나란히 라벨과 함께 표시
    if (images.length == 2) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _currentImageIndex[post.id] = (currentIndex + 1) % images.length;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Expanded(child: _labeledImage(images[0], '전')),
                const SizedBox(width: 4),
                Expanded(child: _labeledImage(images[1], '후')),
              ],
            ),
          ),
        ),
      );
    }

    // 단일 이미지 또는 여러 이미지인 경우 클릭하면 순환
    return GestureDetector(
      onTap: () {
        if (images.length > 1) {
          setState(() {
            _currentImageIndex[post.id] = (currentIndex + 1) % images.length;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              SizedBox(
                height: 240,
                width: double.infinity,
                child: Image.network(
                  images[currentIndex],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black26,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white54,
                        size: 48,
                      ),
                    );
                  },
                ),
              ),
              // 이미지 순환 인디케이터 (여러 이미지가 있을 경우)
              if (images.length > 1)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${currentIndex + 1}/${images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labeledImage(String path, String label) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.network(
            path,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.black26,
              child: const Icon(
                Icons.broken_image_outlined,
                color: Colors.white54,
                size: 48,
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              border: Border.all(color: Colors.white24, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostContent(CommunityPost post) {
    final lines = post.content.split('\n');
    final Map<String, List<String>> sections = {
      'hashtags': [],
      'body': [],
      'record': [],
    };

    bool inRecord = false;
    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('#')) {
        sections['hashtags']!.add(trimmed);
      } else if (trimmed.startsWith('기록:')) {
        inRecord = true;
        sections['record']!.add(trimmed.replaceFirst('기록:', '').trim());
      } else if (inRecord) {
        sections['record']!.add(trimmed);
      } else {
        sections['body']!.add(line);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sections['hashtags']!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Wrap(
              spacing: 8,
              children: sections['hashtags']!
                  .map(
                    (tag) => Text(
                      tag,
                      style: const TextStyle(
                        color: Color(0xFF17C964),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        if (sections['body']!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              sections['body']!.join('\n'),
              style: const TextStyle(
                color: Colors.black,
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ),
        if (sections['record']!.isNotEmpty)
          _buildRecordCard(sections['record']!.join(' ')),
      ],
    );
  }

  Widget _buildRecordCard(String recordText) {
    // Expected format: Title · Date · Distance · Duration
    final parts = recordText.split('·').map((e) => e.trim()).toList();

    return NesContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Pixel.check, color: Color(0xFF17C964), size: 16),
              const SizedBox(width: 8),
              Text(
                parts.isNotEmpty ? parts[0] : '활동 기록',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (parts.length > 2) ...[
                _recordStat(Pixel.user, parts[2]),
                const SizedBox(width: 16),
              ],
              if (parts.length > 3) ...[
                _recordStat(Pixel.clock, parts[3]),
                const SizedBox(width: 16),
              ],
              if (parts.length > 4) ...[
                _recordStat(Icons.star, parts[4]),
                const SizedBox(width: 16),
              ],
              if (parts.length > 1) _recordStat(Pixel.calendar, parts[1]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recordStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black38, size: 12),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.black54, fontSize: 11),
        ),
      ],
    );
  }

  Color _getColorForNickname(String nickname) {
    if (nickname.isEmpty) return const Color(0xFF17C964);
    final int hash = nickname.hashCode;
    const List<Color> palette = [
      Color(0xFF17C964),
      Color(0xFF3B82F6),
      Color(0xFFEF4444),
      Color(0xFFF59E0B),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
    ];
    return palette[hash.abs() % palette.length];
  }
}

// feed.dart의 _CommentBottomSheet와 동일
class _CommentBottomSheet extends StatefulWidget {
  final CommunityPost post;
  final AuthService authService;
  final VoidCallback onCommentAdded;
  final Set<String> totalTop3UserIds;

  const _CommentBottomSheet({
    required this.post,
    required this.authService,
    required this.onCommentAdded,
    required this.totalTop3UserIds,
  });

  @override
  State<_CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<_CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSubmitting = false;
  late List<CommunityComment> _comments;

  @override
  void initState() {
    super.initState();
    // 초기 댓글 목록을 최신순으로 정렬
    _comments = List<CommunityComment>.from(widget.post.comments);
    _comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _deleteComment(CommunityComment comment) async {
    try {
      await widget.authService.deleteComment(widget.post.id, comment.id);
      widget.onCommentAdded();
      if (mounted) {
        setState(() {
          _comments.removeWhere((c) => c.id == comment.id);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('댓글 삭제에 실패했습니다.')));
    }
  }

  Future<void> _submitComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSubmitting) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    try {
      // 1. 서버에 댓글 전송
      await widget.authService.addComment(
        widget.post.id,
        AuthService.userId ?? 'guest',
        text,
      );

      _controller.clear();

      // 2. 부모 위젯(피드)에 알려 전체 목록 갱신 (서버에서 최신 댓글 데이터 받아옴)
      widget.onCommentAdded();

      // 3. 현재 게시글의 최신 댓글 목록 다시 불러오기
      final updatedPosts = await widget.authService.getPosts(allPosts: true);
      final updatedPost = updatedPosts
          .whereType<Map>()
          .map((item) => CommunityPost.fromPostJson(item.cast<String, dynamic>()))
          .firstWhere(
            (p) => p.id == widget.post.id,
            orElse: () => widget.post,
          );

      // 4. 최신 댓글 목록으로 UI 갱신
      setState(() {
        _comments = List<CommunityComment>.from(updatedPost.comments);
        _comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });

      // 5. 댓글이 맨 위에 추가되므로, 스크롤을 맨 위로 이동 (선택 사항)
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('댓글 작성에 실패했습니다.')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height * 0.95, // Increased height to 95%
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '댓글',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _comments.isEmpty
                ? const Center(
                    child: Text(
                      '댓글이 없습니다',
                      style: TextStyle(color: Colors.black38, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      final isMine = AuthService.nickname == comment.nickname;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 프로필사진
                            GestureDetector(
                              onTap: () {
                                final targetId =
                                    comment.userId?.isNotEmpty == true
                                        ? comment.userId!
                                        : comment.nickname;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(userId: targetId),
                                  ),
                                );
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F1F1F),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.0,
                                  ),
                                ),
                                child: comment.profileImage != null &&
                                        comment.profileImage!.isNotEmpty
                                    ? ClipRect(
                                        child: Image.network(
                                          comment.profileImage!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                              child: PixelCharacter(
                                                size: 35,
                                                color: _getColorForNickname(
                                                  comment.nickname,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: PixelCharacter(
                                          size: 35,
                                          color: _getColorForNickname(
                                            comment.nickname,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Tier 뱃지 이미지 (top 3는 legend 뱃지)
                                      if (comment.tier.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 4),
                                          child: Image.asset(
                                            widget.totalTop3UserIds.contains(comment.userId)
                                                ? TierUtils.getTierBadgePath('legend')
                                                : TierUtils.getTierBadgePath(comment.tier),
                                            width: 24,
                                            height: 24,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const SizedBox(width: 24, height: 24);
                                            },
                                          ),
                                        ),
                                      Expanded(
                                        // 닉네임
                                        child: GestureDetector(
                                          onTap: () {
                                            final targetId =
                                                comment.userId?.isNotEmpty ==
                                                        true
                                                    ? comment.userId!
                                                    : comment.nickname;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                  userId: targetId,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            comment.nickname.toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (isMine)
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isDense: true,
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.black54,
                                              size: 18,
                                            ),
                                            dropdownColor: Colors.white,
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Pixel.trash,
                                                      color: Colors.redAccent,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      '삭제',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              if (value == 'delete') {
                                                _deleteComment(comment);
                                              }
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // 댓글
                                  Text(
                                    comment.content,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          _commentInput(),
        ],
      ),
    );
  }

  Widget _commentInput() {
    return NesContainer(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        60 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                hintText: '댓글을 입력하세요...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 12),
          NesButton(
            type: NesButtonType.success,
            onPressed: _submitComment,
            child: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Pixel.arrowright),
          ),
        ],
      ),
    );
  }

  Color _getColorForNickname(String nickname) {
    if (nickname.isEmpty) return const Color(0xFF17C964);
    final int hash = nickname.hashCode;
    const List<Color> palette = [
      Color(0xFF17C964),
      Color(0xFF3B82F6),
      Color(0xFFEF4444),
      Color(0xFFF59E0B),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
    ];
    return palette[hash.abs() % palette.length];
  }
}
