import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'create_party_screen.dart';
import 'join_party_screen.dart';

class PartyMenuScreen extends StatelessWidget {
  const PartyMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                        ],
                      ),
                      child: const Icon(
                        Pixel.arrowleft,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'PARTY',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 60),

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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12, width: 2),
                ),
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

              // 파티 보너스 설명
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9E6),
                  border: Border.all(color: Color(0xFFFBBF24), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Pixel.coin, color: Color(0xFFFBBF24), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'PARTY BONUS',
                          style: TextStyle(
                            color: Color(0xFFB45309),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _BonusChip(members: '2명', bonus: '1.2배'),
                        _BonusChip(members: '3명', bonus: '1.4배'),
                        _BonusChip(members: '4명', bonus: '1.6배'),
                        _BonusChip(members: '5명', bonus: '1.8배'),
                        _BonusChip(members: '6명', bonus: '2.0배'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        '인원이 많을수록 점수 보너스 UP!',
                        style: TextStyle(
                          color: Color(0xFF17C964),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(6, 6)),
          ],
        ),
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
            const Icon(Pixel.arrowright, color: Colors.black26, size: 24),
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
    return Column(
      children: [
        Text(
          bonus,
          style: const TextStyle(
            color: Color(0xFF17C964),
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          members,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
