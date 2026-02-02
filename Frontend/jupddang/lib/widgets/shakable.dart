import 'dart:math';
import 'package:flutter/material.dart';

class Shakable extends StatefulWidget {
  final Widget child;

  const Shakable({super.key, required this.child});

  @override
  State<Shakable> createState() => ShakableState();
}

class ShakableState extends State<Shakable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void shake() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double sineValue = sin(4 * pi * _controller.value);
        return Transform.translate(
          offset: Offset(sineValue * 10 * (1 - _controller.value), 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
