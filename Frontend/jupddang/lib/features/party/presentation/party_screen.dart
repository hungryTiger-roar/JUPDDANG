import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'create_party_screen.dart';
import 'join_party_screen.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 타이틀
              const Text(
                'MULTIPLAYER\nPLOGGING',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF17C964),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 40),

              // 방 만들기 버튼
              _buildMenuButton(
                context,
                icon: Pixel.plus,
                title: 'CREATE ROOM',
                subtitle: '새로운 방을 만들어요',
                color: const Color(0xFF17C964),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreatePartyScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 참가하기 버튼
              _buildMenuButton(
                context,
                icon: Pixel.login,
                title: 'JOIN ROOM',
                subtitle: '초대 코드로 참가해요',
                color: const Color(0xFF3B82F6),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JoinPartyScreen(),
                    ),
                  );
                },
              ),

              const Spacer(),

              // 설명
              NesContainer(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Pixel.users, color: Colors.white70, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '최대 4명까지 함께 플로깅!',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Pixel.trophy, color: Colors.white70, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '방장의 화면이 모두에게 공유돼요',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100), // navbar 공간
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: NesContainer(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Pixel.arrowright, color: Colors.white54, size: 24),
          ],
        ),
      ),
    );
  }
}
