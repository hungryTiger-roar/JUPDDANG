class HexagonModel {
  final String h3Index;
  final String? ownerId; // 소유자 ID (null이면 무소유)
  final int color; // AARRGGBB format or simply an int representing color

  HexagonModel({
    required this.h3Index,
    this.ownerId,
    this.color = 0xAAFFFF00, // 기본값: 노란색 반투명
  });

  // 팩토리 생성자 등으로 JSON 파싱 로직 추가 가능
}
