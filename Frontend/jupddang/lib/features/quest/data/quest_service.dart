import 'package:latlong2/latlong.dart';

class QuestValidationResponse {
  final bool isValid;
  final String? message;
  final int beforeTrashCount;
  final int afterTrashCount;

  QuestValidationResponse(
    this.isValid, {
    this.message,
    this.beforeTrashCount = 0,
    this.afterTrashCount = 0,
  });
}

class QuestService {
  QuestValidationResponse validateLocally({
    required LatLng beforeLocation,
    required LatLng afterLocation,
  }) {
    // Basic validation logic (placeholder)
    // You can implement actual logic here, e.g., checking distance between locations
    // final distance = const Distance().as(
    //   LengthUnit.Meter,
    //   beforeLocation,
    //   afterLocation,
    // );
    // Unused for now

    // For now, assume valid if locations are provided (which they are, based on type)
    // and maybe enforce some distance? Or just always return true for now.
    return QuestValidationResponse(
      true,
      beforeTrashCount: 1,
      afterTrashCount: 0,
    );
  }
}
