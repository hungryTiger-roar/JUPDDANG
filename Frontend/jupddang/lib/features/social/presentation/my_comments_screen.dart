import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:nes_ui/nes_ui.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/pixel_character.dart';
import '../../../widgets/pixel_loader.dart';
import '../../../core/utils/tier_utils.dart';

class MyCommentsScreen extends StatefulWidget {
  final String userId;

  const MyCommentsScreen({super.key, required this.userId});

  @override
  State<MyCommentsScreen> createState() => _MyCommentsScreenState();
}

class _MyCommentsScreenState extends State<MyCommentsScreen> {
  final AuthService _authService = AuthService();
  bool _loading = true;
  List<Map<String, dynamic>> _myComments = [];

  @override
  void initState() {
    super.initState();
    _loadMyComments();
  }

  Future<void> _loadMyComments() async {
    setState(() => _loading = true);

    try {
      final commentsData = await _authService.getMyComments();
      final comments = commentsData
          .whereType<Map>()
          .map((item) => item.cast<String, dynamic>())
          .toList();

      // 최신순으로 정렬 (createdAt 기준 내림차순)
      comments.sort((a, b) {
        final aTime = DateTime.tryParse(a['createdAt']?.toString() ?? '') ?? DateTime.now();
        final bTime = DateTime.tryParse(b['createdAt']?.toString() ?? '') ?? DateTime.now();
        return bTime.compareTo(aTime); // 최신이 위로
      });

      setState(() {
        _myComments = comments;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('댓글 목록을 불러오는데 실패했습니다.')),
        );
      }
    }
  }

  Future<void> _deleteComment(Map<String, dynamic> comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        child: NesContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '댓글을 삭제하시겠습니까?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                '삭제된 댓글은 복구할 수 없습니다.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NesButton(
                    type: NesButtonType.normal,
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('취소'),
                  ),
                  const SizedBox(width: 12),
                  NesButton(
                    type: NesButtonType.error,
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('삭제'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      try {
        final postId = comment['postId']?.toString() ?? '';
        final commentId = comment['commentId']?.toString() ?? '';

        await _authService.deleteComment(postId, commentId);

        setState(() {
          _myComments.remove(comment);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('댓글이 삭제되었습니다.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('댓글 삭제에 실패했습니다.')),
          );
        }
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
            _buildHeader(),
            Expanded(
              child: _loading
                  ? const Center(child: PixelLoader())
                  : _myComments.isEmpty
                      ? _buildEmptyState()
                      : _buildCommentsList(),
            ),
          ],
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
            children: [
              NesButton(
                type: NesButtonType.normal,
                onPressed: () => Navigator.pop(context),
                child: const Icon(Pixel.arrowleft, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'MY COMMENTS',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '내가 작성한 댓글 ${_myComments.length}개',
            style: const TextStyle(color: Colors.black54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: NesContainer(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Pixel.message, color: Colors.black26, size: 48),
              SizedBox(height: 16),
              Text(
                '작성한 댓글이 없습니다',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsList() {
    return RefreshIndicator(
      onRefresh: _loadMyComments,
      color: const Color(0xFF17C964),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: _myComments.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCommentCard(_myComments[index]),
        ),
      ),
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> commentData) {
    // API 응답에서 필요한 정보 추출
    final postNickname = commentData['postNickname']?.toString() ??
                        commentData['nickname']?.toString() ?? 'Unknown';
    final postTier = commentData['postTier']?.toString() ??
        commentData['tier']?.toString() ?? '';
    final postContent = commentData['postContent']?.toString() ??
                       commentData['content']?.toString() ?? '';
    final commentContent = commentData['commentContent']?.toString() ??
                          commentData['content']?.toString() ?? '';
    final createdAt = DateTime.tryParse(
      commentData['createdAt']?.toString() ?? '',
    ) ?? DateTime.now();

    // 게시글 내용 미리보기 (최대 2줄)
    final postPreview = postContent.length > 80
        ? '${postContent.substring(0, 80)}...'
        : postContent;

    return NesContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 게시글 작성자 정보
          Row(
            children: [
              NesContainer(
                width: 32,
                height: 32,
                padding: EdgeInsets.zero,
                child: Center(
                  child: PixelCharacter(
                    size: 20,
                    color: _getColorForNickname(postNickname),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${postNickname.toUpperCase()}의 게시글',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      _formatTime(createdAt),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              NesButton(
                type: NesButtonType.error,
                onPressed: () => _deleteComment(commentData),
                child: const Icon(Pixel.trash, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 게시글 내용 미리보기
          if (postPreview.isNotEmpty) ...[
            NesContainer(
              padding: const EdgeInsets.all(12),
              backgroundColor: const Color(0xFFF5F5F5),
              child: Text(
                postPreview,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // 내 댓글
          NesContainer(
            padding: const EdgeInsets.all(12),
            backgroundColor: const Color(0xFFE8F5E9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Pixel.message, color: Color(0xFF17C964), size: 14),
                    const SizedBox(width: 6),
                    const Text(
                      '내 댓글',
                      style: TextStyle(
                        color: Color(0xFF17C964),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatTime(createdAt),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  commentContent,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
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
    if (diff.inDays < 30) {
      return '${diff.inDays}일 전';
    }
    return '${time.month}/${time.day}';
  }
}
