import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../../../core/utils/tier_utils.dart';

class BeginnerGuideScreen extends StatelessWidget {
  const BeginnerGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Pixel.arrowleft, size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '초보자 가이드',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
            // Section 1: 게임 소개
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('JupDDang이란?', Pixel.gamepad),
                    const SizedBox(height: 8),
                    NesContainer(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'JupDDang은 플로깅(Plogging)을 즐기면서\n'
                        '다른 유저들과 경쟁하는 땅따먹기 게임입니다!\n\n'
                        '산책하면서 쓰레기를 줍는 즐거운 활동으로\n'
                        '환경도 지키고 땅을 획득해보세요!',
                        style: TextStyle(fontSize: 14, height: 1.7, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Section 2: 점수 시스템
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('점수 시스템', Pixel.coin),
                    const SizedBox(height: 8),
                    NesContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _GuideItem(
                            icon: Pixel.camera,
                            text: '전/후 사진을 찍어 인증하면 점수 획득',
                            textColor: Colors.black,
                          ),
                          SizedBox(height: 10),
                          _GuideItem(
                            icon: Pixel.users,
                            text: '파티 참여 시 보너스 점수 추가 지급',
                            textColor: Colors.black,
                          ),
                          SizedBox(height: 10),
                          _GuideItem(
                            icon: Pixel.trophy,
                            text: '점수를 모아 더 높은 티어로 승급하세요!',
                            textColor: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Section 3: 티어
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('티어', Pixel.moonstars),
                    const SizedBox(height: 8),
                    NesContainer(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      child: Column(
                        children: [
                          _TierTableHeader(),
                          const Divider(height: 1, color: Colors.black26),
                          const SizedBox(height: 4),
                          _TierRow(
                            korName: '브론즈',
                            tierBadge: 'Bronze 1',
                            range: '0 ~ 4,999',
                          ),
                          _TierRow(
                            korName: '실버',
                            tierBadge: 'Silver 1',
                            range: '5,000 ~ 9,999',
                          ),
                          _TierRow(
                            korName: '골드',
                            tierBadge: 'Gold 1',
                            range: '10,000 ~ 19,999',
                          ),
                          _TierRow(
                            korName: '플래티넘',
                            tierBadge: 'Platinum 1',
                            range: '20,000 ~ 29,999',
                          ),
                          _TierRow(
                            korName: '다이아몬드',
                            tierBadge: 'Diamond 1',
                            range: '30,000 ~ 39,999',
                          ),
                          _TierRow(
                            korName: '엘리트',
                            tierBadge: 'Elite 1',
                            range: '40,000 ~ 54,999',
                          ),
                          _TierRow(
                            korName: '마스터',
                            tierBadge: 'Master 1',
                            range: '55,000 ~ 74,999',
                          ),
                          _TierRow(
                            korName: '그랜드마스터',
                            tierBadge: 'Grandmaster 1',
                            range: '75,000 ~ 99,999',
                          ),
                          _TierRow(
                            korName: '챔피언',
                            tierBadge: 'Champion',
                            range: '100,000 ~',
                          ),
                          _TierRow(
                            korName: '레전드',
                            tierBadge: 'Legend',
                            range: 'TOP 3',
                            isLegend: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '* 랭크 시스템 안내\n'
                        '  브론즈~그랜드마스터는 5단계 → 1단계로 나뉩니다.\n'
                        '  위 이미지는 각 티어의 최고 단계(1단계) 뱃지입니다.\n'
                        '  플러깅을 통해 더 높은 티어에 도전해 보세요!',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '* 레전드는 누적 랭킹 TOP 3에게만 부여되는 특별 등급입니다.',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _TierTableHeader extends StatelessWidget {
  const _TierTableHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: const [
          SizedBox(width: 36),
          Expanded(
            flex: 3,
            child: Text(
              '티어',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              '점수 범위 (P)',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  final String korName;
  final String tierBadge;
  final String range;
  final bool isLegend;

  const _TierRow({
    required this.korName,
    required this.tierBadge,
    required this.range,
    this.isLegend = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isLegend ? const Color(0xFFFFAA00) : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Image.asset(
            TierUtils.getTierBadgePath(tierBadge),
            width: 28,
            height: 28,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox(width: 28, height: 28),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              korName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isLegend ? FontWeight.w900 : FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              range,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isLegend ? FontWeight.w900 : FontWeight.normal,
                color: textColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;

  const _GuideItem({required this.icon, required this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF17C964)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, height: 1.4, color: textColor),
          ),
        ),
      ],
    );
  }
}
