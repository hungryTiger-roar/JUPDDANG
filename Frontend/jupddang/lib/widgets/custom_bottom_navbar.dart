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
    // 인디케이터 크기
    const double indicatorOuterSize = 56.0;
    const double barHeight = 72.0;

    // [아이콘 리스트]
    final List<IconData> icons = [
      Pixel.message,
      Pixel.moodhappy,
      Pixel.map,
      Pixel.trophy,
      Pixel.sliders,
    ];

    double itemWidth = MediaQuery.of(context).size.width / icons.length;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black, width: 3.0)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: barHeight,
          child: Stack(
            children: [
              // [Layer 1] Active Indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left:
                    (currentIndex * itemWidth) +
                    (itemWidth / 2 - indicatorOuterSize / 2),
                top: (barHeight - indicatorOuterSize) / 2,
                child: Container(
                  width: indicatorOuterSize,
                  height: indicatorOuterSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFF17C964).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      icons[currentIndex],
                      color: const Color(0xFF17C964),
                      size: 28,
                    ),
                  ),
                ),
              ),
              // [Layer 2] Icons / Hit Areas
              Row(
                children: List.generate(icons.length, (index) {
                  final isSelected = currentIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: barHeight,
                        color: Colors.transparent, // Touch target
                        child: Center(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isSelected ? 0.0 : 1.0,
                            child: Icon(
                              icons[index],
                              size: 28,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
