class PloggingEndRequest {
  final int? ploggingId;
  final double distance;
  final String content;
  final int times;
  final String endTime;
  final int? partyId;
  final String? recordTitle;
  final int? score;
  final List<String>? capturedGrids; // 🎯 [NEW] 점령한 헥사곤 H3 인덱스 목록

  PloggingEndRequest({
    this.ploggingId,
    required this.distance,
    required this.content,
    required this.times,
    required this.endTime,
    this.partyId,
    this.recordTitle,
    this.score,
    this.capturedGrids,
  });

  Map<String, dynamic> toJson() => {
    if (ploggingId != null) 'ploggingId': ploggingId,
    'distance': distance,
    'content': content,
    'times': times,
    'endTime': endTime,
    if (partyId != null) 'partyId': partyId,
    if (recordTitle != null) 'recordTitle': recordTitle,
    if (score != null) 'score': score,
    if (capturedGrids != null && capturedGrids!.isNotEmpty)
      'capturedGrids': capturedGrids,
  };
}

class TempPloggingRequest {
  final double? distance;
  final String? content;
  final int? times;
  final String? endTime;
  final int? partyId;
  final String? recordTitle;

  TempPloggingRequest({
    this.distance,
    this.content,
    this.times,
    this.endTime,
    this.partyId,
    this.recordTitle,
  });

  Map<String, dynamic> toJson() => {
    if (distance != null) 'distance': distance,
    if (content != null && content!.isNotEmpty) 'content': content,
    if (times != null) 'times': times,
    if (endTime != null) 'endTime': endTime,
    if (partyId != null) 'partyId': partyId,
    if (recordTitle != null && recordTitle!.isNotEmpty)
      'recordTitle': recordTitle,
  };
}

class PloggingTempDetailResponse {
  final int ploggingId;
  final String recordName;
  final double? distance;
  final int? times;
  final int? score;
  final String? beforeImageUrl;
  final String? afterImageUrl;
  final String? mapImageUrl;
  final String? content;
  final DateTime? createdAt;

  PloggingTempDetailResponse({
    required this.ploggingId,
    required this.recordName,
    this.distance,
    this.times,
    this.score,
    this.beforeImageUrl,
    this.afterImageUrl,
    this.mapImageUrl,
    this.content,
    this.createdAt,
  });

  factory PloggingTempDetailResponse.fromJson(Map<String, dynamic> json) {
    return PloggingTempDetailResponse(
      ploggingId: json['ploggingId']?.toInt() ?? 0,
      recordName: json['recordName']?.toString() ?? '',
      distance: (json['distance'] as num?)?.toDouble(),
      times: (json['times'] as num?)?.toInt(),
      score: (json['score'] as num?)?.toInt(),
      beforeImageUrl: json['beforeImageUrl']?.toString(),
      afterImageUrl: json['afterImageUrl']?.toString(),
      mapImageUrl: json['mapImageUrl']?.toString(),
      content: json['content']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
