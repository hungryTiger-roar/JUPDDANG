import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../../models/party_models.dart';
import '../../services/party_service.dart';
import '../../services/auth_service.dart';
import '../../services/party_socket_service.dart';
import '../../widgets/pixel_button.dart';
import '../../widgets/pixel_character.dart';
import '../map/map_screen.dart';

class PartyRoomScreen extends StatefulWidget {
  final int partyId;

  const PartyRoomScreen({super.key, required this.partyId});

  @override
  State<PartyRoomScreen> createState() => _PartyRoomScreenState();
}

class _PartyRoomScreenState extends State<PartyRoomScreen> {
  final PartyService _partyService = PartyService();

  final PartySocketService _socketService = PartySocketService();

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
    _socketService.connect(widget.partyId);

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

  Future<void> _startParty() async {
    setState(() => _starting = true);
    try {
      await _partyService.startParty(widget.partyId);

      // 시작 후 바로 플로깅 화면으로 이동
      if (mounted) {
        _pollTimer?.cancel();
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

  @override
  Widget build(BuildContext context) {
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
                        Text(
                          _party?.name.toUpperCase() ?? 'PARTY',
                          style: const TextStyle(
                            color: Colors.white,
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
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        border: Border.all(
                          color: const Color(0xFF17C964),
                          width: 2,
                        ),
                      ),
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
                              color: Colors.white70,
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('초대 코드가 복사되었습니다'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: const Icon(Pixel.copy, color: Colors.white54),
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
                            color: Colors.white,
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

                    const SizedBox(height: 16),

                    // 참가자 목록
                    Expanded(
                      child: ListView.builder(
                        itemCount: _party?.members.length ?? 0,
                        itemBuilder: (context, index) {
                          final member = _party!.members[index];
                          final isCurrentUser =
                              member.userId == AuthService.userId;

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
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF141414),
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
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (isCurrentUser) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF17C964),
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
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
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 시작 버튼 (방장만)
                    if (_party?.isCurrentUserLeader == true)
                      SizedBox(
                        width: double.infinity,
                        child: PixelButton(
                          text: _starting ? 'STARTING...' : 'START PLOGGING',
                          onPressed: _starting ? null : _startParty,
                          height: 56,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1F1F),
                          border: Border.all(color: Colors.white24, width: 2),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Pixel.clock, color: Colors.white54, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Waiting for leader to start...',
                              style: TextStyle(
                                color: Colors.white54,
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
