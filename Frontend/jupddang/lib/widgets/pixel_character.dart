import 'package:flutter/material.dart';

class PixelCharacter extends StatefulWidget {
  final double size;
  final Color color; // 옷(🟦) 색상으로 사용됩니다.
  final bool isMoving;

  const PixelCharacter({
    super.key,
    this.size = 40.0,
    this.color = const Color(0xFF2196F3),
    this.isMoving = false,
  });

  @override
  State<PixelCharacter> createState() => _PixelCharacterState();
}

class _PixelCharacterState extends State<PixelCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentFrame = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    if (widget.isMoving) {
      _controller.repeat();
    }

    _controller.addListener(() {
      // 2프레임 애니메이션 (0, 1)
      final frame = (_controller.value * 2).floor();
      if (frame != _currentFrame) {
        setState(() {
          _currentFrame = frame;
        });
      }
    });
  }

  @override
  void didUpdateWidget(PixelCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMoving && !oldWidget.isMoving) {
      _controller.repeat();
    } else if (!widget.isMoving && oldWidget.isMoving) {
      _controller.stop();
      setState(() {
        _currentFrame = 0;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: widget.size * (11 / 14), // 가로세로 비율 유지 (11x14 그리드)
        height: widget.size,
        child: CustomPaint(
          painter: _CharacterPainter(
            clothesColor: widget.color,
            frame: widget.isMoving ? _currentFrame : 0,
          ),
        ),
      ),
    );
  }
}

class _CharacterPainter extends CustomPainter {
  final Color clothesColor;
  final int frame;

  _CharacterPainter({required this.clothesColor, required this.frame});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    const int gridWidth = 11;
    const int gridHeight = 14;
    final double pixelSize = size.height / gridHeight;

    // 팔레트 정의
    const Color brown = Color(0xFF795548); // 🟫 머리카락, 신발
    const Color skin = Color(0xFFFFCCBC); // 😊 살색
    const Color pants = Color(0xFF37474F); // 👖 바지
    const Color black = Colors.black; // ⬛ 눈
    final Color clothes = clothesColor; // 🟦 옷 (파라미터로 받음)

    // 도안 배치 (주신 텍스트 기반)
    final List<List<String>> mask;

    if (frame == 0) {
      // Idle / Frame 0
      mask = [
        ". . B B B B B B . . .".split(" "),
        ". B B B B B B B B . .".split(" "),
        ". B B S S S S B B . .".split(" "),
        ". B S E S S E S B . .".split(" "),
        ". . S S S S S S . . .".split(" "),
        ". . . C C C C . . . .".split(" "),
        ". . S C C C C S . . .".split(" "),
        ". . S C C C C S . . .".split(" "),
        ". . . C C C C . . . .".split(" "),
        ". . . P P P P . . . .".split(" "),
        ". . . P P P P . . . .".split(" "),
        ". . . P . . P . . . .".split(" "),
        ". . B B . . B B . . .".split(" "),
        ". . B B . . B B . . .".split(" "),
      ];
    } else {
      // Walk / Frame 1 (다리 및 팔 움직임 추가)
      mask = [
        ". . B B B B B B . . .".split(" "),
        ". B B B B B B B B . .".split(" "),
        ". B B S S S S B B . .".split(" "),
        ". B S E S S E S B . .".split(" "),
        ". . S S S S S S . . .".split(" "),
        ". . . C C C C . . . .".split(" "),
        ". S . C C C C . . . .".split(" "),
        ". . S C C C C . . S .".split(" "),
        ". . . C C C C . . S .".split(" "),
        ". . . P P P P . . . .".split(" "),
        ". . . P P P P . . . .".split(" "),
        ". . B B . . . . . . .".split(" "),
        ". . . . . . P . . . .".split(" "),
        ". . . . . . B B . . .".split(" "),
      ];
    }

    for (int y = 0; y < gridHeight; y++) {
      for (int x = 0; x < gridWidth; x++) {
        if (x >= mask[y].length) continue;
        final char = mask[y][x];
        if (char == ".") continue;

        if (char == "B")
          paint.color = brown;
        else if (char == "S")
          paint.color = skin;
        else if (char == "C")
          paint.color = clothes;
        else if (char == "P")
          paint.color = pants;
        else if (char == "E")
          paint.color = black;

        canvas.drawRect(
          Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CharacterPainter oldDelegate) {
    return oldDelegate.clothesColor != clothesColor ||
        oldDelegate.frame != frame;
  }
}
