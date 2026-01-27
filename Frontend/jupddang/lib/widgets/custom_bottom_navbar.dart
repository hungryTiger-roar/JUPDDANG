import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // 바 너비/높이 설정
    final double barWidth = screenWidth - 32;
    const double barHeight = 84.0;

    // 인디케이터(선택 원) 크기를 좀 더 키워서 강조
    const double indicatorOuterSize = 64.0;
    const double indicatorInnerSize = 46.0;

    // [아이콘 리스트]
    // 비활성 상태 (테두리만 - PixelArtIcons는 단일 스타일이 많으므로 동일하게 사용하거나 크기/색으로 구분)
    final List<IconData> unselectedIcons = [
      Pixel.message,
      Pixel.moodhappy,
      Pixel.map,
      Pixel.trophy,
      Pixel.sliders,
    ];

    // 활성 상태
    final List<IconData> selectedIcons = [
      Pixel.message,
      Pixel.moodhappy,
      Pixel.map,
      Pixel.trophy,
      Pixel.sliders,
    ];

    double itemWidth = (barWidth - 40) / unselectedIcons.length;

    return SafeArea(
      child: Container(
        width: barWidth,
        height: barHeight,
        margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF000000), // 배경: 블랙
          border: const Border(
            top: BorderSide(color: Colors.black, width: 4.0),
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(0, -4)),
          ],
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // ---------------------------------------------------
            // [Layer 1] 움직이는 활성 표시기 (Double Circle + Glow)
            // ---------------------------------------------------
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut, // 통통 튀는 애니메이션
              left:
                  20.0 +
                  (currentIndex * itemWidth) +
                  (itemWidth / 2 - indicatorOuterSize / 2),
              child: SizedBox(
                width: indicatorOuterSize,
                height: indicatorOuterSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 외부 하얀 상자 (Square)
                    Container(
                      width: indicatorOuterSize,
                      height: indicatorOuterSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2.0),
                      ),
                    ),
                    // 내부 검정 상자 (Square)
                    Container(
                      width: indicatorInnerSize,
                      height: indicatorInnerSize,
                      decoration: const BoxDecoration(color: Color(0xFF111111)),
                      // 활성 아이콘
                      child: Icon(
                        selectedIcons[currentIndex],
                        color: const Color(0xFF17C964),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------------------------------------------------
            // [Layer 2] 아이콘 버튼들
            // ---------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(unselectedIcons.length, (index) {
                  return GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: itemWidth,
                      height: barHeight,
                      child: Center(
                        // 선택 여부에 따른 애니메이션
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          // 선택되지 않은 아이콘은 작게, 선택된 건 사라지게(투명) 처리하되 scale 조절
                          transform: Matrix4.identity()
                            ..scale(currentIndex == index ? 0.0 : 1.0),
                          child: Opacity(
                            opacity: currentIndex == index ? 0.0 : 1.0,
                            child: Icon(
                              unselectedIcons[index],
                              color: Colors.grey[400], // 비활성: 약간 어두운 회색
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
