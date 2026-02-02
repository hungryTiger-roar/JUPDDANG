import 'package:flutter/material.dart';

enum BossType {
  trashCan,
  trashBag,
  dustCloud,
  rottenSprout,
}

class AnimatedBossWidget extends StatelessWidget {
  final BossType bossType;
  final double size;

  const AnimatedBossWidget({
    super.key,
    required this.bossType,
    this.size = 60,
  });

  String _getBossImagePath() {
    switch (bossType) {
      case BossType.trashCan:
        return 'assets/images/bosses/gif/canny.gif';
      case BossType.trashBag:
        return 'assets/images/bosses/gif/packy.gif';
      case BossType.dustCloud:
        return 'assets/images/bosses/gif/dusty.gif';
      case BossType.rottenSprout:
        return 'assets/images/bosses/gif/rotteny.gif';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        _getBossImagePath(),
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.warning,
            color: Colors.red,
            size: size * 0.8,
          );
        },
      ),
    );
  }
}
