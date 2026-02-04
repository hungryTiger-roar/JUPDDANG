import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pixelarticons/pixelarticons.dart';

import '../../../services/auth_service.dart';
import '../../../widgets/pixel_character.dart';
import '../data/party_service.dart';
import '../data/party_socket_service.dart';
import 'package:jupddang/features/party/models/party_models.dart';


class PartyPloggingScreen extends StatefulWidget {
  final int partyId;

  const PartyPloggingScreen({super.key, required this.partyId});

  @override
  State<PartyPloggingScreen> createState() => _PartyPloggingScreenState();
}

class _PartyPloggingScreenState extends State<PartyPloggingScreen> {
  final PartyService _partyService = PartyService();
  final PartySocketService _socketService = PartySocketService();

  Party? _party;
  List<PartyActivity> _activities = [];
  bool _loading = true;
  // Timer? _pollTimer; // 웹소켓 사용으로 제거

  // 방장의 활동 정보
  PartyActivity? get _leaderActivity {
    if (_party == null) return null;
    return _activities.firstWhere(
      (a) => a.userId == _party!.leaderId,
      orElse: () => PartyActivity(
        userId: _party!.leaderId,
        totalDistance: 0,
        elapsedTime: 0,
        isCompleted: false,
      ),
    );
  }

  bool get _isLeader => _party?.isCurrentUserLeader ?? false;

  @override
  void initState() {
    super.initState();
    _loadPartyInfo();

    // 웹소켓 연결 및 콜백 설정
    _socketService.onActivitiesUpdated = (activities) {
      if (mounted) {
        setState(() {
          _activities = activities;
          _loading = false;
        });
      }
    };
    _socketService.connect(widget.partyId);
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  Future<void> _loadPartyInfo() async {
    try {
      final party = await _partyService.getPartyDetail(widget.partyId);
      if (mounted) {
        setState(() => _party = party);
      }
      await _loadActivities();
    } catch (e) {
      print('Load party info error: $e');
    }
  }

  Future<void> _loadActivities() async {
    try {
      final activities = await _partyService.getActivityStatus(widget.partyId);
      if (mounted) {
        setState(() {
          _activities = activities;
          _loading = false;
        });
      }
    } catch (e) {
      print('Load activities error: $e');
      if (_loading && mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(2)}km';
    }
  }

  Color _getColorForUser(String userId) {
    final colors = [Colors.blue, Colors.green, Colors.purple, Colors.orange];
    return colors[userId.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final leaderActivity = _leaderActivity;

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF17C964)),
            )
          : SafeArea(
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
                              color: const Color(0xFF1F1F1F),
                              border: Border.all(color: Colors.black, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Pixel.arrowleft,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF17C964).withOpacity(0.2),
                            border: Border.all(
                              color: const Color(0xFF17C964),
                              width: 2,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Pixel.play,
                                color: Color(0xFF17C964),
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Color(0xFF17C964),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 40),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 방장 정보 (모두에게 표시)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        border: Border.all(
                          color: const Color(0xFFFBBF24),
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Pixel.trophy,
                                color: Color(0xFFFBBF24),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isLeader
                                    ? 'YOU ARE LEADING'
                                    : 'FOLLOWING LEADER',
                                style: const TextStyle(
                                  color: Color(0xFFFBBF24),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _party?.leaderId ?? 'Leader',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 방장의 플로깅 통계
                    Row(
                      children: [
                        // 거리
                        Expanded(
                          child: _buildStatCard(
                            icon: Pixel.map,
                            label: 'DISTANCE',
                            value: _formatDistance(
                              leaderActivity?.totalDistance ?? 0,
                            ),
                            color: const Color(0xFF17C964),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 시간
                        Expanded(
                          child: _buildStatCard(
                            icon: Pixel.clock,
                            label: 'TIME',
                            value: _formatTime(
                              leaderActivity?.elapsedTime ?? 0,
                            ),
                            color: const Color(0xFF3B82F6),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // 참가자 활동 상태
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'TEAM STATUS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 참가자 목록
                    Expanded(
                      child: ListView.builder(
                        itemCount: _activities.length,
                        itemBuilder: (context, index) {
                          final activity = _activities[index];
                          final isCurrentUser =
                              activity.userId == AuthService.userId;
                          final isLeaderUser =
                              activity.userId == _party?.leaderId;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1F1F1F),
                              border: Border.all(
                                color: isCurrentUser
                                    ? const Color(0xFF17C964)
                                    : Colors.black,
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // 아바타
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF141414),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: PixelCharacter(
                                      size: 28,
                                      color: _getColorForUser(activity.userId),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // 유저 정보
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            activity.userId,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (isLeaderUser) ...[
                                            const SizedBox(width: 6),
                                            const Icon(
                                              Pixel.trophy,
                                              color: Color(0xFFFBBF24),
                                              size: 12,
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            _formatDistance(
                                              activity.totalDistance,
                                            ),
                                            style: const TextStyle(
                                              color: Color(0xFF17C964),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _formatTime(activity.elapsedTime),
                                            style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // 완료 상태
                                if (activity.isCompleted)
                                  const Icon(
                                    Pixel.check,
                                    color: Color(0xFF17C964),
                                    size: 20,
                                  )
                                else
                                  const Icon(
                                    Pixel.reload,
                                    color: Colors.white38,
                                    size: 20,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 안내 메시지
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Pixel.infobox,
                            color: Colors.white54,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _isLeader
                                  ? '실제 플로깅은 지도 화면에서 진행하세요'
                                  : '방장의 플로깅을 실시간으로 확인할 수 있어요',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
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

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: color, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
