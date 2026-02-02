import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveAnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final String rivUrl; // Rive file URL or path
  final String stateMachineName;

  const RiveAnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.rivUrl =
        'https://public.rive.app/community/runtime-files/2191-4327-button-states.riv',
    this.stateMachineName = 'ButtonStateMachine',
  });

  @override
  State<RiveAnimatedButton> createState() => _RiveAnimatedButtonState();
}

class _RiveAnimatedButtonState extends State<RiveAnimatedButton> {
  SMIBool? _isPressed;
  SMIBool? _isHovered;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      widget.stateMachineName,
    );
    if (controller != null) {
      artboard.addController(controller);
      _isPressed = controller.findSMI('Pressed');
      _isHovered = controller.findSMI('Hovered');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _isPressed?.value = true,
      onTapUp: (_) {
        _isPressed?.value = false;
        widget.onPressed();
      },
      onTapCancel: () => _isPressed?.value = false,
      child: MouseRegion(
        onEnter: (_) => _isHovered?.value = true,
        onExit: (_) => _isHovered?.value = false,
        child: SizedBox(
          width: 250,
          height: 80,
          child: Stack(
            children: [
              RiveAnimation.network(
                widget.rivUrl,
                onInit: _onRiveInit,
                fit: BoxFit.contain,
              ),
              Center(
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
