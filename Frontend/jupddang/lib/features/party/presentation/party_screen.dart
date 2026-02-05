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
      backgroundColor: Colors.white,
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
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
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
                color: const Color(0xFF17C964),
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
                        Icon(Pixel.users, color: Colors.black54, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '최대 6명까지 함께 플로깅!',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Pixel.trophy, color: Colors.black54, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '방장의 화면이 모두에게 공유돼요',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 파티 보너스 설명 (NES UI 스타일)
              NesContainer(
                backgroundColor: const Color(0xFFFFF9E6),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Pixel.coin,
                          color: Color(0xFFFBBF24),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'PARTY BONUS',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _BonusChip(members: '2명', bonus: 'x1.2'),
                        _BonusChip(members: '3명', bonus: 'x1.4'),
                        _BonusChip(members: '4명', bonus: 'x1.6'),
                        _BonusChip(members: '5명', bonus: 'x1.8'),
                        _BonusChip(members: '6명', bonus: 'x2.0'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        '▶ 인원이 많을수록 점수 UP! ◀',
                        style: TextStyle(
                          color: Color(0xFF17C964),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
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
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Pixel.arrowright, color: Colors.black54, size: 24),
          ],
        ),
      ),
    );
  }
}

class _BonusChip extends StatelessWidget {
  final String members;
  final String bonus;

  const _BonusChip({required this.members, required this.bonus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            bonus,
            style: const TextStyle(
              color: Color(0xFF17C964),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            members,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
