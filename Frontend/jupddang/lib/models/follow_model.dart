//화현: 팔로우 사용자 모델
class FollowUser {
  final String userId;
  final String nickname;
  final String profileImage;
  final String intro;

  FollowUser({
    required this.userId,
    required this.nickname,
    required this.profileImage,
    required this.intro,
  });

  factory FollowUser.fromJson(Map<String, dynamic> json) {
    return FollowUser(
      userId: json['userId'] ?? '',
      nickname: json['nickname'] ?? '',
      profileImage: json['profileImage'] ?? '',
      intro: json['intro'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'profileImage': profileImage,
      'intro': intro,
    };
  }
}
