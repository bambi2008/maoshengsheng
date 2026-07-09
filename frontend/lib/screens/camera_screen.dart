import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'result_screen.dart';
import '../main.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  final _picker = ImagePicker();
  final _textController = TextEditingController();
  bool _loading = false;
  File? _previewImage;
  late AnimationController _pulseController;
  late AnimationController _shutterController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _shutterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shutterController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _shutterAnimation(VoidCallback onDone) async {
    await _shutterController.forward();
    await _shutterController.reverse();
    onDone();
  }

  Future<void> _capture(ImageSource source) async {
    final image = await _picker.pickImage(
        source: source, imageQuality: 85, maxWidth: 1920);
    if (image == null || !mounted) return;

    setState(() {
      _previewImage = File(image.path);
      _loading = true;
    });

    _shutterAnimation(() async {
      try {
        final result = await ApiService.analyzeImage(File(image.path));
        if (mounted) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  ResultScreen(result: result, imagePath: image.path),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: const Duration(milliseconds: 350),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('分析失败，请重试'),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    });
  }

  Future<void> _analyzeText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() => _loading = true);
    try {
      final result = await ApiService.analyzeText(text);
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ResultScreen(result: result),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 350),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('分析失败，请重试'),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _loading ? _buildProcessing() : _buildCamera(),
      ),
    );
  }

  Widget _buildProcessing() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Darkened preview
        if (_previewImage != null)
          ColorFiltered(
            colorFilter:
                const ColorFilter.mode(Colors.black38, BlendMode.darken),
            child: Image.file(_previewImage!, fit: BoxFit.cover),
          ),

        // Processing card
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, child) => Transform.scale(
                    scale: 1.0 + _pulseController.value * 0.06,
                    child: child,
                  ),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.blue.withValues(alpha: 0.3), width: 2.5),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: AppColors.blue,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('AI 正在分析...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  '匹配 200 条案例库 · 比对你家猫的症状',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCamera() {
    return Column(
      children: [
        // Viewfinder (takes ~65% vertical space)
        Expanded(
          flex: 5,
          child: GestureDetector(
            onTap: () => _capture(ImageSource.camera),
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                image: _previewImage != null
                    ? DecorationImage(
                        image: FileImage(_previewImage!), fit: BoxFit.cover)
                    : null,
              ),
              child: _previewImage != null
                  ? _buildPreviewOverlay()
                  : _buildViewfinder(),
            ),
          ),
        ),

        // Hint
        if (_previewImage == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '拍照识别猫的皮肤、呕吐物、排泄物、眼睛',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3), fontSize: 12),
            ),
          ),

        // Shutter area
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gallery
              _CircleBtn(
                icon: Icons.photo_library_outlined,
                label: '相册',
                onTap: () => _capture(ImageSource.gallery),
              ),
              const SizedBox(width: 32),

              // Shutter
              GestureDetector(
                onTap: () => _capture(ImageSource.camera),
                child: AnimatedBuilder(
                  animation: _shutterController,
                  builder: (_, child) => Transform.scale(
                    scale: 1.0 - _shutterController.value * 0.06,
                    child: child,
                  ),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white24,
                          blurRadius: 12,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.black12, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),

              // Text input
              _CircleBtn(
                icon: Icons.edit_outlined,
                label: '描述',
                onTap: () => _showTextSheet(),
              ),
            ],
          ),
        ),

        // Quick tags
        _buildTags(),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildViewfinder() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Simulated dark feed
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF16181D),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        // Cat silhouette hint
        Center(
          child: Opacity(
            opacity: 0.06,
            child: Icon(Icons.pets, size: 120, color: Colors.white),
          ),
        ),
        // Corner brackets
        Positioned(
          top: 16, left: 16, child: _CornerBracket.topLeft()),
        Positioned(
          top: 16, right: 16, child: _CornerBracket.topRight()),
        Positioned(
          bottom: 16, left: 16, child: _CornerBracket.bottomLeft()),
        Positioned(
          bottom: 16, right: 16,
          child: _CornerBracket.bottomRight()),
        // Center hint
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt_rounded,
                  size: 36, color: Colors.white.withValues(alpha: 0.15)),
              const SizedBox(height: 8),
              Text(
                '轻触取景框拍照',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.2),
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewOverlay() {
    return Stack(
      children: [
        // Dark overlay on edges
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () => setState(() => _previewImage = null),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.close_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  void _showTextSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('描述症状',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: _textController,
                autofocus: true,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: '例如：猫早上吐了黄色液体，精神正常...',
                  hintStyle: const TextStyle(color: AppColors.textTert),
                  filled: true,
                  fillColor: AppColors.bg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _textController.text.trim().isNotEmpty
                      ? () {
                          Navigator.pop(ctx);
                          _analyzeText();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    disabledBackgroundColor: AppColors.divider,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  child: const Text('分析症状',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTags() {
    final tags = [
      '猫吐了',
      '皮肤脱毛',
      '软便腹泻',
      '眼睛红肿',
      '尿血',
      '不吃东西',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags.map((t) {
          return GestureDetector(
            onTap: () {
              _textController.text = t;
              _analyzeText();
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Text(t,
                  style:
                      const TextStyle(color: AppColors.textSec, fontSize: 12)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================
// Viewfinder corner brackets (like SnapDeduct)
// ============================================================
class _CornerBracket extends StatelessWidget {
  final double _size = 20;
  final double _stroke = 2;
  final BorderRadius _radius;

  const _CornerBracket.topLeft() : _radius = const BorderRadius.only(topLeft: Radius.circular(4));
  const _CornerBracket.topRight() : _radius = const BorderRadius.only(topRight: Radius.circular(4));
  const _CornerBracket.bottomLeft() : _radius = const BorderRadius.only(bottomLeft: Radius.circular(4));
  const _CornerBracket.bottomRight() : _radius = const BorderRadius.only(bottomRight: Radius.circular(4));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        borderRadius: _radius,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: _stroke,
        ),
      ),
    );
  }
}

// ============================================================
// Circle button
// ============================================================
class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CircleBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.card,
              border: Border.all(color: AppColors.divider),
            ),
            child: Icon(icon, color: AppColors.textSec, size: 22),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textTert, fontSize: 10)),
        ],
      ),
    );
  }
}
