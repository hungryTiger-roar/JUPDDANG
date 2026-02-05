class PloggingEndRequest {
  final String userId;
  final double totalDistance;
  final String content;
  final int times;
  final String endTime;
  final int? partyId;
  final String? recordTitle;
  final int? pickCount;
  final int? score;
  final List<dynamic>? route;

  PloggingEndRequest({
    required this.userId,
    required this.totalDistance,
    required this.content,
    required this.times,
    required this.endTime,
    this.partyId,
    this.recordTitle,
    this.pickCount,
    this.score,
    this.route,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'totalDistance': totalDistance,
    'content': content,
    'times': times,
    'endTime': endTime,
    if (partyId != null) 'partyId': partyId,
    if (recordTitle != null) 'recordTitle': recordTitle,
    if (pickCount != null) 'pickCount': pickCount,
    if (score != null) 'score': score,
    if (route != null) 'route': route,
  };
}

class TempPloggingRequest {
  final String userId;
  final double? totalDistance;
  final String? content;
  final int? time;
  final String? endTime;
  final int? partyId;
  final String? recordTitle;

  TempPloggingRequest({
    required this.userId,
    this.totalDistance,
    this.content,
    this.time,
    this.endTime,
    this.partyId,
    this.recordTitle,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    if (totalDistance != null) 'totalDistance': totalDistance,
    if (content != null && content!.isNotEmpty) 'content': content,
    if (time != null) 'time': time,
    if (endTime != null) 'endTime': endTime,
    if (partyId != null) 'partyId': partyId,
    if (recordTitle != null && recordTitle!.isNotEmpty) 'recordTitle': recordTitle,
  };
}
