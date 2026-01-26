import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/community_models.dart';
import '../../services/auth_service.dart';
import 'feed_compose.dart';

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

  @override
  void initState() {
    super.initState();
    _refreshAll();
  }

  Future<void> _refreshAll() async {
    await Future.wait([_loadAccounts(), _loadPosts()]);
  }

  Future<void> _loadAccounts() async {
    if (AuthService.accessToken == null) {
      setState(() {
        _loadingAccounts = false;
        _accounts = [];
        _errorMessage = '로그인이 필요합니다.';
      });
      return;
    }

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
    if (AuthService.accessToken == null) {
      setState(() {
        _loadingPosts = false;
      });
      return;
    }

    try {
      final data = await _authService.getPosts();
      final posts = data
          .whereType<Map>()
          .map((item) => CommunityPost.fromPostJson(item.cast<String, dynamic>()))
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

  List<CommunityPost> get _allPosts => [..._localPosts, ..._remotePosts];

  Future<void> _openComposer() async {
    if (AuthService.accessToken == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 후 글을 작성할 수 있어요.')),
        );
      }
      return;
    }
    final initialAccount = _accounts.firstWhere(
      (account) => account.userId == AuthService.userId,
      orElse: () => _accounts.isNotEmpty ? _accounts.first : AccountSummary(
        userId: 'guest',
        nickname: 'Guest',
      ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서버 저장에 실패해 임시로 표시합니다.')),
        );
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
        padding: EdgeInsets.only(bottom: navClearance),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFEAFF6A),
          foregroundColor: Colors.black,
          onPressed: _openComposer,
          child: const Icon(Icons.edit),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAll,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildAccountStories()),
              SliverToBoxAdapter(child: _buildDivider()),
              _buildFeed(),
              SliverToBoxAdapter(
                child: SizedBox(height: navClearance + 32),
              ),
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
            '커뮤니티',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _loadingAccounts
                ? '유저 목록 불러오는 중...'
                : '유저 ${_accounts.length}명 • 최신 피드',
            style: const TextStyle(color: Colors.white70),
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
        child: SizedBox(
          height: 80,
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFFEAFF6A)),
          ),
        ),
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
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEAFF6A), Color(0xFF4E6B00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    _initial(account.nickname),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 60,
                child: Text(
                  account.nickname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 1,
        color: Colors.white12,
      ),
    );
  }

  Widget _buildFeed() {
    if (_loadingPosts) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFFEAFF6A)),
          ),
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFEAFF6A),
                child: Text(
                  _initial(post.nickname),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.nickname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatTime(post.createdAt),
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              if (post.localOnly)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '임시',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            post.content,
            style: const TextStyle(color: Colors.white, height: 1.4),
          ),
          if (post.localImagePaths.isNotEmpty || post.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildPostImages(post),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite_border, color: Colors.white70),
              const SizedBox(width: 6),
              Text(
                '${post.likeCount}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.mode_comment_outlined, color: Colors.white70),
              const SizedBox(width: 6),
              const Text(
                '댓글',
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: Colors.white54),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostImages(CommunityPost post) {
    final images = post.localImagePaths.isNotEmpty
        ? post.localImagePaths
        : post.imageUrls;
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 210,
        child: PageView.builder(
          itemCount: images.length,
          itemBuilder: (context, index) {
            final path = images[index];
            return _buildImageTile(
              path: path,
              isLocal: post.localImagePaths.isNotEmpty,
            );
          },
        ),
      ),
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

  String _initial(String value) {
    if (value.isEmpty) {
      return '?';
    }
    return value.substring(0, 1).toUpperCase();
  }
}
