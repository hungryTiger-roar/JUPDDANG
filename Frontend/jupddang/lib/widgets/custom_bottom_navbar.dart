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

    // 인디케이터 크기
    const double indicatorOuterSize = 64.0;
    const double indicatorInnerSize = 46.0;

    // [아이콘 리스트]
    final List<IconData> icons = [
      Pixel.message,
      Pixel.moodhappy,
      Pixel.map,
      Pixel.trophy,
      Pixel.sliders,
    ];

    double itemWidth = (barWidth - 40) / icons.length;
    const Color outerBorder = Color(0xFF532E16);
    const Color innerHighlight = Color(0xFFF9D698);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        width: barWidth,
        height: barHeight,
        margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        decoration: BoxDecoration(
          color: outerBorder,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: const Offset(0, 4),
              blurRadius: 0, // Solid pixel shadow
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D241E) : const Color(0xFFFAF3E0),
            border: Border.all(
              color: innerHighlight.withOpacity(0.5),
              width: 2.0,
            ),
          ),
          child: Stack(
            children: [
              // [Layer 1] Active Indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left:
                    16.0 +
                    (currentIndex * itemWidth) +
                    (itemWidth / 2 - indicatorOuterSize / 2),
                top: (barHeight - 8 - indicatorOuterSize) / 2,
                child: Container(
                  width: indicatorOuterSize,
                  height: indicatorOuterSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFF46A140),
                    border: Border.all(color: outerBorder, width: 2.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: indicatorInnerSize,
                      height: indicatorInnerSize,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: innerHighlight.withOpacity(0.3),
                          width: 1.0,
                        ),
                      ),
                      child: Icon(
                        icons[currentIndex],
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              // [Layer 2] Icons / Hit Areas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(icons.length, (index) {
                    final isSelected = currentIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          height: barHeight,
                          child: Center(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isSelected ? 0.0 : 1.0,
                              child: Icon(
                                icons[index],
                                color: isDark
                                    ? const Color(0xFFC4A484)
                                    : const Color(0xFF8B4513),
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
      ),
    );
  }
}
