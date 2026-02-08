class FollowUser {
  final String userId;
  final String nickname;
  final String tier;
  final String profileImage;
  final String intro;

  FollowUser({
    required this.userId,
    required this.nickname,
    this.tier = '',
    required this.profileImage,
    required this.intro,
  });

  factory FollowUser.fromJson(Map<String, dynamic> json) {
    return FollowUser(
      userId: json['userId'] ?? '',
      nickname: json['nickname'] ?? '',
      tier: json['tier']?.toString() ?? '',
      profileImage: json['profileImage'] ?? '',
      intro: json['intro'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'tier': tier,
      'profileImage': profileImage,
      'intro': intro,
    };
  }
}
