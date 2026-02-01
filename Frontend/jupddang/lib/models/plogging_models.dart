class PloggingEndRequest {
  final int? ploggingId;
  final String content;
  final double distance; // km
  final int times; // seconds
  final String endTime; // yyyy-MM-dd'T'HH:mm:ss

  PloggingEndRequest({
    this.ploggingId,
    required this.distance,
    required this.content,
    required this.times,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'distance': distance,
      'content': content,
      'times': times,
      'endTime': endTime,
    };

    if (ploggingId != null) {
      payload['ploggingId'] = ploggingId;
    }

    return payload;
  }

}