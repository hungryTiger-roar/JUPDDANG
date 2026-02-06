class RaidBossModel {
  final int id;
  final String h3Index;
  final String name;
  final int bossType; // 0: trash can, 1: trash bag, 2: dust cloud, 3: rotten sprout

  RaidBossModel({
    required this.id,
    required this.h3Index,
    required this.name,
    this.bossType = 0, // Default to trash can
  });

  factory RaidBossModel.fromJson(Map<String, dynamic> json) {
    return RaidBossModel(
      id: json['id'] ?? 0,
      h3Index: json['h3Index'] ?? '',
      name: json['name'] ?? 'Unknown Boss',
      bossType: json['bossType'] ?? (json['id'] ?? 0) % 4, // Use id % 4 if bossType not provided
    );
  }
}

class RaidRankInfo {
  final int rank;
  final String nickname;
  final String tier;
  final int score;
  final String userId;

  RaidRankInfo({
    required this.rank,
    required this.nickname,
    this.tier = '',
    required this.score,
    required this.userId,
  });

  factory RaidRankInfo.fromJson(Map<String, dynamic> json) {
    return RaidRankInfo(
      rank: json['rank'] ?? 0,
      nickname: json['nickname'] ?? 'Anonymous',
      tier: json['tier']?.toString() ?? '',
      score: json['score'] ?? 0,
      userId: json['userId']?.toString() ?? '',
    );
  }
}

class RaidDetailModel {
  final int bossId;
  final String bossName;
  final int totalAccumulatedScore;
  final List<RaidRankInfo> topRankers;
  final RaidRankInfo? myRanking;
  final List<RaidRankInfo> nearbyRankers;

  RaidDetailModel({
    required this.bossId,
    required this.bossName,
    required this.totalAccumulatedScore,
    required this.topRankers,
    this.myRanking,
    required this.nearbyRankers,
  });

  factory RaidDetailModel.fromJson(Map<String, dynamic> json) {
    var topList = json['topRankers'] as List? ?? [];
    var nearbyList = json['nearbyRankers'] as List? ?? [];

    return RaidDetailModel(
      bossId: json['bossId'] ?? 0,
      bossName: json['bossName'] ?? 'Unknown Zone',
      totalAccumulatedScore: json['totalAccumulatedScore'] ?? 0,
      topRankers: topList.map((i) => RaidRankInfo.fromJson(i)).toList(),
      myRanking: json['myRanking'] != null
          ? RaidRankInfo.fromJson(json['myRanking'])
          : null,
      nearbyRankers: nearbyList.map((i) => RaidRankInfo.fromJson(i)).toList(),
    );
  }
}
