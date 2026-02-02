import 'package:flutter/material.dart';

class PixelButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final double width;
  final double height;
  final bool isGreen;
  final bool isPulse; // New: Adds a game-like pulse effect

  const PixelButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF8D5D3B), // Classic wood brown
    this.width = double.infinity,
    this.height = 60,
    this.isGreen = true,
    this.isPulse = false,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late AnimationController? _pulseController;
  late Animation<double>? _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    );
    _scaleController.value = 1.0;

    if (widget.isPulse && widget.onPressed != null) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      )..repeat(reverse: true);
      _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
        CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
      );
    } else {
      _pulseController = null;
      _pulseAnimation = null;
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stardew Valley Palette
    const Color outerBorder = Color(0xFF532E16);
    const Color innerHighlight = Color(0xFFF9D698);
    final Color mainBody = widget.isGreen
        ? const Color(0xFF46A140)
        : widget.color;
    final Color bottomShadow = Color.lerp(mainBody, Colors.black, 0.3)!;

    final bool isDisabled = widget.onPressed == null;

    Widget button = Opacity(
      opacity: isDisabled ? 0.6 : 1.0,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: outerBorder,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
            color: _isPressed ? bottomShadow : mainBody,
            border: Border.all(
              color: innerHighlight.withOpacity(0.8),
              width: 3.0,
            ),
            boxShadow: _isPressed
                ? []
                : [
                    BoxShadow(
                      color: bottomShadow,
                      offset: const Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: _isPressed ? 4 : 0),
              child: Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(color: Colors.black45, offset: Offset(2, 2)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (_pulseAnimation != null && !isDisabled) {
      button = ScaleTransition(scale: _pulseAnimation!, child: button);
    }

    return GestureDetector(
      onTapDown: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = true);
              _scaleController.reverse();
            },
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
              _scaleController.forward();
              widget.onPressed!();
            },
      onTapCancel: isDisabled
          ? null
          : () {
              setState(() => _isPressed = false);
              _scaleController.forward();
            },
      child: ScaleTransition(scale: _scaleAnimation, child: button),
    );
  }
}
