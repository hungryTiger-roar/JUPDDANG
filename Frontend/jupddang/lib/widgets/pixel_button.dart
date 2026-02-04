import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class PixelButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final double width;
  final double height;
  final bool isGreen;
  final bool isPulse;

  const PixelButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF8D5D3B),
    this.width = double.infinity,
    this.height = 60,
    this.isGreen = true,
    this.isPulse = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: NesButton(
        type: isGreen ? NesButtonType.success : NesButtonType.primary,
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
