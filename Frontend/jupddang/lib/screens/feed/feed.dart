import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/community_models.dart';
import '../../services/auth_service.dart';
import 'feed_compose.dart';
import '../../widgets/pixel_button.dart';
import '../../widgets/pixel_loader.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../../widgets/pixel_character.dart';
import '../account/profile_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
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
      final data = await _authService.getPosts();
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
    final posts = [..._localPosts, ..._remotePosts];
    if (_showFollowingOnly) {
      return posts
          .where((p) => _followingNicknames.contains(p.nickname))
          .toList();
    }
    return posts;
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text('삭제하시겠습니까?', style: TextStyle(color: Colors.white)),
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
        await _authService.deletePost(postId);
        setState(() {
          _remotePosts.removeWhere((p) => p.id == postId);
          _localPosts.removeWhere((p) => p.id == postId);
        });
        if (mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('게시글이 삭제되었습니다.')));
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('삭제에 실패했습니다.')));
      }
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              SliverToBoxAdapter(child: _buildAccountStories()),
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
          const Text(
            'COMMUNITY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,

              letterSpacing: 2.0,
            ),
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
          }),
          const SizedBox(width: 12),
          _filterChip('FOLLOWING', _showFollowingOnly, () {
            setState(() => _showFollowingOnly = true);
          }),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF17C964) : const Color(0xFF1F1F1F),
          border: Border.all(color: Colors.black, width: 3.0),
          boxShadow: isSelected
              ? []
              : const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: Colors.black, width: 3.0),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
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
                          Text(
                            post.nickname.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _followButton(post.nickname),
                          if (post.userId == AuthService.userId) ...[
                            const SizedBox(width: 8),
                            _myPostTag(),
                          ],
                        ],
                      ),
                      Text(
                        _formatTime(post.createdAt).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                if (post.userId == AuthService.userId)
                  GestureDetector(
                    onTap: () => _deletePost(post.id),
                    child: const Icon(
                      Pixel.trash,
                      color: Colors.redAccent,
                      size: 24,
                    ),
                  )
                else
                  const Icon(Pixel.menu, color: Colors.white38, size: 20),
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
                color: Colors.white,
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: const Border(
          left: BorderSide(color: Color(0xFF17C964), width: 4),
        ),
      ),
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
              color: Colors.white70,
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
        'MY POST',
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
  bool _isSubmitting = false;
  late List<CommunityComment> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List<CommunityComment>.from(widget.post.comments);
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

    setState(() => _isSubmitting = true);
    try {
      await widget.authService.addComment(
        widget.post.id,
        AuthService.userId ?? 'guest',
        text,
      );
      _controller.clear();
      widget.onCommentAdded();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('댓글 작성에 실패했습니다.')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F1F1F),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              child: Center(
                                child: PixelCharacter(
                                  size: 20,
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
                                        child: Text(
                                          comment.nickname.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
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
                                  Text(
                                    comment.content,
                                    style: const TextStyle(
                                      color: Colors.white70,
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
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        60 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '댓글을 입력하세요...',
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                fillColor: Colors.white.withOpacity(0.05),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _submitComment,
            icon: Icon(
              Icons.send_rounded,
              color: _isSubmitting ? Colors.white24 : const Color(0xFF17C964),
            ),
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
