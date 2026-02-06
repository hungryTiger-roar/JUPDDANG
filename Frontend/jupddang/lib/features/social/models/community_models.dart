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
    final userId = json['userId']?.toString() ?? json['id']?.toString() ?? '';
    final nickname = json['nickname']?.toString() ?? userId;
    return AccountSummary(
      userId: userId,
      nickname: nickname,
      email: json['email']?.toString(),
      address: json['address']?.toString(),
    );
  }
}

class CommunityComment {
  final String id;
  final String? userId; // userId 추가
  final String nickname;
  final String? profileImage; // 프로필 사진 URL 추가
  final String content;
  final DateTime createdAt;

  CommunityComment({
    required this.id,
    this.userId,
    required this.nickname,
    this.profileImage,
    required this.content,
    required this.createdAt,
  });

  factory CommunityComment.fromJson(Map<String, dynamic> json) {
    return CommunityComment(
      id: json['commentId']?.toString() ?? '',
      userId: json['userId']?.toString(),
      nickname: json['nickname']?.toString() ?? 'unknown',
      profileImage: json['profileImage']?.toString(),
      content: json['content']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class CommunityPostDraft {
  final String userId;
  final String nickname;
  final String content;
  final List<String> localImagePaths;
  final int? ploggingId;

  CommunityPostDraft({
    required this.userId,
    required this.nickname,
    required this.content,
    List<String>? localImagePaths,
    this.ploggingId,
  }) : localImagePaths = localImagePaths ?? const [];
}

class CommunityPost {
  final String id;
  final String? userId;
  final String nickname;
  final String? profileImage; // 프로필 사진 URL
  final String content;
  final DateTime createdAt;
  final int likeCount;
  final List<String> imageUrls;
  final List<String> localImagePaths;
  final List<CommunityComment> comments;
  final bool localOnly;

  CommunityPost({
    required this.id,
    this.userId,
    required this.nickname,
    this.profileImage,
    required this.content,
    required this.createdAt,
    required this.likeCount,
    List<String>? imageUrls,
    List<String>? localImagePaths,
    List<CommunityComment>? comments,
    this.localOnly = false,
  }) : imageUrls = imageUrls ?? const [],
       localImagePaths = localImagePaths ?? const [],
       comments = comments ?? const [];

  factory CommunityPost.fromPostJson(Map<String, dynamic> json) {
    final createdAtRaw = json['createdAt']?.toString();
    final createdAt = DateTime.tryParse(createdAtRaw ?? '') ?? DateTime.now();
    final imageUrls = _pickImageUrls(json);
    final comments =
        (json['comments'] as List?)
            ?.map((c) => CommunityComment.fromJson(c as Map<String, dynamic>))
            .toList() ??
        [];
    
    final profileImage = json['profileImage']?.toString();
    
    return CommunityPost(
      id: json['postId']?.toString() ?? '',
      userId: json['userId']?.toString(),
      nickname: json['nickname']?.toString() ?? 'unknown',
      profileImage: profileImage,
      content: json['content']?.toString() ?? '',
      createdAt: createdAt,
      likeCount: json['like'] is int ? json['like'] as int : 0,
      imageUrls: imageUrls,
      comments: comments,
    );
  }

  factory CommunityPost.fromDraft(CommunityPostDraft draft) {
    return CommunityPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: draft.userId,
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

  CommunityPost copyWith({
    String? id,
    String? userId,
    String? nickname,
    String? profileImage,
    String? content,
    DateTime? createdAt,
    int? likeCount,
    List<String>? imageUrls,
    List<String>? localImagePaths,
    List<CommunityComment>? comments,
    bool? localOnly,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      imageUrls: imageUrls ?? this.imageUrls,
      localImagePaths: localImagePaths ?? this.localImagePaths,
      comments: comments ?? this.comments,
      localOnly: localOnly ?? this.localOnly,
    );
  }
}
