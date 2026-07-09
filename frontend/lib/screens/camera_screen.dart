import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();
  final _textController = TextEditingController();
  bool _loading = false;
  bool _showTextInput = false;
  File? _previewImage;
  late AnimationController _sparkle;

  @override
  void initState() {
    super.initState();
    _sparkle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _sparkle.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _capture(ImageSource source) async {
    final image = await _picker.pickImage(
        source: source, imageQuality: 85, maxWidth: 1920);
    if (image != null && mounted) {
      setState(() {
        _previewImage = File(image.path);
        _loading = true;
      });
      try {
        final result = await ApiService.analyzeImage(File(image.path));
        _navigateToResult(result, image.path);
      } catch (e) {
        _showError();
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  Future<void> _analyzeText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() => _loading = true);
    try {
      final result = await ApiService.analyzeText(text);
      _navigateToResult(result, null);
    } catch (e) {
      _showError();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _navigateToResult(result, String? path) {
    if (!mounted) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ResultScreen(result: result, imagePath: path),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
                parent: animation, curve: const Cubic(0.32, 0.72, 0, 1))),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _showError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('分析失败，请重试'),
        backgroundColor: AppTheme.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: _loading ? _buildLoading() : _buildContent(),
      ),
    );
  }

  // ============================================================
  // Loading state
  // ============================================================
  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _sparkle,
            builder: (_, __) => Transform.rotate(
              angle: _sparkle.value * 6.28,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      AppTheme.blue.withValues(alpha: 0.0),
                      AppTheme.blue,
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.bg,
                    ),
                    child: const Icon(Icons.auto_awesome_rounded,
                        color: AppTheme.blue, size: 24),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.space5),
          Text('AI 正在分析…', style: AppTheme.headline),
          const SizedBox(height: AppTheme.space1),
          Text(
            _previewImage != null ? '识别图像并匹配 200 条案例库' : '在案例库中查找相似症状',
            style: AppTheme.footnote,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Main content
  // ============================================================
  Widget _buildContent() {
    return Column(
      children: [
        // Nav title
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppTheme.space4, AppTheme.space3, AppTheme.space4, AppTheme.space2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🐱', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text('猫省省', style: AppTheme.headline),
            ],
          ),
        ),

        // Viewfinder
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.space4),
            child: _buildViewfinder(),
          ),
        ),

        // Shutter row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.space4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CircleButton(
                icon: Icons.photo_library_rounded,
                label: '相册',
                onTap: () => _capture(ImageSource.gallery),
              ),
              const SizedBox(width: AppTheme.space8),
              _ShutterButton(onTap: () => _capture(ImageSource.camera)),
              const SizedBox(width: AppTheme.space8),
              _CircleButton(
                icon: Icons.edit_note_rounded,
                label: '描述',
                onTap: () => setState(() => _showTextInput = !_showTextInput),
              ),
            ],
          ),
        ),

        // Text input OR quick tags
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: _showTextInput ? _buildTextInput() : _buildQuickTags(),
        ),

        const SizedBox(height: AppTheme.space4),
      ],
    );
  }

  Widget _buildViewfinder() {
    return GestureDetector(
      onTap: _previewImage == null ? () => _capture(ImageSource.camera) : null,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Container(
          decoration: BoxDecoration(
            color: _previewImage != null ? Colors.black : AppTheme.text,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            image: _previewImage != null
                ? DecorationImage(
                    image: FileImage(_previewImage!), fit: BoxFit.cover)
                : null,
          ),
          child: Stack(
            children: [
              // Corner brackets
              const _CornerBrackets(),
              // Content
              if (_previewImage == null)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        child: Icon(Icons.pets_rounded,
                            size: 32, color: Colors.white.withValues(alpha: 0.5)),
                      ),
                      const SizedBox(height: AppTheme.space4),
                      Text('拍照识别猫的症状',
                          style: AppTheme.callout
                              .copyWith(color: Colors.white)),
                      const SizedBox(height: AppTheme.space1),
                      Text(
                        '猫癣 · 呕吐物 · 排泄物 · 皮肤 · 眼部',
                        style: AppTheme.footnote.copyWith(
                            color: Colors.white.withValues(alpha: 0.5)),
                      ),
                    ],
                  ),
                ),
              // Clear button
              if (_previewImage != null)
                Positioned(
                  top: AppTheme.space3,
                  right: AppTheme.space3,
                  child: GestureDetector(
                    onTap: () => setState(() => _previewImage = null),
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.space2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      key: const ValueKey('input'),
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.space4),
      padding: const EdgeInsets.all(AppTheme.space3),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          TextField(
            controller: _textController,
            maxLines: 2,
            autofocus: true,
            style: AppTheme.body,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: '描述猫的症状，例如：猫吐了黄色液体，精神正常',
              hintStyle: TextStyle(color: AppTheme.textTert, fontSize: 15),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
          ),
          const SizedBox(height: AppTheme.space2),
          _PrimaryButton(
            label: '分析症状',
            enabled: _textController.text.trim().isNotEmpty,
            onTap: _analyzeText,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTags() {
    final tags = ['猫吐了', '皮肤脱毛', '软便腹泻', '眼睛红肿', '尿血尿闭', '不吃东西'];
    return Container(
      key: const ValueKey('tags'),
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space4),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppTheme.space2,
        runSpacing: AppTheme.space2,
        children: tags.map((t) {
          return GestureDetector(
            onTap: () {
              _textController.text = t;
              setState(() => _showTextInput = true);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.space3, vertical: AppTheme.space2),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Text(t, style: AppTheme.subhead),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================
// Corner brackets (viewfinder frame)
// ============================================================
class _CornerBrackets extends StatelessWidget {
  const _CornerBrackets();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.space3),
      child: Stack(
        children: [
          Align(alignment: Alignment.topLeft, child: _corner(true, true)),
          Align(alignment: Alignment.topRight, child: _corner(true, false)),
          Align(alignment: Alignment.bottomLeft, child: _corner(false, true)),
          Align(alignment: Alignment.bottomRight, child: _corner(false, false)),
        ],
      ),
    );
  }

  Widget _corner(bool top, bool left) {
    const c = Color(0x99FFFFFF);
    const w = 2.0;
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _CornerPainter(top: top, left: left, color: c, stroke: w)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool top, left;
  final Color color;
  final double stroke;
  _CornerPainter(
      {required this.top,
      required this.left,
      required this.color,
      required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final h = left ? 0.0 : size.width;
    final v = top ? 0.0 : size.height;
    // horizontal
    canvas.drawLine(Offset(h, v), Offset(left ? size.width : 0, v), paint);
    // vertical
    canvas.drawLine(Offset(h, v), Offset(h, top ? size.height : 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// Shutter button
// ============================================================
class _ShutterButton extends StatefulWidget {
  final VoidCallback onTap;
  const _ShutterButton({required this.onTap});

  @override
  State<_ShutterButton> createState() => _ShutterButtonState();
}

class _ShutterButtonState extends State<_ShutterButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.blue,
            border: Border.all(
                color: AppTheme.blue.withValues(alpha: 0.2), width: 5),
            boxShadow: [
              BoxShadow(
                color: AppTheme.blue.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.camera_alt_rounded,
              color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

// ============================================================
// Circle button (gallery / describe)
// ============================================================
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _CircleButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.bgCard,
              boxShadow: AppTheme.cardShadow,
            ),
            child: Icon(icon, color: AppTheme.blue, size: 22),
          ),
          const SizedBox(height: AppTheme.space1),
          Text(label, style: AppTheme.caption1),
        ],
      ),
    );
  }
}

// ============================================================
// Primary button
// ============================================================
class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _PrimaryButton(
      {required this.label, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Material(
        color: enabled ? AppTheme.blue : AppTheme.blue.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Center(
            child: Text(label,
                style: AppTheme.headline.copyWith(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
