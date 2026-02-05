import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import '../../../../core/logger/log_service.dart';
import '../../../../core/logger/log_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import '../../../widgets/pixel_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _dotCount = 0;
  Timer? _dotTimer;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    // Animation controller for subtle effects
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Animated loading dots
    _dotTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
        });
      }
    });

    // Switch to buttons after 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoaded = true;
          _animationController
              .stop(); // Stop animation when loaded if not needed
          _dotTimer?.cancel();
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: GestureDetector(
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LogScreen()),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with white background container (matching intro screen)
              Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF17C964), width: 5),
                ),
                padding: const EdgeInsets.all(30),
                child: Center(
                  child: Image.asset(
                    'assets/images/splash_logo.png',
                    width: 260,
                    height: 260,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Fixed height container to prevent layout shift
              SizedBox(
                height: 180, // Sufficient height for buttons
                child: _isLoaded
                    ? _buildAuthButtons()
                    : _buildLoadingIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, // Align to top of SizedBox
      children: [
        // Animated "LOADING" text with dots
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.7 + (_animationController.value * 0.3),
              child: child,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'LOADING',
                style: TextStyle(
                  color: Color(0xFF17C964),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 40,
                child: Text(
                  '.' * _dotCount,
                  style: const TextStyle(
                    color: Color(0xFF17C964),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Pixel art loading bar
        NesContainer(
          width: 240, // Match button width
          height: 32,
          padding: const EdgeInsets.all(4),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Row(
                children: List.generate(8, (index) {
                  final isActive =
                      index < ((_animationController.value * 8).floor() + 1);
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF17C964)
                            : Colors.transparent,
                      ),
                      // Inner pixel detail
                      child: isActive
                          ? null
                          : Center(
                              child: Container(
                                width: 4,
                                height: 4,
                                color: const Color(
                                  0xFFE0E0E0,
                                ), // Faint dot for empty slots
                              ),
                            ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start, // Align to top of SizedBox
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: child,
              ),
            );
          },
          child: PixelButton(
            text: 'LOGIN',
            isPulse: true,
            width: 320, // Match logo container width
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          // Slightly delayed start for the second button feel
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: child,
              ),
            );
          },
          child: PixelButton(
            text: 'SIGN UP',
            isGreen: false,
            width: 320, // Match logo container width
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}
