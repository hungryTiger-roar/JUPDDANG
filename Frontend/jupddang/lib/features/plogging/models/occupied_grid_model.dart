// Imports removed

class OccupiedGrid {
  final String id;
  final String userId;
  final int? partyId;
  final DateTime occupiedAt;

  OccupiedGrid({
    required this.id,
    required this.userId,
    this.partyId,
    required this.occupiedAt,
  });

  factory OccupiedGrid.fromJson(Map<String, dynamic> json) {
    return OccupiedGrid(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      partyId: json['partyId'],
      occupiedAt:
          DateTime.tryParse(json['occupiedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  bool get isLocked {
    return DateTime.now().difference(occupiedAt).inHours < 3;
  }
}
