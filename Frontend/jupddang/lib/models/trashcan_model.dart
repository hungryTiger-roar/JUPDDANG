enum TrashcanStatus { OFFICIAL, PENDING, VERIFIED }

class TrashcanModel {
  final int id;
  final double latitude;
  final double longitude;
  final String? address;
  final TrashcanStatus status;

  TrashcanModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.status,
  });

  factory TrashcanModel.fromJson(Map<String, dynamic> json) {
    return TrashcanModel(
      id: json['id'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      status: _parseStatus(json['status']),
    );
  }

  static TrashcanStatus _parseStatus(String? status) {
    switch (status) {
      case 'OFFICIAL':
        return TrashcanStatus.OFFICIAL;
      case 'PENDING':
        return TrashcanStatus.PENDING;
      case 'VERIFIED':
        return TrashcanStatus.VERIFIED;
      default:
        return TrashcanStatus.PENDING; // Fallback
    }
  }
}

class TrashcanDetailModel {
  final int id;
  final double latitude;
  final double longitude;
  final String? address;
  final TrashcanStatus status;
  final String? reportedBy;
  final int verificationCount;

  TrashcanDetailModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.address,
    required this.status,
    this.reportedBy,
    required this.verificationCount,
  });

  factory TrashcanDetailModel.fromJson(Map<String, dynamic> json) {
    return TrashcanDetailModel(
      id: json['id'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      status: TrashcanModel._parseStatus(json['status']),
      reportedBy: json['reportedBy'] as String?,
      verificationCount: json['verificationCount'] as int? ?? 0,
    );
  }
}

class TrashcanCreateRequest {
  final double latitude;
  final double longitude;
  final String address;

  TrashcanCreateRequest({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude, 'address': address};
  }
}
