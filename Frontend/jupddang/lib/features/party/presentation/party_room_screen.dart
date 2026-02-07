import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:pixelarticons/pixelarticons.dart';
import 'package:jupddang/features/party/models/party_models.dart';
import '../data/party_service.dart';
import '../../../services/auth_service.dart';
import '../../plogging/data/plogging_socket_service.dart';
import '../../../widgets/pixel_character.dart';
import '../../plogging/presentation/map_screen.dart';

class PartyRoomScreen extends StatefulWidget {
  final int partyId;

  const PartyRoomScreen({super.key, required this.partyId});

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> {
  final PartyService _partyService = PartyService();

  final PloggingSocketService _socketService = PloggingSocketService();

  Party? _party;
  bool _loading = true;
  bool _starting = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadPartyDetail();

    // 웹소켓 연결 및 시작 감지 콜백 설정
    _socketService.onStatusUpdated = (status) {
      if (status == 'IN_PROGRESS' && mounted) {
        _pollTimer?.cancel();
        _socketService.disconnect();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(partyId: widget.partyId),
          ),
        );
      }
    };
    final userId = AuthService.userId ?? 'unknown';
    _socketService.connect(partyId: widget.partyId, userId: userId);

    // 2초마다 파티 정보 갱신 (백업 폴링)
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _loadPartyDetail(silent: true);
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _socketService.disconnect();
    super.dispose();
  }

  Future<void> _loadPartyDetail({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);

    try {
      final party = await _partyService.getPartyDetail(widget.partyId);

      if (mounted) {
        setState(() {
          _party = party;
          _loading = false;
        });

        // 파티가 시작되었으면 플로깅 화면으로 이동
        if (party.status == 'IN_PROGRESS') {
          _pollTimer?.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MapScreen(partyId: widget.partyId),
            ),
          );
        }
      }
    } catch (e) {
      if (!silent && mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('파티 정보 로드 실패: $e')));
      }
    }
  }

  Future<void> _moveToMapScreen() async {
    setState(() => _starting = true);
    try {
      // [Fix] Call backend API to start party
      await _partyService.startParty(widget.partyId);

      // 시작 후 바로 플로깅 화면으로 이동
      if (mounted) {
        _pollTimer?.cancel();
        // Also disconnect socket here as MapScreen will create a new one?
        // Or keep it? Current logic says disconnect on line 41.
        // But map screen does connect again.
        _socketService.disconnect();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(partyId: widget.partyId),
          ),
        );
      }
    } catch (e) {
      setState(() => _starting = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('파티 시작 실패: $e')));
      }
    }
  }

  Color _getColorForUser(String userId) {
    final colors = [Colors.blue, Colors.green, Colors.purple, Colors.orange];
    return colors[userId.hashCode % colors.length];
  }

  // 파티 인원수에 따른 보너스 배율 계산
  double _getBonusMultiplier(int memberCount) {
    if (memberCount < 2) return 1.0;
    return 1.0 + (memberCount - 1) * 0.2;
  }

  // 보너스 카드 위젯 (NES UI 스타일)
  Widget _buildBonusCard() {
    final memberCount = _party?.currentMembers ?? 1;
    final multiplier = _getBonusMultiplier(memberCount);
    final bonusPercent = ((multiplier - 1.0) * 100).toInt();

    return NesContainer(
      padding: const EdgeInsets.all(12),
      backgroundColor: const Color(0xFFFFF9E6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Pixel.coin, color: Color(0xFFFBBF24), size: 18),
              const SizedBox(width: 8),
              const Text(
                'PARTY BONUS',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: memberCount >= 2 ? const Color(0xFF17C964) : Colors.grey,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(2, 2)),
              ],
            ),
            child: Text(
              memberCount >= 2
                  ? '${memberCount}명 ▶ x${multiplier.toStringAsFixed(1)} (+$bonusPercent%)'
                  : '2명 이상 참여시 보너스!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          child: NesButton(
                            type: NesButtonType.normal,
                            onPressed: () => Navigator.pop(context),
                            child: const Icon(
                              Pixel.arrowleft,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _party?.name.toUpperCase() ?? 'PARTY',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 40),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 초대 코드 카드
                    NesContainer(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(
                            Pixel.lock,
                            color: Color(0xFF17C964),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Invite Code:',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _party?.inviteCode ?? '',
                            style: const TextStyle(
                              color: Color(0xFF17C964),
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: _party?.inviteCode ?? ''),
                              );
                              NesSnackbar.show(
                                context,
                                text: '초대 코드가 복사되었습니다',
                                type: NesSnackbarType.success,
                              );
                            },
                            icon: const Icon(Pixel.copy, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 참가자 목록 제목
                    Row(
                      children: [
                        const Text(
                          'MEMBERS',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_party?.currentMembers ?? 0} / ${_party?.maxMembers ?? 4}',
                          style: const TextStyle(
                            color: Color(0xFF17C964),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // 파티 보너스 배율 표시
                    _buildBonusCard(),

                    const SizedBox(height: 16),

                    // 참가자 목록
                    Expanded(
                      child: ListView.builder(
                        itemCount: _party?.members.length ?? 0,
                        itemBuilder: (context, index) {
                          final member = _party!.members[index];
                          final isCurrentUser =
                              member.userId == AuthService.userId;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: NesContainer(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: const Color(0xFFF0F0F0),
                              child: Row(
                                children: [
                                  // 아바타
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: PixelCharacter(
                                        size: 32,
                                        color: _getColorForUser(member.userId),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // 유저 정보
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              member.userId,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (isCurrentUser) ...[
                                              const SizedBox(width: 8),
                                              NesContainer(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                backgroundColor: const Color(
                                                  0xFF17C964,
                                                ),
                                                child: const Text(
                                                  'YOU',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            if (member.isLeader) ...[
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Pixel.trophy,
                                                color: Color(0xFFFBBF24),
                                                size: 16,
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          member.isLeader ? 'Leader' : 'Member',
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 시작 버튼 (방장만)
                    if (_party?.isCurrentUserLeader == true)
                      SizedBox(
                        width: double.infinity,
                        child: NesButton(
                          type: NesButtonType.success,
                          onPressed: _starting ? null : _moveToMapScreen,
                          child: Text(
                            _starting ? 'STARTING...' : 'START PLOGGING',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    else
                      NesContainer(
                        padding: const EdgeInsets.all(16),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Pixel.clock, color: Colors.white54, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Waiting for leader to start...',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
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
}
