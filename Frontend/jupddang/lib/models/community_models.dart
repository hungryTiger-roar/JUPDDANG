class AccountSummary {
  final String userId;
  final String nickname;
  final String? email;
  final String? address;

  AccountSummary({
    required this.userId,
    required this.nickname,
    this.email,
    this.address,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) {
    final userId = json['userId']?.toString() ?? '';
    final nickname = json['nickname']?.toString() ?? userId;
    return AccountSummary(
      userId: userId,
      nickname: nickname,
      email: json['email']?.toString(),
      address: json['address']?.toString(),
    );
  }
}

class CommunityPostDraft {
  final String userId;
  final String nickname;
  final String content;
  final List<String> localImagePaths;

  CommunityPostDraft({
    required this.userId,
    required this.nickname,
    required this.content,
    List<String>? localImagePaths,
  }) : localImagePaths = localImagePaths ?? const [];
}

class CommunityPost {
  final String id;
  final String nickname;
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final List<String> imageUrls;
  final List<String> localImagePaths;
  final bool localOnly;

  CommunityPost({
    required this.id,
    required this.nickname,
    required this.content,
    required this.createdAt,
    required this.likeCount,
    List<String>? imageUrls,
    List<String>? localImagePaths,
    this.localOnly = false,
  })  : imageUrls = imageUrls ?? const [],
        localImagePaths = localImagePaths ?? const [];

  factory CommunityPost.fromPostJson(Map<String, dynamic> json) {
    final createdAtRaw = json['createdAt']?.toString();
    final createdAt =
        DateTime.tryParse(createdAtRaw ?? '') ?? DateTime.now();
    final imageUrls = _pickImageUrls(json);
    return CommunityPost(
      id: json['postId']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? 'unknown',
      content: json['content']?.toString() ?? '',
      createdAt: createdAt,
      likeCount: json['like'] is int ? json['like'] as int : 0,
      imageUrls: imageUrls,
    );
  }

  factory CommunityPost.fromDraft(CommunityPostDraft draft) {
    return CommunityPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nickname: draft.nickname,
      content: draft.content,
      createdAt: DateTime.now(),
      likeCount: 0,
      localImagePaths: draft.localImagePaths,
      localOnly: true,
    );
  }

  static List<String> _pickImageUrls(Map<String, dynamic> json) {
    final urls = <String>[];
    final candidates = [
      json['afterImageUrl'],
      json['beforeImageUrl'],
      json['mapImageUrl'],
    ];
    for (final candidate in candidates) {
      final value = candidate?.toString();
      if (value != null && value.isNotEmpty) {
        urls.add(value);
      }
    }
    return urls;
  }
}
