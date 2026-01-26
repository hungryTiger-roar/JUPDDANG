import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/community_models.dart';

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

class _CommunityComposeScreenState extends State<CommunityComposeScreen> {
  final List<String> _categories = [
    '브랜드 세일',
    '공지',
    '모임',
    '자유',
  ];
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  AccountSummary? _selectedAccount;
  String _selectedCategory = '브랜드 세일';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _selectedAccount = widget.initialAccount ??
        (widget.accounts.isNotEmpty ? widget.accounts.first : null);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_images.length >= 5) {
      _showMessage('사진은 최대 5장까지 선택할 수 있어요.');
      return;
    }
    final picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) {
      return;
    }
    final remaining = 5 - _images.length;
    setState(() {
      _images.addAll(picked.take(remaining));
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _submit() {
    if (_submitting) return;
    if (_selectedAccount == null) {
      _showMessage('작성자를 확인해 주세요.');
      return;
    }
    final title = _titleController.text.trim();
    final body = _contentController.text.trim();
    if (title.isEmpty && body.isEmpty) {
      _showMessage('제목 또는 내용을 입력해 주세요.');
      return;
    }
    setState(() {
      _submitting = true;
    });
    final content = _composeContent();
    final draft = CommunityPostDraft(
      userId: _selectedAccount!.userId,
      nickname: _selectedAccount!.nickname,
      content: content,
      localImagePaths: _images.map((image) => image.path).toList(),
    );
    Navigator.pop(context, draft);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _composeContent() {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();
    final body = _contentController.text.trim();
    final buffer = StringBuffer();
    if (_selectedCategory.isNotEmpty) {
      buffer.writeln('[${_selectedCategory}]');
    }
    if (title.isNotEmpty) {
      buffer.writeln(title);
    }
    if (url.isNotEmpty) {
      buffer.writeln(url);
    }
    if (body.isNotEmpty) {
      if (buffer.isNotEmpty) {
        buffer.writeln();
      }
      buffer.write(body);
    }
    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '글쓰기',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              '가이드',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAuthorRow(),
                  const SizedBox(height: 16),
                  _buildLabel('주제'),
                  const SizedBox(height: 8),
                  _buildCategoryField(),
                  const SizedBox(height: 18),
                  _buildLabel('URL'),
                  const SizedBox(height: 8),
                  _buildUrlField(),
                  const SizedBox(height: 18),
                  _buildLabel('제목'),
                  const SizedBox(height: 8),
                  _buildTitleField(),
                  const SizedBox(height: 18),
                  _buildLabel('내용'),
                  const SizedBox(height: 8),
                  _buildContentField(),
                  const SizedBox(height: 18),
                  _buildImageSection(),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE940B6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '쓰기 완료',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorRow() {
    final nickname = _selectedAccount?.nickname ?? 'Guest';
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFE940B6),
          child: Text(
            _initial(nickname),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '작성자',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
            Text(
              nickname,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCategoryField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E6EF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          items: _categories
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _selectedCategory = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildUrlField() {
    return _buildInputContainer(
      TextField(
        controller: _urlController,
        decoration: InputDecoration(
          hintText: 'https://example.com',
          border: InputBorder.none,
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFCFD6E4)),
            ),
            child: const Icon(Icons.link, size: 18, color: Colors.black54),
          ),
        ),
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
        buildCounter: (
          context, {
          required currentLength,
          required isFocused,
          maxLength,
        }) {
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

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLabel('사진'),
            const Spacer(),
            Text(
              '${_images.length}/5',
              style: const TextStyle(color: Colors.black45),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildAddImageTile(),
            for (final entry in _images.asMap().entries)
              _buildImagePreview(entry.key, entry.value),
          ],
        ),
      ],
    );
  }

  Widget _buildAddImageTile() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E6EF)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.camera_alt_outlined, color: Colors.black54),
            SizedBox(height: 4),
            Text('추가', style: TextStyle(fontSize: 12, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(int index, XFile image) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E6EF)),
            image: DecorationImage(
              image: FileImage(File(image.path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: -6,
          top: -6,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E6EF)),
      ),
      child: child,
    );
  }

  String _initial(String value) {
    if (value.isEmpty) {
      return '?';
    }
    return value.substring(0, 1).toUpperCase();
  }
}
