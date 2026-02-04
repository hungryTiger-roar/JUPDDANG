import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:jupddang/features/social/models/community_models.dart';
import '../../../services/auth_service.dart';
import '../../account/presentation/search_screen.dart';
import 'feed_compose.dart';
import '../../../widgets/pixel_button.dart';
import '../../../widgets/pixel_loader.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../../../widgets/pixel_character.dart';
import '../../account/presentation/profile_screen.dart';
import '../../../main.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with RouteAware {
  final AuthService _authService = AuthService();
  final List<CommunityPost> _localPosts = [];
  List<CommunityPost> _remotePosts = [];
  List<AccountSummary> _accounts = [];
  bool _loadingAccounts = true;
  bool _loadingPosts = true;
  String? _errorMessage;

  // Follow & Like state
  bool _showFollowingOnly = false;
  final Set<String> _followingNicknames = {'admin'}; // Initial followed users
  final Set<String> _likedPostIds = {}; // Track liked posts locally

  @override
  void initState() {
    super.initState();
    _refreshAll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // RouteObserver 구독
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // 다른 화면에서 돌아올 때 호출됨 (댓글 삭제 후 돌아올 때)
  @override
  void didPopNext() {
    // 게시글 목록 새로고침하여 댓글이 동기화되도록 함
    _loadPosts();
  }

  @override
  void didPush() {}

  @override
  void didPushNext() {}

  @override
  void didPop() {}

  Future<void> _refreshAll() async {
    await Future.wait([_loadAccounts(), _loadPosts()]);
  }

  Future<void> _loadAccounts() async {
    setState(() {
      _loadingAccounts = true;
      _errorMessage = null;
    });

    try {
      final data = await _authService.getAccounts();
      final accounts = data
          .whereType<Map>()
          .map((item) => AccountSummary.fromJson(item.cast<String, dynamic>()))
          .toList();
      setState(() {
        _accounts = accounts;
        _loadingAccounts = false;
      });
    } catch (e) {
      setState(() {
        _loadingAccounts = false;
        _errorMessage = '유저 조회에 실패했습니다.';
      });
    }
  }

  Future<void> _loadPosts() async {
    setState(() {
      _loadingPosts = true;
    });

    try {
      // _showFollowingOnly가 false면 전체 게시글 조회 (/posts/all)
      // true면 팔로우한 사람들의 게시글만 조회 (/posts)
      final data = await _authService.getPosts(allPosts: !_showFollowingOnly);
      final posts = data
          .whereType<Map>()
          .map(
            (item) => CommunityPost.fromPostJson(item.cast<String, dynamic>()),
          )
          .toList();
      setState(() {
        _remotePosts = posts;
        _loadingPosts = false;
      });
    } catch (e) {
      setState(() {
        _loadingPosts = false;
        _errorMessage = '게시글 조회에 실패했습니다.';
      });
    }
  }

  List<CommunityPost> get _allPosts {
    // 로컬 임시 게시글과 서버에서 받은 게시글을 합침
    // API에서 이미 필터링된 데이터를 받아오므로 추가 필터링 불필요
    return [..._localPosts, ..._remotePosts];
  }

  Future<void> _toggleLike(CommunityPost post) async {
    if (AuthService.accessToken == null) return;

    setState(() {
      final postIndex = _remotePosts.indexWhere((p) => p.id == post.id);
      final isLocal = postIndex == -1;
      final targetList = isLocal ? _localPosts : _remotePosts;
      final idx = targetList.indexWhere((p) => p.id == post.id);

      if (idx != -1) {
        final currentPost = targetList[idx];
        if (_likedPostIds.contains(post.id)) {
          _likedPostIds.remove(post.id);
          targetList[idx] = currentPost.copyWith(
            likeCount: currentPost.likeCount - 1,
          );
        } else {
          _likedPostIds.add(post.id);
          targetList[idx] = currentPost.copyWith(
            likeCount: currentPost.likeCount + 1,
          );
          _authService
              .likePost(post.id)
              .catchError((e) => print('Like error: $e'));
        }
      }
    });
  }

  void _toggleFollow(String nickname) {
    setState(() {
      if (_followingNicknames.contains(nickname)) {
        _followingNicknames.remove(nickname);
      } else {
        _followingNicknames.add(nickname);
      }
    });
  }

  Future<void> _deletePost(String postId) async {
    // 임시 저장된 글인지 확인
    final isLocalDraft = _localPosts.any((p) => p.id == postId);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text('삭제하시겠습니까?', style: TextStyle(color: Colors.white)),
        content: Text(
          isLocalDraft ? '임시 저장된 글은 복구할 수 없습니다.' : '게시글을 삭제하시겠습니까?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // 임시 글이 아니면 서버 삭제 요청
        if (!isLocalDraft) {
          await _authService.deletePost(postId);
        }

        setState(() {
          if (isLocalDraft) {
            _localPosts.removeWhere((p) => p.id == postId);
          } else {
            _remotePosts.removeWhere((p) => p.id == postId);
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('게시글이 삭제되었습니다.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('삭제에 실패했습니다.')));
        }
      }
    }
  }

  // 이어쓰기 함수 (임시저장 글 -> 작성 화면 이동)
  Future<void> _continueWriting(CommunityPost post) async {
    // 현재 로그인된 작성자 계정 정보 찾기
    final initialAccount = _accounts.firstWhere(
      (account) => account.userId == AuthService.userId,
      orElse: () => _accounts.isNotEmpty
          ? _accounts.first
          : AccountSummary(userId: 'guest', nickname: 'Guest'),
    );

    // Draft 객체 생성 (기존 포스트 내용을 바탕으로)
    final initialDraft = CommunityPostDraft(
      userId: post.userId ?? '',
      nickname: post.nickname,
      content: post.content,
      localImagePaths: post.localImagePaths,
    );

    final newDraft = await Navigator.push<CommunityPostDraft>(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityComposeScreen(
          accounts: _accounts.isNotEmpty ? _accounts : [initialAccount],
          initialAccount: initialAccount,
          initialDraft: initialDraft,
        ),
      ),
    );

    // 작성 완료 후 돌아왔을 때 처리
    if (newDraft != null) {
      // 기존 임시 글 삭제
      setState(() {
        _localPosts.removeWhere((p) => p.id == post.id);
      });
      // 새 글 업로드 시도
      await _submitPost(newDraft);
    }
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
        onCommentAdded: () => _loadPosts(),
      ),
    );
  }

  Future<void> _openComposer() async {
    if (AuthService.accessToken == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('로그인 후 글을 작성할 수 있어요.')));
      }
      return;
    }
    final initialAccount = _accounts.firstWhere(
      (account) => account.userId == AuthService.userId,
      orElse: () => _accounts.isNotEmpty
          ? _accounts.first
          : AccountSummary(userId: 'guest', nickname: 'Guest'),
    );
    final draft = await Navigator.push<CommunityPostDraft>(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityComposeScreen(
          accounts: _accounts.isNotEmpty ? _accounts : [initialAccount],
          initialAccount: initialAccount,
        ),
      ),
    );

    if (draft == null) {
      return;
    }

    await _submitPost(draft);
  }

  Future<void> _submitPost(CommunityPostDraft draft) async {
    try {
      final response = await _authService.createPost(
        userId: draft.userId,
        content: draft.content,
        imagePaths: draft.localImagePaths,
      );
      if (response is Map) {
        final post = CommunityPost.fromPostJson(
          response.cast<String, dynamic>(),
        );
        setState(() {
          _remotePosts = [post, ..._remotePosts];
        });
      } else {
        await _loadPosts();
      }
    } catch (e) {
      setState(() {
        _localPosts.insert(0, CommunityPost.fromDraft(draft));
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('서버 저장에 실패해 임시로 표시합니다.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double navBarHeight = 84.0;
    const double navBarMargin = 20.0;
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    final double navClearance = navBarHeight + navBarMargin + bottomInset;

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: SizedBox(
          width: 120,
          child: PixelButton(
            text: 'WRITE',
            onPressed: _openComposer,
            height: 52,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAll,
          color: const Color(0xFF17C964),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              // SliverToBoxAdapter(child: _buildAccountStories()),
              SliverToBoxAdapter(child: _buildFilterTabs()),
              _buildFeed(),
              SliverToBoxAdapter(child: SizedBox(height: navClearance + 80)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양끝 정렬
            children: [
              const Text(
                'COMMUNITY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              // ★ [추가] 돋보기 버튼
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.search, color: Colors.white, size: 28),
                padding: EdgeInsets.zero, // 패딩 제거해서 정렬 맞추기
                constraints: const BoxConstraints(), // 불필요한 여백 제거
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _loadingAccounts
                ? 'LOADING USERS...'
                : 'USERS ${_accounts.length} • LATEST FEED',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 6),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccountStories() {
    if (_loadingAccounts) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(height: 80, child: Center(child: PixelLoader())),
      );
    }

    if (_accounts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 80,
          child: Center(
            child: Text(
              '로그인 후 유저 목록을 확인할 수 있어요.',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _accounts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final account = _accounts[index];
          return Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  border: Border.all(color: Colors.black, width: 3.0),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                  ],
                ),
                child: Center(
                  child: PixelCharacter(
                    size: 32,
                    color: _getColorForNickname(account.nickname),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 60,
                child: Text(
                  account.nickname.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _filterChip('LATEST', !_showFollowingOnly, () {
            setState(() => _showFollowingOnly = false);
            _loadPosts(); // LATEST 탭을 누를 때 전체 게시글 다시 로드
          }),
          const SizedBox(width: 12),
          _filterChip('FOLLOWING', _showFollowingOnly, () {
            setState(() => _showFollowingOnly = true);
            _loadPosts(); // FOLLOWING 탭을 누를 때 팔로우 게시글 다시 로드
          }),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return SizedBox(
      height: 40,
      child: NesButton(
        type: isSelected ? NesButtonType.success : NesButtonType.normal,
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }

  Widget _buildFeed() {
    if (_loadingPosts) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: PixelLoader()),
        ),
      );
    }

    if (_allPosts.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(
            child: Text(
              '첫 번째 글을 작성해 보세요.',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildPostCard(_allPosts[index]),
        childCount: _allPosts.length,
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    // 임시 글 여부 확인
    final isLocalDraft = _localPosts.any((p) => p.id == post.id);
    final String currentUserId = AuthService.userId?.toString() ?? '';
    final String postUserId = post.userId?.toString() ?? '';
    final isMine = postUserId.isNotEmpty && postUserId == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: NesContainer(
        padding: EdgeInsets.zero, // 내부 패딩을 직접 제어하므로 0으로 설정
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(userId: post.nickname),
                        ),
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        border: Border.all(color: Colors.black, width: 2.0),
                      ),
                      child: Center(
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
                            Flexible(
                              // 닉네임이 길어질 경우를 대비해 Flexible 사용
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
                            const SizedBox(width: 8),
                            // 팔로우 버튼 (내 글 아닐 때만)
                            if (!isMine) _followButton(post.nickname),

                            // 임시 저장 글 태그 (내 글이고 임시글일 때)
                            if (isMine && isLocalDraft)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: _myPostTag(),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2), // 간격 미세 조정
                        Text(
                          _formatTime(post.createdAt).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ★ 삼선 메뉴 (통일 및 정렬 수정) ★
                  if (isMine)
                    SizedBox(
                      width: 24, // 아이콘 크기에 맞춰 영역 제한
                      height: 24,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero, // 패딩 제거 (중요!)
                        constraints: const BoxConstraints(), // 불필요한 공간 제거
                        icon: const Icon(
                          Pixel.menu,
                          color: Colors.black,
                          size: 20,
                        ),
                        color: const Color(0xFF2A2A2A),
                        onSelected: (value) {
                          if (value == 'delete') {
                            _deletePost(post.id);
                          } else if (value == 'continue') {
                            _continueWriting(post);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          final List<PopupMenuEntry<String>> items = [];

                          // 1. 임시 저장 글일 경우 '이어쓰기' 메뉴 추가
                          if (isLocalDraft) {
                            items.add(
                              const PopupMenuItem<String>(
                                value: 'continue',
                                child: Row(
                                  children: [
                                    Icon(
                                      Pixel.edit,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '이어쓰기',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // 2. 공통: '삭제' 메뉴 추가
                          items.add(
                            const PopupMenuItem<String>(
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );

                          return items;
                        },
                      ),
                    ),
                ],
              ),
            ),

            // Images
            if (post.localImagePaths.isNotEmpty || post.imageUrls.isNotEmpty)
              _buildPostImages(post),

            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                  const Spacer(),
                  const Icon(Pixel.flag, color: Colors.white38),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              child: _buildPostContent(post),
            ),
          ],
        ),
      ),
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
                  color: Colors.white,
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
        Icon(icon, color: Colors.white38, size: 12),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

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
                      : (isActive ? const Color(0xFF17C964) : Colors.white38),
                  size: 22,
                ),
              );
            },
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImages(CommunityPost post) {
    final images = post.localImagePaths.isNotEmpty
        ? post.localImagePaths
        : post.imageUrls;
    if (images.isEmpty) return const SizedBox.shrink();

    // If there are exactly 2 images (Before/After), show them side by side with labels
    if (images.length == 2) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              Expanded(child: _labeledImage(images[0], '전', post.localOnly)),
              const SizedBox(width: 4),
              Expanded(child: _labeledImage(images[1], '후', post.localOnly)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 240,
          child: PageView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) =>
                _buildImageTile(path: images[index], isLocal: post.localOnly),
          ),
        ),
      ),
    );
  }

  Widget _labeledImage(String path, String label, bool isLocal) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: _buildImageTile(path: path, isLocal: isLocal),
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

  Widget _buildImageTile({required String path, required bool isLocal}) {
    if (isLocal) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.black26,
          child: const Icon(
            Icons.broken_image_outlined,
            color: Colors.white54,
            size: 48,
          ),
        ),
      );
    }
    return Image.network(
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
    );
  }

  Widget _followButton(String nickname) {
    if (nickname == AuthService.userId) return const SizedBox.shrink();

    final isFollowing = _followingNicknames.contains(nickname);
    return GestureDetector(
      onTap: () => _toggleFollow(nickname),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isFollowing
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFF17C964).withOpacity(0.1),
          border: Border.all(
            color: isFollowing ? Colors.white24 : const Color(0xFF17C964),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          isFollowing ? Pixel.check : Pixel.userplus,
          color: isFollowing ? Colors.white38 : const Color(0xFF17C964),
          size: 16,
        ),
      ),
    );
  }

  Color _getColorForNickname(String nickname) {
    if (nickname.isEmpty) return const Color(0xFF17C964);
    final int hash = nickname.hashCode;
    final List<Color> palette = [
      const Color(0xFF17C964),
      const Color(0xFF3B82F6),
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
    ];
    return palette[hash.abs() % palette.length];
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) {
      return '방금';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    }
    return '${time.month}/${time.day}';
  }

  Widget _myPostTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF17C964),
        border: Border.all(color: Colors.black, width: 2.0),
      ),
      child: const Text(
        '임시 저장된 글',
        style: TextStyle(
          color: Colors.black,
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CommentBottomSheet extends StatefulWidget {
  final CommunityPost post;
  final AuthService authService;
  final VoidCallback onCommentAdded;

  const _CommentBottomSheet({
    required this.post,
    required this.authService,
    required this.onCommentAdded,
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
      // 1. 서버에 댓글 전송, 응답으로 새 댓글 ID (또는 객체)를 받음
      final response = await widget.authService.addComment(
        widget.post.id,
        AuthService.userId ?? 'guest',
        text,
      );

      _controller.clear();

      // 2. 받은 응답으로 새 댓글 객체 생성
      // 서버가 ID만 반환한다고 가정하고 로컬에서 객체를 생성합니다.
      final newComment = CommunityComment(
        id: response.toString(), // 서버가 ID를 반환한다고 가정
        nickname: AuthService.nickname ?? 'You',
        content: text,
        createdAt: DateTime.now(),
      );

      // 3. 로컬 상태에 새 댓글 추가하고 UI 갱신 (맨 위에 추가)
      setState(() {
        _comments.insert(0, newComment);
      });

      // 4. 부모 위젯(피드)에 알려 전체 목록도 갱신하도록 함
      widget.onCommentAdded();

      // 5. 댓글이 맨 위에 추가되므로, 스크롤을 맨 위로 이동 (선택 사항)
      // 또는 아무것도 하지 않아 현재 스크롤 위치를 유지
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
        color: Color(0xFF1A1A1A),
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
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '댓글',
              style: TextStyle(
                color: Colors.white,
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
                      style: TextStyle(color: Colors.white38, fontSize: 16),
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
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F1F1F),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: PixelCharacter(
                                  size: 35,
                                  color: _getColorForNickname(comment.nickname),
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
                                      Expanded(
                                        // 닉네임
                                        child: Text(
                                          comment.nickname.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      if (isMine)
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isDense: true,
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.white54,
                                              size: 18,
                                            ),
                                            dropdownColor: const Color(
                                              0xFF2A2A2A,
                                            ),
                                            items: const [
                                              DropdownMenuItem(
                                                value: 'delete',
                                                child: Text(
                                                  '삭제',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
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
                                      color: Colors.white,
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
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(
                hintText: '댓글을 입력하세요...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 12),
          NesButton(
            type: NesButtonType.primary,
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
