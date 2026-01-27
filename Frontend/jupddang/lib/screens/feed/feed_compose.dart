import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/community_models.dart';
import '../../widgets/pixel_button.dart';
import 'package:pixelarticons/pixelarticons.dart';

class CommunityComposeScreen extends StatefulWidget {
  final List<AccountSummary> accounts;
  final AccountSummary? initialAccount;

  const CommunityComposeScreen({
    super.key,
    required this.accounts,
    this.initialAccount,
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

  const _PloggingRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.distance,
    required this.duration,
  });
}

class _CommunityComposeScreenState extends State<CommunityComposeScreen> {
  static const Color _navAccent = Color(0xFF17C964);
  static const Color _borderColor = Colors.black;

  final TextEditingController _titleController = TextEditingController();
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
    ),
    _PloggingRecord(
      id: '2',
      title: '캠퍼스 러닝',
      date: '2024-10-29',
      distance: '2.1km',
      duration: '24분',
    ),
    _PloggingRecord(
      id: '3',
      title: '동네 산책 플로깅',
      date: '2024-10-24',
      distance: '1.4km',
      duration: '18분',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedAccount =
        widget.initialAccount ??
        (widget.accounts.isNotEmpty ? widget.accounts.first : null);
  }

  @override
  void dispose() {
    _titleController.dispose();
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: _records.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final record = _records[index];
              final selected = _selectedRecord?.id == record.id;
              return ListTile(
                title: Text(record.title),
                subtitle: Text(
                  '${record.date} · ${record.distance} · ${record.duration}',
                ),
                trailing: selected
                    ? const Icon(Icons.check_circle, color: _navAccent)
                    : const Icon(Icons.circle_outlined),
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
    final title = _titleController.text.trim();
    final body = _contentController.text.trim();
    if (title.isEmpty || body.isEmpty) {
      _showMessage('제목과 내용을 입력해 주세요.');
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
    final title = _titleController.text.trim();
    final hashtags = _normalizeHashtags(_hashtagController.text);
    final body = _contentController.text.trim();
    final record = _selectedRecord;
    final buffer = StringBuffer();

    if (title.isNotEmpty) {
      buffer.writeln(title);
    }
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('NEW POST'),
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
                  _buildLabel('제목'),
                  const SizedBox(height: 8),
                  _buildTitleField(),
                  const SizedBox(height: 18),
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

  Widget _buildTitleField() {
    return _buildInputContainer(
      TextField(
        controller: _titleController,
        decoration: const InputDecoration(
          hintText: '제목을 입력하세요',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildHashtagField() {
    return _buildInputContainer(
      TextField(
        controller: _hashtagController,
        decoration: const InputDecoration(
          hintText: '#플로깅 #환경',
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
        decoration: const InputDecoration(
          hintText: '내용을 입력하세요',
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
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
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
            color: Colors.white,
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
                      const Icon(Pixel.camera, color: Colors.black54),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: const TextStyle(color: Colors.black54),
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
              child: const Text('기록 선택'),
            ),
          ],
        ),
        if (_selectedRecord != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
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
                  child: const Icon(Pixel.arrowright, color: Colors.black87),
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
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_selectedRecord!.date} · ${_selectedRecord!.distance} · ${_selectedRecord!.duration}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedRecord = null),
                  icon: const Icon(Pixel.close, color: Colors.black54),
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
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
              style: TextStyle(color: Colors.black45),
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
