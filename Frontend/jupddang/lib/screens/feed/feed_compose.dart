import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/community_models.dart';
import '../../widgets/pixel_button.dart';
import 'package:pixelarticons/pixelarticons.dart';

class CommunityComposeScreen extends StatefulWidget {
  final List<AccountSummary> accounts;
  final AccountSummary? initialAccount;
  final CommunityPostDraft? initialDraft;

  const CommunityComposeScreen({
    super.key,
    required this.accounts,
    this.initialAccount,
    this.initialDraft,
  });

  @override
  State<CommunityComposeScreen> createState() => _CommunityComposeScreenState();
}

class _PloggingRecord {
  final String id;
  final String title;
  final String date;
  final String distance;
  final String duration;
  final int score;

  const _PloggingRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.distance,
    required this.duration,
    required this.score
  });
}

class _CommunityComposeScreenState extends State<CommunityComposeScreen> {
  static const Color _navAccent = Color(0xFF17C964);
  static const Color _borderColor = Colors.black;

  final TextEditingController _hashtagController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  AccountSummary? _selectedAccount;
  _PloggingRecord? _selectedRecord;
  XFile? _beforeImage;
  XFile? _afterImage;
  bool _submitting = false;

  final List<_PloggingRecord> _records = const [
    _PloggingRecord(
      id: '1',
      title: '한강 플로깅',
      date: '2024-11-02',
      distance: '3.2km',
      duration: '32분',
      score: 55
    ),
    _PloggingRecord(
      id: '2',
      title: '캠퍼스 러닝',
      date: '2024-10-29',
      distance: '2.1km',
      duration: '24분',
      score: 20
    ),
    _PloggingRecord(
      id: '3',
      title: '동네 산책 플로깅',
      date: '2024-10-24',
      distance: '1.4km',
      duration: '18분',
      score: 30
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedAccount =
        widget.initialAccount ??
        (widget.accounts.isNotEmpty ? widget.accounts.first : null);

    // 이어쓰기 데이터가 있으면 불러오기 실행
    if (widget.initialDraft != null) {
      _loadFromDraft(widget.initialDraft!);
    }
  }

  // Draft 데이터를 화면 컨트롤러에 채워넣는 로직
  void _loadFromDraft(CommunityPostDraft draft) {
    // 1. 이미지 복구
    if (draft.localImagePaths.isNotEmpty) {
      _beforeImage = XFile(draft.localImagePaths[0]);
      if (draft.localImagePaths.length > 1) {
        _afterImage = XFile(draft.localImagePaths[1]);
      }
    }

    // 2. 텍스트 파싱 (해시태그, 본문, 기록 분리)
    final lines = draft.content.split('\n');
    final bodyBuffer = StringBuffer();
    final hashtagBuffer = StringBuffer();

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('#')) {
        hashtagBuffer.write('$trimmed ');
      } else if (trimmed.startsWith('기록:')) {
        // 기록 데이터 매칭 (제목과 날짜로 찾기)
        for (var record in _records) {
          if (trimmed.contains(record.title) && trimmed.contains(record.date)) {
            _selectedRecord = record;
            break;
          }
        }
      } else {
        if (bodyBuffer.isNotEmpty) bodyBuffer.writeln();
        bodyBuffer.write(trimmed);
      }
    }

    _hashtagController.text = hashtagBuffer.toString().trim();
    _contentController.text = bodyBuffer.toString().trim();
  }

  @override
  void dispose() {
    _hashtagController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool isBefore}) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      if (isBefore) {
        _beforeImage = picked;
      } else {
        _afterImage = picked;
      }
    });
  }

  void _removeImage({required bool isBefore}) {
    setState(() {
      if (isBefore) {
        _beforeImage = null;
      } else {
        _afterImage = null;
      }
    });
  }

  void _openRecordPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: _records.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white24),
            itemBuilder: (context, index) {
              final record = _records[index];
              final selected = _selectedRecord?.id == record.id;
              return ListTile(
                title: Text(record.title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  '${record.date} · ${record.distance} · ${record.duration}  · ${record.score}',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: selected
                    ? const Icon(Icons.check_circle, color: _navAccent)
                    : const Icon(Icons.circle_outlined, color: Colors.white24),
                onTap: () {
                  setState(() {
                    _selectedRecord = record;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _submit() {
    if (_submitting) return;
    if (_selectedAccount == null) {
      _showMessage('작성자를 확인해 주세요.');
      return;
    }
    final body = _contentController.text.trim();
    if (body.isEmpty) {
      _showMessage('내용을 입력해 주세요.');
      return;
    }
    setState(() {
      _submitting = true;
    });
    final content = _composeContent();
    final imagePaths = <String>[];
    if (_beforeImage != null) {
      imagePaths.add(_beforeImage!.path);
    }
    if (_afterImage != null) {
      imagePaths.add(_afterImage!.path);
    }
    final draft = CommunityPostDraft(
      userId: _selectedAccount!.userId,
      nickname: _selectedAccount!.nickname,
      content: content,
      localImagePaths: imagePaths,
    );
    Navigator.pop(context, draft);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _composeContent() {
    final hashtags = _normalizeHashtags(_hashtagController.text);
    final body = _contentController.text.trim();
    final record = _selectedRecord;
    final buffer = StringBuffer();

    if (hashtags.isNotEmpty) {
      buffer.writeln(hashtags);
    }
    if (body.isNotEmpty) {
      if (buffer.isNotEmpty) {
        buffer.writeln();
      }
      buffer.write(body);
    }
    if (record != null) {
      buffer.writeln();
      buffer.writeln();
      buffer.write(
        '기록: ${record.title} · ${record.date} · ${record.distance} · ${record.duration}',
      );
    }
    return buffer.toString().trim();
  }

  String _normalizeHashtags(String raw) {
    final items = raw
        .replaceAll(',', ' ')
        .split(' ')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .map((tag) => tag.startsWith('#') ? tag : '#$tag')
        .toList();
    return items.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text('NEW POST'),
        backgroundColor: Colors.transparent, // ★ 투명 배경
        foregroundColor: Colors.white,       // ★ 흰색 글씨/아이콘
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildLabel('해시태그'),
                  const SizedBox(height: 8),
                  _buildHashtagField(),
                  const SizedBox(height: 18),
                  _buildLabel('내용'),
                  const SizedBox(height: 8),
                  _buildContentField(),
                  const SizedBox(height: 18),
                  _buildLabel('Before · After'),
                  const SizedBox(height: 10),
                  _buildBeforeAfterGrid(),
                  const SizedBox(height: 18),
                  _buildRecordSection(),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: PixelButton(
                text: 'PUBLISH',
                onPressed: _submitting ? null : _submit,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        fontSize: 14,

        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildHashtagField() {
    return _buildInputContainer(
      TextField(
        controller: _hashtagController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: '#플로깅 #환경',
          hintStyle: TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return _buildInputContainer(
      TextField(
        controller: _contentController,
        maxLines: 6,
        maxLength: 1000,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: '내용을 입력하세요',
          hintStyle: TextStyle(color: Colors.white38),
          border: InputBorder.none,
          counterText: '',
        ),
        buildCounter:
            (context, {required currentLength, required isFocused, maxLength}) {
              final limit = maxLength ?? 1000;
              return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$currentLength / 최대 $limit자',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              );
            },
      ),
    );
  }

  Widget _buildBeforeAfterGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildImageTile(
            label: 'Before',
            image: _beforeImage,
            onTap: () => _pickImage(isBefore: true),
            onRemove: () => _removeImage(isBefore: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildImageTile(
            label: 'After',
            image: _afterImage,
            onTap: () => _pickImage(isBefore: false),
            onRemove: () => _removeImage(isBefore: false),
          ),
        ),
      ],
    );
  }

  Widget _buildImageTile({
    required String label,
    required XFile? image,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            border: Border.all(color: _borderColor, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: const Offset(4, 4),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
            image: image == null
                ? null
                : DecorationImage(
                    image: FileImage(File(image.path)),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Stack(
            children: [
              if (image == null)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Pixel.camera, color: Colors.white54),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              if (image != null)
                Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Pixel.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLabel('기록 불러오기'),
            const Spacer(),
            TextButton(
              onPressed: _openRecordPicker,
              child: const Text('기록 선택', style: TextStyle(color: _navAccent)),
            ),
          ],
        ),
        if (_selectedRecord != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              border: Border.all(color: _borderColor, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: const Offset(4, 4),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _navAccent.withOpacity(0.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(4, 4),
                        blurRadius: 0,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const Icon(Pixel.arrowright, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedRecord!.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_selectedRecord!.date} · ${_selectedRecord!.distance} · ${_selectedRecord!.duration} · ${_selectedRecord!.score}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedRecord = null),
                  icon: const Icon(Pixel.close, color: Colors.white54),
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              border: Border.all(color: _borderColor, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: const Offset(4, 4),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: const Text(
              '플로깅 기록을 선택하면 게시글에 함께 올라갑니다.',
              style: TextStyle(color: Colors.white38),
            ),
          ),
      ],
    );
  }

  Widget _buildInputContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        border: Border.all(color: _borderColor, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: const Offset(4, 4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
