import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:image_picker/image_picker.dart';

class QuestButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NesButton(
          type: NesButtonType.normal,
          onPressed: onTap,
          child: Icon(
            isCompleted ? Pixel.check : Pixel.checkbox,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
        ),
        if (isHighlighted)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class QuestTutorialModal extends StatelessWidget {
  final VoidCallback onClose;

  const QuestTutorialModal({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: NesContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "QUEST GUIDE",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Complete the quest to earn improved rewards!",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "1. Take a 'Before' photo of trash.\n2. Pick up the trash.\n3. Take an 'After' photo.\n4. Validate to complete!",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 24),
                NesButton(
                  type: NesButtonType.primary,
                  onPressed: onClose,
                  child: const Text("GOT IT"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuestModal extends StatelessWidget {
  final XFile? beforeImage;
  final XFile? afterImage;
  final int beforeTrashCount;
  final int afterTrashCount;
  final VoidCallback onClose;
  final VoidCallback onTakeBeforePhoto;
  final VoidCallback onTakeAfterPhoto;
  final VoidCallback onValidate;

  const QuestModal({
    super.key,
    this.beforeImage,
    this.afterImage,
    required this.beforeTrashCount,
    required this.afterTrashCount,
    required this.onClose,
    required this.onTakeBeforePhoto,
    required this.onTakeAfterPhoto,
    required this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: NesContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "QUEST VERIFICATION",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    NesButton(
                      type: NesButtonType.normal,
                      onPressed: onClose,
                      child: const Icon(Pixel.close, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildPhotoSlot(
                        "BEFORE",
                        beforeImage,
                        onTakeBeforePhoto,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPhotoSlot(
                        "AFTER",
                        afterImage,
                        onTakeAfterPhoto,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (beforeTrashCount > 0 || afterTrashCount > 0)
                  Text(
                    "Detected: Before($beforeTrashCount) -> After($afterTrashCount)",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                const SizedBox(height: 16),
                NesButton(
                  type: NesButtonType.primary,
                  onPressed: onValidate,
                  child: const Text("VALIDATE QUEST"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSlot(String label, XFile? file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: NesContainer(
          padding: EdgeInsets.zero,
          child: file == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Pixel.camera, color: Colors.grey),
                    Text(
                      label,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                )
              : Image.file(File(file.path), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
