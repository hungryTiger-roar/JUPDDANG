class Ranker {
  final int rank;
  final String nickname;
  final int score;
  final String? profileImage;
  final String userId;

  Ranker({
    required this.rank,
    required this.nickname,
    required this.score,
    required this.userId,
    this.profileImage,
  });

  factory Ranker.fromJson(Map<String, dynamic> json) {
    return Ranker(
      rank: json['rank'] ?? 0,
      nickname: json['nickname'] ?? 'Anonymous',
      score: json['score'] ?? 0,
      userId: json['userId']?.toString() ?? '',
      profileImage: json['profileImage'],
    );
  }
}

class RankingResponse {
  final List<Ranker> topRankers;
  final Ranker? myRanking;

  RankingResponse({required this.topRankers, this.myRanking});

  factory RankingResponse.fromJson(Map<String, dynamic> json) {
    var list = json['rankings'] as List? ?? [];
    List<Ranker> rankers = list.map((i) => Ranker.fromJson(i)).toList();

    return RankingResponse(
      topRankers: rankers,
      myRanking: json['myRanking'] != null
          ? Ranker.fromJson(json['myRanking'])
          : null,
    );
  }
}
