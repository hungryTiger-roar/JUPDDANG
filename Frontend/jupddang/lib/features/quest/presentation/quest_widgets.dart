import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:pixelarticons/pixelarticons.dart';

/// Q 버튼 위젯 - NES 스타일에 맞춤
class QuestButton extends StatefulWidget {
  final bool isCompleted;
  final VoidCallback onTap;
  final bool isHighlighted;

  const QuestButton({
    super.key,
    required this.isCompleted,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  State<QuestButton> createState() => _QuestButtonState();
}

class _QuestButtonState extends State<QuestButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // 호흡하는 듯한 효과 (0.0 -> 1.0 -> 0.0)
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isHighlighted) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(QuestButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighlighted != oldWidget.isHighlighted) {
      if (widget.isHighlighted) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
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
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: widget.isHighlighted
              ? BoxDecoration(
                  shape: BoxShape.rectangle, // FloatingActionButton 모양에 맞춤 (하지만 FAB는 기본적으로 원형이나 shape에 따라 다름)
                  // FAB가 BeveledRectangleBorder이므로 BoxShape.rectangle 사용
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withValues(
                          alpha: 0.6 + (0.4 * _animation.value)), // 0.6 ~ 1.0 투명도
                      blurRadius: 10 + (10 * _animation.value), // 10 ~ 20 blur
                      spreadRadius: 2 + (4 * _animation.value), // 2 ~ 6 spread
                    ),
                  ],
                )
              : null,
          child: child,
        );
      },
      child: FloatingActionButton.small(
        heroTag: "quest_button",
        onPressed: widget.onTap,
        backgroundColor: widget.isCompleted ? const Color(0xFF17C964) : Colors.black,
        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        child: widget.isCompleted
            ? const Icon(Pixel.check, color: Colors.white)
            : const Text(
                'Q',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

/// 퀘스트 튜토리얼 모달 - X 버튼으로만 닫기
class QuestTutorialModal extends StatelessWidget {
  final VoidCallback onClose;

  const QuestTutorialModal({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: NesContainer(
          width: 300,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "플로깅 퀘스트",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  NesIconButton(icon: NesIcons.close, onPress: onClose),
                ],
              ),
              const SizedBox(height: 16),

              // 아이콘
              NesIcon(
                iconData: NesIcons.check,
                size: const Size(48, 48),
                primaryColor: Colors.black,
              ),
              const SizedBox(height: 16),

              // 안내 텍스트
              const Text(
                "플로깅을 종료하려면\nBefore/After 사진을 촬영해야 합니다",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
              const SizedBox(height: 16),

              // Q버튼 안내
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "우측 ",
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        'Q',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    " 버튼을 눌러주세요",
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 확인 버튼
              NesButton(
                type: NesButtonType.primary,
                onPressed: onClose,
                child: const Text("확인"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 퀘스트 사진 슬롯 위젯 - NES 스타일
class QuestPhotoSlot extends StatelessWidget {
  final String label;
  final String labelKo;
  final XFile? file;
  final VoidCallback onTap;
  final int? trashCount;

  const QuestPhotoSlot({
    super.key,
    required this.label,
    this.labelKo = "",
    this.file,
    required this.onTap,
    this.trashCount,
  });

  @override
  Widget build(BuildContext context) {
    return NesContainer(
      padding: EdgeInsets.zero,
      backgroundColor: file == null ? Colors.grey[300] : Colors.grey[200],
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 140, // 120 → 140으로 증가
          width: double.infinity,
          child: file == null
              ? _buildEmptySlot(context)
              : _buildFilledSlot(context),
        ),
      ),
    );
  }

  Widget _buildEmptySlot(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 라벨
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 카메라 아이콘
          Icon(Pixel.camera, size: 36, color: Colors.black54),
          const SizedBox(height: 8),
          // 안내 텍스트
          Text(
            "탭하여 촬영",
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledSlot(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 이미지
        Image.file(File(file!.path), fit: BoxFit.cover),
        // 라벨 오버레이
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // 재촬영 버튼
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: const Icon(Pixel.reload, size: 16, color: Colors.white),
            ),
          ),
        ),
        // 쓰레기 개수 (있는 경우)
        if (trashCount != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                "쓰레기: $trashCount개",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 퀘스트 모달 위젯 - X 버튼으로만 닫기
class QuestModal extends StatelessWidget {
  final XFile? beforeImage;
  final XFile? afterImage;
  final int? beforeTrashCount;
  final int? afterTrashCount;
  final VoidCallback onClose;
  final VoidCallback onTakeBeforePhoto;
  final VoidCallback onTakeAfterPhoto;
  final VoidCallback? onValidate;

  const QuestModal({
    super.key,
    this.beforeImage,
    this.afterImage,
    this.beforeTrashCount,
    this.afterTrashCount,
    required this.onClose,
    required this.onTakeBeforePhoto,
    required this.onTakeAfterPhoto,
    this.onValidate,
  });

  double get progress {
    double p = 0.0;
    if (beforeImage != null) p += 0.5;
    if (afterImage != null) p += 0.5;
    return p;
  }

  bool get canValidate => beforeImage != null && afterImage != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: NesContainer(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 12),
                    _buildProgressSection(context),
                    const SizedBox(height: 16),
                    QuestPhotoSlot(
                      label: "BEFORE",
                      labelKo: "전",
                      file: beforeImage,
                      onTap: onTakeBeforePhoto,
                      trashCount: beforeTrashCount,
                    ),
                    const SizedBox(height: 12),
                    QuestPhotoSlot(
                      label: "AFTER",
                      labelKo: "후",
                      file: afterImage,
                      onTap: onTakeAfterPhoto,
                      trashCount: afterTrashCount,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "같은 위치에서 쓰레기를 줍기 전/후 사진을 촬영하세요",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 9, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    _buildValidateButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "퀘스트",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        NesIconButton(icon: NesIcons.close, onPress: onClose),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      children: [
        // NES 스타일 프로그레스 바
        NesContainer(
          padding: const EdgeInsets.all(4),
          backgroundColor: Colors.grey[300],
          child: Row(
            children: [
              if (progress > 0)
                Expanded(
                  flex: (progress * 100).toInt().clamp(1, 100),
                  child: Container(height: 12, color: const Color(0xFF17C964)),
                ),
              if (progress < 1.0)
                Expanded(
                  flex: ((1 - progress) * 100).toInt().clamp(1, 100),
                  child: Container(height: 12, color: Colors.grey[400]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${(progress * 100).toInt()}% Complete",
          style: const TextStyle(fontSize: 10, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildValidateButton() {
    return SizedBox(
      width: double.infinity,
      child: NesButton(
        type: canValidate ? NesButtonType.success : NesButtonType.normal,
        onPressed: canValidate ? onValidate : null,
        child: Text(canValidate ? "검증하기" : "사진을 모두 촬영하세요"),
      ),
    );
  }
}
