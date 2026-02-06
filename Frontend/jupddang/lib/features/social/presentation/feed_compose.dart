import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // consolidateHttpClientResponseBytes를 위해 추가
import 'package:jupddang/features/plogging/data/plogging_service.dart';
import 'package:jupddang/features/social/models/community_models.dart';
import '../../../features/plogging/models/plogging_models.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/pixel_button.dart';
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

class _CommunityComposeScreenState extends State<CommunityComposeScreen> {
  static const Color _navAccent = Color(0xFF17C964);
  static const Color _borderColor = Colors.black;
  static const String _recordPrefix = '기록:'; // content prefix

  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final AuthService _authService = AuthService();
  final PloggingService _ploggingService = PloggingService();

  AccountSummary? _selectedAccount;
  PloggingTempDetailResponse? _selectedRecord;
  XFile? _beforeImage;
  XFile? _afterImage;
  XFile? _mapImage;
  bool _submitting = false;

  List<PloggingTempDetailResponse> _records = [];
  bool _loadingRecords = false;

  @override
  void initState() {
    super.initState();
    _selectedAccount =
        widget.initialAccount ??
            (widget.accounts.isNotEmpty ? widget.accounts.first : null);

    if (widget.initialDraft != null) {
      _loadFromDraft(widget.initialDraft!);
    }

    // 임시 저장 목록 로드
    _loadTempRecords();
  }

  Future<void> _loadTempRecords() async {
    setState(() => _loadingRecords = true);
    try {
      final temps = await _authService.getTempPloggings();
      setState(() {
        _records = temps;
      });
    } catch (e) {
      debugPrint('임시 저장 목록 로드 실패: $e');
      _showMessage('기록을 불러오는 데 실패했습니다');
    } finally {
      setState(() => _loadingRecords = false);
    }
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '0m';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  void _loadFromDraft(CommunityPostDraft draft) {
    if (draft.localImagePaths.isNotEmpty) {
      _beforeImage = XFile(draft.localImagePaths[0]);
      if (draft.localImagePaths.length > 1) {
        _afterImage = XFile(draft.localImagePaths[1]);
      }
    }

    final lines = draft.content.split('\n');
    final bodyBuffer = StringBuffer();

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith(_recordPrefix)) {
        for (var record in _records) {
          if (trimmed.contains(record.recordName)) {
            _selectedRecord = record;
            break;
          }
        }
      } else {
        if (bodyBuffer.isNotEmpty) bodyBuffer.writeln();
        bodyBuffer.write(trimmed);
      }
    }

    _contentController.text = bodyBuffer.toString().trim();
  }

  @override
  void dispose() {
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

  // void _openRecordPicker() {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //     ),
  //     builder: (context) {
  //       return SafeArea(
  //         child: _loadingRecords
  //             ? const Center(
  //           child: CircularProgressIndicator(color: _navAccent),
  //         )
  //             : _records.isEmpty
  //             ? const Center(
  //           child: Padding(
  //             padding: EdgeInsets.all(32.0),
  //             child: Text(
  //               '불러올 수 있는 기록이 없습니다',
  //               style: TextStyle(color: Colors.black54),
  //             ),
  //           ),
  //         )
  //             : ListView.separated(
  //           padding: const EdgeInsets.symmetric(vertical: 16),
  //           itemCount: _records.length,
  //           separatorBuilder: (_, __) =>
  //           const Divider(height: 1, color: Colors.blueGrey),
  //           itemBuilder: (context, index) {
  //             final record = _records[index];
  //             final selected =
  //                 _selectedRecord?.ploggingId == record.ploggingId;
  //             return ListTile(
  //               title: Text(
  //                 record.recordName,
  //                 style: const TextStyle(color: Colors.black),
  //               ),
  //               subtitle: Text(
  //                 '${_formatDate(record.createdAt)} · ${(record.distance ?? 0).toStringAsFixed(2)}km · ${_formatDuration(record.times)}',
  //                 style: const TextStyle(color: Colors.black54),
  //               ),
  //               trailing: selected
  //                   ? const Icon(Icons.check_circle,
  //                   color: _navAccent)
  //                   : const Icon(
  //                 Icons.circle_outlined,
  //                 color: Colors.black26,
  //               ),
  //               onTap: () {
  //                 setState(() {
  //                   _selectedRecord = record;
  //                 });
  //                 Navigator.pop(context);
  //               },
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> _pickMapImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _mapImage = picked;
    });
  }

  void _removeMapImage() {
    setState(() {
      _mapImage = null;
    });
  }

  Widget _buildMapPhotoSection() {
    return GestureDetector(
      onTap: _pickMapImage,
      child: AspectRatio(
        aspectRatio: 16 / 9,  // 가로로 긴 비율
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
            image: _mapImage == null
                ? null
                : DecorationImage(
              image: FileImage(File(_mapImage!.path)),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              if (_mapImage == null)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Pixel.map, color: Colors.black54, size: 32),
                      const SizedBox(height: 8),
                      const Text(
                        'Map Photo',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (_mapImage != null)
                Positioned(
                  right: 8,
                  top: 8,
                  child: GestureDetector(
                    onTap: _removeMapImage,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Pixel.close,
                        color: Colors.white,
                        size: 16,
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

  void _openRecordPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: _loadingRecords
              ? const Center(
            child: CircularProgressIndicator(color: _navAccent),
          )
              : _records.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                '불러올 수 있는 기록이 없습니다',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: _records.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Colors.blueGrey),
            itemBuilder: (context, index) {
              final record = _records[index];
              final selected =
                  _selectedRecord?.ploggingId == record.ploggingId;
              return ListTile(
                title: Text(
                  record.recordName,
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  '${_formatDate(record.createdAt)} \u00B7 ${(record.distance ?? 0).toStringAsFixed(2)}km \u00B7 ${_formatDuration(record.times)} \u00B7 ${record.score ?? 0}\uC810',
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: selected
                    ? const Icon(Icons.check_circle, color: _navAccent)
                    : const Icon(
                  Icons.circle_outlined,
                  color: Colors.black26,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _loadRecordDetail(record.ploggingId);
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _loadRecordDetail(int ploggingId) async {
    // 로딩 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: _navAccent),
      ),
    );

    // 새 기록 선택 시 기존 이미지 초기화
    setState(() {
      _beforeImage = null;
      _afterImage = null;
      _mapImage = null;
    });

    try {
      final detail = await _ploggingService.getTempPloggingDetail(ploggingId);

      if (!mounted) return;

      // 로딩 다이얼로그 닫기
      Navigator.pop(context);

      setState(() {
        _selectedRecord = detail;

        // 내용 채우기
        if (detail.content != null && detail.content!.isNotEmpty) {
          _contentController.text = _stripRecordLine(detail.content!);
        }
      });

      // 이미지 다운로드 및 설정
      await _loadRecordImages(detail);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // 로딩 다이얼로그 닫기
      debugPrint('기록 상세 조회 실패: $e');
      _showMessage('기록을 불러오는 데 실패했습니다');
    }
  }

  Future<void> _loadRecordImages(PloggingTempDetailResponse detail) async {
    try {
      // Before Image 로드
      if (detail.beforeImageUrl != null && detail.beforeImageUrl!.isNotEmpty) {
        final beforeFile = await _downloadImageFromUrl(detail.beforeImageUrl!);
        if (beforeFile != null) {
          setState(() {
            _beforeImage = XFile(beforeFile.path);
          });
        }
      }

      // After Image 로드
      if (detail.afterImageUrl != null && detail.afterImageUrl!.isNotEmpty) {
        final afterFile = await _downloadImageFromUrl(detail.afterImageUrl!);
        if (afterFile != null) {
          setState(() {
            _afterImage = XFile(afterFile.path);
          });
        }
      }

      // Map Image 로드
      if (detail.mapImageUrl != null && detail.mapImageUrl!.isNotEmpty) {
        final mapFile = await _downloadImageFromUrl(detail.mapImageUrl!);
        if (mapFile != null) {
          setState(() {
            _mapImage = XFile(mapFile.path);
          });
        }
      }
    } catch (e) {
      debugPrint('이미지 로드 실패: $e');
    }
  }

  Future<File?> _downloadImageFromUrl(String url) async {
    try {
      final http = HttpClient();
      final request = await http.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        final tempDir = Directory.systemTemp;
        final fileName = url.split('/').last;
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(bytes);
        return file;
      }
    } catch (e) {
      debugPrint('이미지 다운로드 실패: $e');
    }
    return null;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _stripRecordLine(String content) {
    final lines = content.split('\n');
    final filtered =
        lines.where((line) => !line.trim().startsWith(_recordPrefix)).toList();
    return filtered.join('\n').trim();
  }

  String _composeContent() {
    return _contentController.text.trim();
  }

  String _composeContentForSubmit() {
    final body = _contentController.text.trim();
    final record = _selectedRecord;
    if (record == null) {
      return body;
    }

    final buffer = StringBuffer();
    if (body.isNotEmpty) {
      buffer.write(body);
      buffer.writeln();
      buffer.writeln();
    }
    buffer.write(
      '\uAE30\uB85D: ${record.recordName} \u00B7 ${_formatDate(record.createdAt)} \u00B7 ${(record.distance ?? 0).toStringAsFixed(2)}km \u00B7 ${_formatDuration(record.times)}',
    );
    if (record.score != null) {
      buffer.write(' \u00B7 ${record.score}\uC810');
    }
    return buffer.toString().trim();
  }

  Future<void> _submit() async {
    if (_submitting) return;

    final content = _composeContentForSubmit();
    final hasImages =
        _beforeImage != null || _afterImage != null || _mapImage != null;

    if (content.isEmpty && !hasImages) {
      _showMessage('Please write something or add an image.');
      return;
    }

    setState(() => _submitting = true);

    try {
      final account =
          _selectedAccount ??
          (widget.accounts.isNotEmpty ? widget.accounts.first : null);

      if (account == null) {
        _showMessage('No account found.');
        return;
      }

      final imagePaths = <String>[];
      if (_beforeImage != null) {
        imagePaths.add(_beforeImage!.path);
      }
      if (_afterImage != null) {
        imagePaths.add(_afterImage!.path);
      }
      if (_mapImage != null) {
        imagePaths.add(_mapImage!.path);
      }

      final draft = CommunityPostDraft(
        userId: account.userId,
        nickname: account.nickname,
        content: content,
        localImagePaths: imagePaths,
        ploggingId: _selectedRecord?.ploggingId,
      );

      if (!mounted) return;
      Navigator.pop(context, draft);
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('NEW POST'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
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
                  _buildLabel('내용'),
                  const SizedBox(height: 8),
                  _buildContentField(),
                  const SizedBox(height: 18),
                  _buildLabel('Map Photo'),
                  const SizedBox(height: 10),
                  _buildMapPhotoSection(),
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
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 16,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildContentField() {
    return _buildInputContainer(
      TextField(
        controller: _contentController,
        maxLines: 6,
        maxLength: 1000,
        cursorColor: const Color(0xFF17C964),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'NeoDunggeunmo',
        ),
        decoration: const InputDecoration(
          hintText: '내용을 입력하세요',
          hintStyle: TextStyle(color: Colors.black38),
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
              style: const TextStyle(color: Colors.black38, fontSize: 12),
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
              onPressed: _loadingRecords ? null : _openRecordPicker,
              child: _loadingRecords
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _navAccent,
                ),
              )
                  : const Text(
                '기록 선택',
                style: TextStyle(color: _navAccent),
              ),
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
                  child: const Icon(Pixel.arrowright, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedRecord!.recordName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatDate(_selectedRecord!.createdAt)} \u00B7 ${(_selectedRecord!.distance ?? 0).toStringAsFixed(2)}km \u00B7 ${_formatDuration(_selectedRecord!.times)} \u00B7 ${_selectedRecord!.score ?? 0}\uC810',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedRecord = null;
                      _beforeImage = null;
                      _afterImage = null;
                      _mapImage = null;
                      _contentController.clear();
                    });
                  },
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
              '플로깅 기록을 선택하면 게시글과 함께 올라갑니다.',
              style: TextStyle(color: Colors.black38),
            ),
          ),
      ],
    );
  }

  Widget _buildInputContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
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
      child: child,
    );
  }

}
