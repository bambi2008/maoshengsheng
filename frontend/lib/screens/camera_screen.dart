import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final _textController = TextEditingController();
  final _picker = ImagePicker();
  bool _loading = false;
  File? _selectedImage;

  Future<void> _takePhoto() async {
    final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
      _analyze();
    }
  }

  Future<void> _pickFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
      _analyze();
    }
  }

  Future<void> _analyze() async {
    setState(() => _loading = true);
    try {
      final result = _selectedImage != null
          ? await ApiService.analyzeImage(_selectedImage!)
          : await ApiService.analyzeText(_textController.text.trim());
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              result: result,
              imagePath: _selectedImage?.path,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('分析失败: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  void _textAnalyze() {
    if (_textController.text.trim().isNotEmpty) {
      _analyze();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('猫省省', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF3B82F6)),
                    SizedBox(height: 16),
                    Text('正在分析...', style: TextStyle(color: Color(0xFF8890A4))),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Camera area
                    Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: const Color(0xFF161822),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF232636)),
                        image: _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_rounded,
                                    size: 64, color: Colors.white.withOpacity(0.3)),
                                const SizedBox(height: 12),
                                const Text('拍照或选择图片',
                                    style: TextStyle(color: Color(0xFF8890A4), fontSize: 16)),
                                const SizedBox(height: 4),
                                const Text('猫癣 · 呕吐物 · 排泄物 · 皮肤问题',
                                    style: TextStyle(color: Color(0xFF8890A4), fontSize: 12)),
                              ],
                            )
                          : Stack(
                              children: [
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedImage = null),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child:
                                          const Icon(Icons.close, color: Colors.white, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Photo buttons
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.camera_alt_rounded,
                            label: '拍照',
                            onTap: _takePhoto,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.photo_library_rounded,
                            label: '相册',
                            onTap: _pickFromGallery,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Text input
                    const Text('或者描述症状',
                        style: TextStyle(color: Color(0xFF8890A4), fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _textController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '例如：猫早上吐了黄色液体，精神正常...',
                        hintStyle: const TextStyle(color: Color(0xFF555A68)),
                        filled: true,
                        fillColor: const Color(0xFF161822),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF232636)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF232636)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _textController.text.trim().isNotEmpty ? _textAnalyze : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('分析症状',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF161822),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF232636)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF3B82F6), size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Color(0xFF8890A4), fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
