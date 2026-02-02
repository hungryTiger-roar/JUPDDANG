class PartyMember {
  final String userId;
  final bool isLeader;
  final DateTime joinedAt;

  PartyMember({
    required this.userId,
    required this.isLeader,
    required this.joinedAt,
  });

  factory PartyMember.fromJson(Map<String, dynamic> json) {
    return PartyMember(
      userId: json['userId']?.toString() ?? '',
      isLeader: json['isLeader'] ?? false,
      joinedAt:
          DateTime.tryParse(json['joinedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

class Party {
  final int partyId;
  final String inviteCode;
  final String name;
  final String status; // WAITING, IN_PROGRESS, COMPLETED
  final String leaderId;
  final bool isCurrentUserLeader;
  final int currentMembers;
  final int maxMembers;
  final List<PartyMember> members;
  final DateTime createdAt;
  final DateTime? startedAt;

  Party({
    required this.partyId,
    required this.inviteCode,
    required this.name,
    required this.status,
    required this.leaderId,
    required this.isCurrentUserLeader,
    required this.currentMembers,
    required this.maxMembers,
    required this.members,
    required this.createdAt,
    this.startedAt,
  });

  factory Party.fromJson(Map<String, dynamic> json) {
    final leader = json['leader'] as Map<String, dynamic>? ?? {};
    final membersInfo = json['members'] as Map<String, dynamic>? ?? {};
    final membersList =
        (membersInfo['list'] as List?)
            ?.map((m) => PartyMember.fromJson(m as Map<String, dynamic>))
            .toList() ??
        [];

    return Party(
      partyId: json['partyId'] ?? 0,
      inviteCode: json['inviteCode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? 'WAITING',
      leaderId: leader['userId']?.toString() ?? '',
      isCurrentUserLeader: leader['isCurrentUser'] ?? false,
      currentMembers: membersInfo['current'] ?? 0,
      maxMembers: membersInfo['max'] ?? 4,
      members: membersList,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'].toString())
          : null,
    );
  }
}

class LocationRequest {
  final double lat;
  final double lon;
  final int partyId;
  final int? elapsedTime; // 초 단위 경과 시간
  final double? totalDistance; // 총 이동 거리 (미터)
  final int? score; // 점수

  LocationRequest({
    required this.lat,
    required this.lon,
    required this.partyId,
    this.elapsedTime,
    this.totalDistance,
    this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
      'partyId': partyId,
      if (elapsedTime != null) 'elapsedTime': elapsedTime,
      if (totalDistance != null) 'totalDistance': totalDistance,
      if (score != null) 'score': score,
    };
  }

  factory LocationRequest.fromJson(Map<String, dynamic> json) {
    return LocationRequest(
      lat: (json['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? 0.0).toDouble(),
      partyId: json['partyId'] ?? 0,
      elapsedTime: json['elapsedTime'],
      totalDistance: json['totalDistance']?.toDouble(),
      score: json['score'],
    );
  }
}

class PartyMemberLocation {
  final String userId;
  final double lat;
  final double lon;
  final int elapsedTime;
  final double totalDistance;
  final int score;
  final int occupiedCount;
  final double occupyProgress;
  final String? currentH3Index;

  PartyMemberLocation({
    required this.userId,
    required this.lat,
    required this.lon,
    required this.elapsedTime,
    required this.totalDistance,
    required this.score,
    required this.occupiedCount,
    required this.occupyProgress,
    this.currentH3Index,
  });

  factory PartyMemberLocation.fromJson(Map<String, dynamic> json) {
    return PartyMemberLocation(
      userId: json['userId'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? 0.0).toDouble(),
      elapsedTime: json['elapsedTime'] ?? 0,
      totalDistance: (json['totalDistance'] ?? 0.0).toDouble(),
      score: json['score'] ?? 0,
      occupiedCount: json['occupiedCount'] ?? 0,
      occupyProgress: (json['occupyProgress'] ?? 0.0).toDouble(),
      currentH3Index: json['currentH3Index'],
    );
  }
}

class PartyActivity {
  final String userId;
  final double? currentLatitude;
  final double? currentLongitude;
  final double totalDistance;
  final int elapsedTime; // seconds
  final bool isCompleted;
  final double? occupyProgress; // 점령 진행도 (0.0 ~ 1.0)
  final String? currentH3Index; // 현재 점령 중인 H3 인덱스

  PartyActivity({
    required this.userId,
    this.currentLatitude,
    this.currentLongitude,
    required this.totalDistance,
    required this.elapsedTime,
    required this.isCompleted,
    this.occupyProgress,
    this.currentH3Index,
  });

  factory PartyActivity.fromJson(Map<String, dynamic> json) {
    return PartyActivity(
      userId: json['userId']?.toString() ?? '',
      currentLatitude: json['currentLatitude']?.toDouble(),
      currentLongitude: json['currentLongitude']?.toDouble(),
      totalDistance: (json['totalDistance'] ?? 0).toDouble(),
      elapsedTime: json['elapsedTime'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      occupyProgress: (json['occupyProgress'] ?? 0.0).toDouble(),
      currentH3Index: json['currentH3Index']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentLatitude': currentLatitude,
      'currentLongitude': currentLongitude,
      'totalDistance': totalDistance,
      'elapsedTime': elapsedTime,
      'isCompleted': isCompleted,
      'occupyProgress': occupyProgress,
      'currentH3Index': currentH3Index,
    };
  }
}
