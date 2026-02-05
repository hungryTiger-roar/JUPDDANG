import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import '../../../services/auth_service.dart';
import 'package:jupddang/features/ranking/models/ranking_model.dart';
import '../data/ranking_service.dart';
import '../../../widgets/pixel_character.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final RankingService _rankingService = RankingService();
  bool _isTotal = true; // Use Total as default
  late Future<RankingResponse> _rankingFuture;

  final String currentUserId = AuthService.userId ?? '';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterTabs(),
            const SizedBox(height: 8),
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
                        style: const TextStyle(color: Colors.black54),
                      ),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.topRankers.isEmpty) {
                    return const Center(
                      child: Text(
                        '데이터가 없습니다.',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  final topRankers = snapshot.data!.topRankers; // 1,2,3등
                  final myRankWindow = snapshot.data!.myRankWindow; // 내 주변 랭킹

                  return RefreshIndicator(
                    onRefresh: () async => _loadRanking(),
                    color: const Color(0xFF17C964),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 40),
                            children: [
                              // 1~3등
                              if (topRankers.isNotEmpty) ...[
                                _buildPodium(topRankers),
                                const SizedBox(height: 10),
                              ],
                              // 1등과 4등 사이가 멀면 점선 표시
                              if (myRankWindow.isNotEmpty &&
                                  myRankWindow.first.rank > 4)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.black26,
                                  ),
                                ),

                              // 내 주변 리스트
                              ...myRankWindow.map(
                                (ranker) => _buildRankItem(ranker),
                              ),

                              // 리스트가 너무 짧을 때를 대비한 여백
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
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
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isTotal ? 'TOTAL BEST PLAYERS' : 'MONTHLY BEST PLAYERS',
            style: const TextStyle(color: Colors.black54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Row(
        children: [
          _filterChip('TOTAL', _isTotal, () {
            if (!_isTotal) {
              setState(() => _isTotal = true);
              _loadRanking();
            }
          }),
          const SizedBox(width: 10),
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
    return SizedBox(
      height: 48,
      child: NesButton(
        type: isSelected ? NesButtonType.success : NesButtonType.normal,
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      height: 230,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: displayOrder.map((ranker) {
          if (ranker == null) return const Expanded(child: SizedBox());

          final isFirst = ranker.rank == 1;
          final isSecond = ranker.rank == 2;
          final height = isFirst ? 120.0 : (isSecond ? 90.0 : 70.0);
          final pedestalColor = isFirst
              ? const Color(0xFFFFD700)
              : (isSecond ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32));

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PixelCharacter(
                  size: isFirst ? 55 : 45,
                  color: isFirst
                      ? Colors.red
                      : (isSecond ? Colors.blue : Colors.orange),
                  isMoving: isFirst,
                ),
                const SizedBox(height: 4),
                Text(
                  ranker.nickname.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 9,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                NesContainer(
                  height: height,
                  padding: const EdgeInsets.all(8),
                  backgroundColor: pedestalColor,
                  child: Center(
                    child: Text(
                      '${ranker.rank}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(1.5, 1.5)),
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
    final isMe = ranker.userId == currentUserId;

    return NesContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      backgroundColor: isMe ? const Color(0xFFF0F0F0) : Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: 35,
            child: Text(
              '${ranker.rank}',
              style: TextStyle(
                color: isMe ? const Color(0xFF17C964) : Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                fontStyle: isMe ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 내 캐릭터만 핑크색으로 포인트 & 움직임 효과!
          PixelCharacter(
            size: 30,
            color: isMe ? Colors.pinkAccent : Colors.blueGrey,
            isMoving: isMe,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              ranker.nickname.toUpperCase(),
              style: TextStyle(
                color: isMe ? const Color(0xFF17C964) : Colors.black,
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
}
