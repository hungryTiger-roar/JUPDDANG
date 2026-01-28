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

class PartyActivity {
  final String userId;
  final double? currentLatitude;
  final double? currentLongitude;
  final double totalDistance;
  final int elapsedTime; // seconds
  final bool isCompleted;

  PartyActivity({
    required this.userId,
    this.currentLatitude,
    this.currentLongitude,
    required this.totalDistance,
    required this.elapsedTime,
    required this.isCompleted,
  });

  factory PartyActivity.fromJson(Map<String, dynamic> json) {
    return PartyActivity(
      userId: json['userId']?.toString() ?? '',
      currentLatitude: json['currentLatitude']?.toDouble(),
      currentLongitude: json['currentLongitude']?.toDouble(),
      totalDistance: (json['totalDistance'] ?? 0).toDouble(),
      elapsedTime: json['elapsedTime'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
