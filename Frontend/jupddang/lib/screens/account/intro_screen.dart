import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import '../../widgets/pixel_button.dart';
import '../core/main_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414), // Dark Background
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 2),
            // 로고 (작게)
            Center(
              child: Image.asset(
                'assets/images/splash_logo.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Jupddang',
                style: TextStyle(
                  color: Color(0xFF17C964),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(flex: 1),
            // 로그인 버튼
            PixelButton(
              text: 'LOGIN',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ), // Changed from 24 to 20 to match snippet
            // 회원가입 버튼 (original 'SIGN UP' button)
            PixelButton(
              text: 'SIGN UP',
              isGreen: false,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
            ),
            const SizedBox(height: 20), // Added space for new button
            // 로그인 없이 사용하기 버튼 (new 'GUEST MODE' button)
            PixelButton(
              text: 'GUEST MODE',
              isGreen: false,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
              },
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
