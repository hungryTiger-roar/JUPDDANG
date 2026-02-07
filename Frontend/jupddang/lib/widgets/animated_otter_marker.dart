import 'package:flutter/material.dart';

class AnimatedOtterMarker extends StatefulWidget {
  final double size;
  final bool isMoving;

  const AnimatedOtterMarker({
    super.key,
    this.size = 64,
    this.isMoving = false,
  });

  @override
  State<AnimatedOtterMarker> createState() => _AnimatedOtterMarkerState();
}

class _AnimatedOtterMarkerState extends State<AnimatedOtterMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isMoving) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedOtterMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMoving && !oldWidget.isMoving) {
      _controller.repeat(reverse: true);
    } else if (!widget.isMoving && oldWidget.isMoving) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.isMoving ? _bounceAnimation.value : 0),
          child: Image.asset(
            'assets/images/otter/otter.gif',
            width: widget.size,
            height: widget.size,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.pets, size: widget.size * 0.8, color: Colors.brown);
            },
          ),
        );
      },
    );
  }
}
