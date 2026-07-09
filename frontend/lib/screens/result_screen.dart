import 'dart:io';
import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../main.dart';

class ResultScreen extends StatefulWidget {
  final AnalysisResult result;
  final String? imagePath;

  const ResultScreen({super.key, required this.result, this.imagePath});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  _RiskConfig get _rc => _riskConfig(widget.result.riskLevel);

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              children: [
                // Header
                _buildHeader(r),
                // Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.imagePath != null) _buildImage(),
                        if (r.summary.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildSummary(r),
                        ],
                        if (r.possibleCauses.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildCard(
                            icon: Icons.search_rounded,
                            title: '可能原因',
                            child: _buildCauses(r),
                          ),
                        ],
                        if (r.homeCare.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildCard(
                            icon: Icons.home_rounded,
                            title: '居家处理',
                            child: Text(r.homeCare,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14, height: 1.7)),
                          ),
                        ],
                        if (r.whenToSeeVet.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildCard(
                            icon: Icons.local_hospital_rounded,
                            title: '什么情况必须就医',
                            danger: true,
                            child: Text(r.whenToSeeVet,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14, height: 1.7)),
                          ),
                        ],
                        if (r.matchedCases.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildCard(
                            icon: Icons.people_rounded,
                            title: '相似案例 (${r.similarCasesCount}个)',
                            child: _buildCases(r),
                          ),
                        ],
                        const SizedBox(height: 16),
                        // Disclaimer
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppColors.textTert, size: 14),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  r.disclaimer,
                                  style: const TextStyle(
                                      color: AppColors.textTert,
                                      fontSize: 11,
                                      height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AnalysisResult r) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 12),
      decoration: BoxDecoration(
        color: _rc.color.withValues(alpha: 0.06),
        border: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _rc.color.withValues(alpha: 0.12),
            ),
            child: Icon(_rc.icon, color: _rc.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_rc.label,
                    style: TextStyle(
                        color: _rc.color,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                Text(r.summary,
                    style: const TextStyle(color: AppColors.textSec, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textTert),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Image.file(File(widget.imagePath!),
          height: 200, width: double.infinity, fit: BoxFit.cover),
    );
  }

  Widget _buildSummary(AnalysisResult r) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _rc.color.withValues(alpha: 0.08),
            _rc.color.withValues(alpha: 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: _rc.color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: _rc.color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(r.summary,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
    bool danger = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: danger ? const Color(0xFF1E1214) : AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: danger ? AppColors.red.withValues(alpha: 0.15) : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  color: danger ? AppColors.red : AppColors.blue, size: 16),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                    color: danger ? AppColors.red : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildCauses(AnalysisResult r) {
    return Column(
      children: r.possibleCauses
          .map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.only(top: 7, right: 10),
                      decoration: const BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(c,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13, height: 1.5)),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCases(AnalysisResult r) {
    return Column(
      children: r.matchedCases.take(4).map((c) => _caseTile(c)).toList(),
    );
  }

  Widget _caseTile(MatchedCase c) {
    final rc = _riskConfig(c.riskLevel);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rc.color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: rc.color.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: BoxDecoration(color: rc.color, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.3)),
                if (c.realCaseSummary.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(c.realCaseSummary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textSec, fontSize: 11, height: 1.4)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  _RiskConfig _riskConfig(String level) {
    switch (level) {
      case 'low':
        return _RiskConfig(
          color: AppColors.green,
          icon: Icons.check_circle_outline,
          label: '低风险',
        );
      case 'high':
        return _RiskConfig(
          color: AppColors.red,
          icon: Icons.dangerous_rounded,
          label: '高风险 · 尽快就医',
        );
      default:
        return _RiskConfig(
          color: AppColors.orange,
          icon: Icons.warning_amber_rounded,
          label: '中风险 · 观察护理',
        );
    }
  }
}

class _RiskConfig {
  final Color color;
  final IconData icon;
  final String label;
  const _RiskConfig({
    required this.color,
    required this.icon,
    required this.label,
  });
}
