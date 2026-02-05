import 'package:latlong2/latlong.dart';

/// 퀘스트 검증 응답 모델
class QuestValidationResponse {
  final bool isValid;
  final int beforeTrashCount;
  final int afterTrashCount;
  final double distanceMeters;
  final String? message;

  QuestValidationResponse({
    required this.isValid,
    required this.beforeTrashCount,
    required this.afterTrashCount,
    required this.distanceMeters,
    this.message,
  });

  factory QuestValidationResponse.fromJson(Map<String, dynamic> json) {
    return QuestValidationResponse(
      isValid: json['isValid'] ?? false,
      beforeTrashCount: json['beforeTrashCount'] ?? 0,
      afterTrashCount: json['afterTrashCount'] ?? 0,
      distanceMeters: (json['distanceMeters'] ?? 0.0).toDouble(),
      message: json['message'],
    );
  }
}

/// 퀘스트 사진 데이터
class QuestPhotoData {
  final String imagePath;
  final LatLng location;
  final DateTime timestamp;

  QuestPhotoData({
    required this.imagePath,
    required this.location,
    required this.timestamp,
  });
}
