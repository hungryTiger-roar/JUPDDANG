import 'package:flutter/material.dart';
import '../../models/raid_models.dart';
import '../../services/raid_service.dart';
import '../../widgets/pixel_character.dart';
import '../../widgets/animated_boss_widget.dart';

class BossDetailScreen extends StatefulWidget {
  final int bossId;
  final RaidBossModel? boss; // Optional: for displaying boss animation immediately

  const BossDetailScreen({super.key, required this.bossId, this.boss});

  @override
  State<BossDetailScreen> createState() => _BossDetailScreenState();
}

class _BossDetailScreenState extends State<BossDetailScreen> {
  final RaidService _raidService = RaidService();
  late Future<RaidDetailModel?> _detailFuture;

  @override
  void initState() {
    super.initState();
    _loadBossDetail();
  }

  void _loadBossDetail() {
    setState(() {
      _detailFuture = _raidService.getRaidBossDetail(widget.bossId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text(
          'BOSS ZONE',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<RaidDetailModel?>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF17C964),
              ),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '데이터를 불러올 수 없습니다.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadBossDetail,
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          final detail = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _loadBossDetail(),
            color: const Color(0xFF17C964),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildBossAnimation(),
                  const SizedBox(height: 24),
                  _buildBossInfo(detail),
                  const SizedBox(height: 32),
                  _buildRankingSection(detail),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBossAnimation() {
    // Get boss type from the widget.boss if available
    BossType bossType = BossType.trashCan; // Default
    if (widget.boss != null) {
      switch (widget.boss!.bossType % 4) {
        case 0:
          bossType = BossType.trashCan;
          break;
        case 1:
          bossType = BossType.trashBag;
          break;
        case 2:
          bossType = BossType.dustCloud;
          break;
        case 3:
          bossType = BossType.rottenSprout;
          break;
      }
    }

    return Container(
      height: 200,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: Colors.red, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(8, 8)),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBossWidget(
              bossType: bossType,
              size: 120,
            ),
            const SizedBox(height: 16),
            const Text(
              'BOSS',
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBossInfo(RaidDetailModel detail) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: const Color(0xFF17C964), width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(6, 6)),
        ],
      ),
      child: Column(
        children: [
          Text(
            detail.bossName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, thickness: 2),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.eco,
                color: Color(0xFF17C964),
                size: 32,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL CONTRIBUTION',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${detail.totalAccumulatedScore} P',
                    style: const TextStyle(
                      color: Color(0xFF17C964),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankingSection(RaidDetailModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'CONTRIBUTION RANKING',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (detail.nearbyRankers.isNotEmpty)
          _buildNearbyRankers(detail.nearbyRankers, detail.myRanking?.userId),
        if (detail.nearbyRankers.isEmpty && detail.topRankers.isNotEmpty)
          _buildTopRankers(detail.topRankers),
        if (detail.nearbyRankers.isEmpty && detail.topRankers.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                '아직 참여자가 없습니다.',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNearbyRankers(List<RaidRankInfo> rankers, String? myUserId) {
    return Column(
      children: rankers.map((ranker) {
        final isMe = myUserId != null && ranker.userId == myUserId;
        return _buildRankItem(ranker, isMe: isMe);
      }).toList(),
    );
  }

  Widget _buildTopRankers(List<RaidRankInfo> rankers) {
    return Column(
      children: rankers.map((ranker) => _buildRankItem(ranker)).toList(),
    );
  }

  Widget _buildRankItem(RaidRankInfo ranker, {bool isMe = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFF17C964).withOpacity(0.2) : const Color(0xFF1F1F1F),
        border: Border.all(
          color: isMe ? const Color(0xFF17C964) : Colors.black,
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isMe ? const Color(0xFF17C964).withOpacity(0.3) : Colors.black,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              '#${ranker.rank}',
              style: TextStyle(
                color: isMe ? const Color(0xFF17C964) : Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          PixelCharacter(
            size: 32,
            color: isMe ? const Color(0xFF17C964) : Colors.blueGrey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ranker.nickname.toUpperCase(),
                  style: TextStyle(
                    color: isMe ? const Color(0xFF17C964) : Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                if (isMe)
                  const Text(
                    'YOU',
                    style: TextStyle(
                      color: Color(0xFF17C964),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '${ranker.score} P',
            style: const TextStyle(
              color: Color(0xFF17C964),
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
