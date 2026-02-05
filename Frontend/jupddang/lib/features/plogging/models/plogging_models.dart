class PloggingEndRequest {
  final int? ploggingId;
  final double distance;
  final String content;
  final int times;
  final String endTime;
  final int? partyId;
  final String? recordTitle;
  final int? score;

  PloggingEndRequest({
    this.ploggingId,
    required this.distance,
    required this.content,
    required this.times,
    required this.endTime,
    this.partyId,
    this.recordTitle,
    this.score,
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
    if (recordTitle != null && recordTitle!.isNotEmpty) 'recordTitle': recordTitle,
  };
}
