class PloggingEndRequest {
  final double distance;
  final String content;
  final int times;
  final String endTime;
  final int? partyId;
  final String? recordTitle;

  PloggingEndRequest({
    required this.distance,
    required this.content,
    required this.times,
    required this.endTime,
    this.partyId,
    required this.recordTitle,
  });

  Map<String, dynamic> toJson() => {
    'distance': distance,
    'content': content,
    'times': times,
    'endTime': endTime,
    if (partyId != null) 'partyId': partyId,
    if (recordTitle != null) 'recordTitle': recordTitle,
  };
}