import 'package:flutter/material.dart';
import 'dart:async';

enum BossType {
  trashCan,
  trashBag,
  dustCloud,
  rottenSprout,
}

class AnimatedBossWidget extends StatefulWidget {
  final BossType bossType;
  final double size;

  const AnimatedBossWidget({
    super.key,
    required this.bossType,
    this.size = 60,
  });

  @override
  State<AnimatedBossWidget> createState() => _AnimatedBossWidgetState();
}

class _AnimatedBossWidgetState extends State<AnimatedBossWidget> {
  int _currentFrame = 0;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _animationTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (mounted) {
        setState(() {
          _currentFrame = (_currentFrame + 1) % 4; // 4 frames
        });
      }
    });
  }

  String _getBossImagePath() {
    switch (widget.bossType) {
      case BossType.trashCan:
        return 'assets/images/bosses/boss_trash_can.png';
      case BossType.trashBag:
        return 'assets/images/bosses/boss_trash_bag.png';
      case BossType.dustCloud:
        return 'assets/images/bosses/boss_dust_cloud.png';
      case BossType.rottenSprout:
        return 'assets/images/bosses/boss_rotten_sprout.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topLeft,
          widthFactor: 0.25, // Show 1/4 of the sprite sheet (one frame)
          child: Transform.translate(
            offset: Offset(-widget.size * _currentFrame, 0),
            child: Image.asset(
              _getBossImagePath(),
              width: widget.size * 4, // Sprite sheet is 4 frames wide
              height: widget.size,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none, // Pixel-perfect rendering
              isAntiAlias: false, // Sharp pixel art
              errorBuilder: (context, error, stackTrace) {
                // Fallback to a simple icon if image fails to load
                return Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: widget.size * 0.8,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
