class FcmTokenRequest {
  final String token;
  final String deviceType;

  FcmTokenRequest({
    required this.token,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'deviceType': deviceType,
    };
  }
}