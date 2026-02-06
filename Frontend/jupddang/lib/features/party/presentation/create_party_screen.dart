import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../data/party_service.dart';
import 'party_room_screen.dart';

class CreatePartyScreen extends StatefulWidget {
  const CreatePartyScreen({super.key});

  @override
  State<CreatePartyScreen> createState() => _CreatePartyScreenState();
}

class _CreatePartyScreenState extends State<CreatePartyScreen> {
  final PartyService _partyService = PartyService();
  final _nameController = TextEditingController();

  bool _creating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createParty() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('방 이름을 입력해주세요')));
      return;
    }

    setState(() => _creating = true);
    try {
      final party = await _partyService.createParty(
        name: _nameController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PartyRoomScreen(partyId: party.partyId),
          ),
        );
      }
    } catch (e) {
      setState(() => _creating = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('방 생성 실패: $e')));
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
                    'CREATE ROOM',
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

              // 방 이름 입력
              const Text(
                'ROOM NAME',
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
                  controller: _nameController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NeoDunggeunmo',
                  ),
                  decoration: const InputDecoration(
                    hintText: '방 이름을 입력하세요',
                    hintStyle: TextStyle(color: Colors.black38),
                    filled: true,
                    fillColor: Color(0xFFF0F0F0),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  maxLength: 20,
                ),
              ),

              const SizedBox(height: 32),

              // 설명
              // 설명
              NesContainer(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Pixel.infobox, color: Colors.black54, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '방 생성 시 초대 코드가 자동으로 생성됩니다',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Pixel.users, color: Colors.black54, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '최대 6명까지 함께 플로깅할 수 있어요',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 생성 버튼
              SizedBox(
                width: double.infinity,
                child: NesButton(
                  type: NesButtonType.success,
                  onPressed: _creating ? null : _createParty,
                  child: Text(
                    _creating ? 'CREATING...' : 'CREATE ROOM',
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
