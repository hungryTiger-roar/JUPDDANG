import 'package:flutter/material.dart';
import '../../models/ranking_model.dart';
import '../../services/ranking_service.dart';
import '../../widgets/pixel_character.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final RankingService _rankingService = RankingService();
  bool _isTotal = true; // Use Total as default
  late Future<RankingResponse> _rankingFuture;

  @override
  void initState() {
    super.initState();
    _loadRanking();
  }

  void _loadRanking() {
    setState(() {
      _rankingFuture = _isTotal
          ? _rankingService.getTotalRanking()
          : _rankingService.getMonthlyRanking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414), // Dark background for game feel
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterTabs(),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<RankingResponse>(
                future: _rankingFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF17C964),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '에러 발생: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.topRankers.isEmpty) {
                    return const Center(
                      child: Text(
                        '데이터가 없습니다.',
                        style: const TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  final topRankers = snapshot.data!.topRankers; // 1,2,3등
                  final myRankWindow = snapshot.data!.myRankWindow; // 내 주변 랭킹
                  final myRanking = snapshot.data!.myRanking;

                  return RefreshIndicator(
                    onRefresh: () async => _loadRanking(),
                    color: const Color(0xFF17C964),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 24),
                            children: [
                              // 1~3등
                              if (topRankers.isNotEmpty) ...[
                                _buildPodium(topRankers),
                                const SizedBox(height: 20),
                              ],
                              // 1등과 4등 사이가 멀면 점선 표시
                              if (myRankWindow.isNotEmpty && myRankWindow.first.rank > 3)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Icon(Icons.more_vert, color: Colors.white24),
                                ),

                              // 내 주변 리스트
                              ...myRankWindow.map((ranker) => _buildRankItem(ranker)),
                            ],
                          ),
                        ),
                        if (myRanking != null) _buildMyRank(myRanking),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RANKING',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _isTotal ? 'TOTAL BEST PLAYERS' : 'MONTHLY BEST PLAYERS',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _filterChip('TOTAL', _isTotal, () {
            if (!_isTotal) {
              setState(() => _isTotal = true);
              _loadRanking();
            }
          }),
          const SizedBox(width: 12),
          _filterChip('MONTHLY', !_isTotal, () {
            if (_isTotal) {
              setState(() => _isTotal = false);
              _loadRanking();
            }
          }),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF17C964) : const Color(0xFF1F1F1F),
          border: Border.all(color: Colors.black, width: 3.0),
          boxShadow: isSelected
              ? []
              : const [BoxShadow(color: Colors.black, offset: Offset(3, 3))],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPodium(List<Ranker> top3) {
    final List<Ranker?> displayOrder = [
      top3.length > 1 ? top3[1] : null,
      top3.isNotEmpty ? top3[0] : null,
      top3.length > 2 ? top3[2] : null,
    ];

    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: displayOrder.map((ranker) {
          if (ranker == null) return const Expanded(child: SizedBox());

          final isFirst = ranker.rank == 1;
          final isSecond = ranker.rank == 2;
          final height = isFirst ? 140.0 : (isSecond ? 100.0 : 80.0);
          final pedestalColor = isFirst
              ? const Color(0xFFFFD700)
              : (isSecond ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32));

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PixelCharacter(
                  size: isFirst ? 60 : 50,
                  color: isFirst
                      ? Colors.red
                      : (isSecond ? Colors.blue : Colors.orange),
                  isMoving: isFirst,
                ),
                const SizedBox(height: 6),
                Text(
                  ranker.nickname.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  height: height,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: pedestalColor,
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${ranker.rank}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(2, 2)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRankItem(Ranker ranker) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: Colors.black, width: 3.0),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '${ranker.rank}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const PixelCharacter(size: 32, color: Colors.blueGrey),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              ranker.nickname.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
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

  Widget _buildMyRank(Ranker myRanking) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        border: Border(top: BorderSide(color: Colors.black, width: 4)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const Text(
              'MY RANK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
            const Spacer(),
            Text(
              '#${myRanking.rank}',
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${myRanking.score} P',
              style: const TextStyle(
                color: Color(0xFF17C964),
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
