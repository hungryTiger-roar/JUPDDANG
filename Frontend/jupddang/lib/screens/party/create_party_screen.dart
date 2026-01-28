import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixelarticons/pixelarticons.dart';
import '../../services/party_service.dart';
import '../../widgets/pixel_button.dart';
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
      backgroundColor: const Color(0xFF141414),
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
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
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
                  const Text(
                    'CREATE ROOM',
                    style: TextStyle(
                      color: Colors.white,
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
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: '방 이름을 입력하세요',
                    hintStyle: TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Color(0xFF1F1F1F),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  maxLength: 20,
                ),
              ),

              const SizedBox(height: 32),

              // 설명
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Pixel.infobox, color: Colors.white70, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '방 생성 시 초대 코드가 자동으로 생성됩니다',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Pixel.users, color: Colors.white70, size: 16),
                        SizedBox(width: 8),
                        Text(
                          '최대 4명까지 함께 플로깅할 수 있어요',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
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
                child: PixelButton(
                  text: _creating ? 'CREATING...' : 'CREATE ROOM',
                  onPressed: _creating ? null : _createParty,
                  height: 56,
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
