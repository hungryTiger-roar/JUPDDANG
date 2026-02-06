import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../data/party_service.dart';
import 'party_room_screen.dart';

class JoinPartyScreen extends StatefulWidget {
  const JoinPartyScreen({super.key});

  @override
  State<JoinPartyScreen> createState() => _JoinPartyScreenState();
}

class _JoinPartyScreenState extends State<JoinPartyScreen> {
  final PartyService _partyService = PartyService();
  final _codeController = TextEditingController();

  bool _joining = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinParty() async {
    final code = _codeController.text.trim().toUpperCase();

    if (code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('초대 코드를 입력해주세요')));
      return;
    }

    if (code.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('초대 코드는 6자리입니다')));
      return;
    }

    setState(() => _joining = true);
    try {
      final party = await _partyService.joinParty(code);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PartyRoomScreen(partyId: party.partyId),
          ),
        );
      }
    } catch (e) {
      setState(() => _joining = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('참가 실패: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  const Text(
                    'JOIN ROOM',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 40),

              // 초대 코드 입력
              const Text(
                'INVITE CODE',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              NesContainer(
                padding: EdgeInsets.zero,
                child: TextFormField(
                  controller: _codeController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8.0,
                    fontFamily: 'NeoDunggeunmo',
                  ),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: '000000',
                    hintStyle: TextStyle(color: Colors.black26),
                    filled: true,
                    fillColor: Color(0xFFF0F0F0),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                  maxLength: 6,
                  onChanged: (value) {
                    // 자동 대문자 변환
                    _codeController.value = _codeController.value.copyWith(
                      text: value.toUpperCase(),
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 안내 메시지
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Enter Invite Code',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '친구에게 받은 6자리 코드를 입력하세요',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 참가 버튼
              SizedBox(
                width: double.infinity,
                child: NesButton(
                  type: NesButtonType.success,
                  onPressed: _joining ? null : _joinParty,
                  child: Text(
                    _joining ? 'JOINING...' : 'JOIN ROOM',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
