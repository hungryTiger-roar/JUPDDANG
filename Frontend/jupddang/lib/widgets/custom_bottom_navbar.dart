import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
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

    // [아이콘 리스트]
    final List<IconData> icons = [
      Pixel.message,
      Pixel.moodhappy,
      Pixel.map,
      Pixel.trophy,
      Pixel.sliders,
    ];

    double itemWidth = (barWidth - 40) / icons.length;

    return SafeArea(
      child: NesContainer(
        width: barWidth,
        height: barHeight,
        padding: const EdgeInsets.all(4),
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
              child: NesContainer(
                width: indicatorOuterSize,
                height: indicatorOuterSize,
                child: Center(
                  child: Icon(
                    icons[currentIndex],
                    color: Colors.white,
                    size: 24,
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
                            child: Icon(icons[index], size: 24),
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
