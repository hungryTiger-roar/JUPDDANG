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
  final List<Ranker> topRankers; // 1~3등
  final List<Ranker> myRankWindow; // 내 주변 랭킹
  final Ranker? myRanking;

  RankingResponse({required this.topRankers, required this.myRankWindow, this.myRanking});

  factory RankingResponse.fromJson(Map<String, dynamic> json, String currentUserId) {

    var topList = json['topRankers'] as List? ?? [];
    List<Ranker> topRankers = topList.map((i) => Ranker.fromJson(i)).toList();

    var windowList = json['myRankWindow'] as List? ?? [];
    List<Ranker> myRankWindow = windowList.map((i) => Ranker.fromJson(i)).toList();

    Ranker? me;
    try {
      me = myRankWindow.firstWhere((ranker) => ranker.userId == currentUserId);
    } catch (e) {
      try {
        me = topRankers.firstWhere((ranker) => ranker.userId == currentUserId);
      } catch (e) {
        me = null;
      }
    }

    return RankingResponse(
      topRankers: topRankers,
      myRankWindow: myRankWindow,
      myRanking: me,
    );
  }
}
