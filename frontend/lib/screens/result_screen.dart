import 'dart:io';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/analysis_result.dart';

class ResultScreen extends StatelessWidget {
  final AnalysisResult result;
  final String? imagePath;

  const ResultScreen({super.key, required this.result, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final risk = AppTheme.riskStyle(result.riskLevel);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Column(
        children: [
          // Image header (if photo)
          if (imagePath != null)
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(imagePath!), fit: BoxFit.cover),
                  // gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          AppTheme.bg,
                        ],
                        stops: const [0, 0.5, 1],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.space2),
                      child: _closeButton(context, light: true),
                    ),
                  ),
                ],
              ),
            ),

          // Content sheet
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.bg,
                borderRadius: imagePath != null
                    ? const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg))
                    : null,
              ),
              child: CustomScrollView(
                slivers: [
                  if (imagePath == null)
                    SliverToBoxAdapter(
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.all(AppTheme.space2),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _closeButton(context),
                          ),
                        ),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                        AppTheme.space4, AppTheme.space2, AppTheme.space4, AppTheme.space10),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Risk banner
                        _RiskBanner(risk: risk, summary: result.summary),
                        const SizedBox(height: AppTheme.space4),

                        // Causes
                        if (result.possibleCauses.isNotEmpty) ...[
                          _sectionLabel('可能原因'),
                          _Card(
                            child: Column(
                              children: result.possibleCauses
                                  .map((c) => _bulletRow(c))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: AppTheme.space4),
                        ],

                        // Home care
                        if (result.homeCare.isNotEmpty) ...[
                          _sectionLabel('居家处理'),
                          _Card(
                            child: Text(result.homeCare,
                                style: AppTheme.body.copyWith(height: 1.6)),
                          ),
                          const SizedBox(height: AppTheme.space4),
                        ],

                        // When to see vet
                        if (result.whenToSeeVet.isNotEmpty) ...[
                          _sectionLabel('什么情况必须就医'),
                          _Card(
                            bg: AppTheme.red.withValues(alpha: 0.06),
                            border: AppTheme.red.withValues(alpha: 0.15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.local_hospital_rounded,
                                    color: AppTheme.red, size: 18),
                                const SizedBox(width: AppTheme.space2),
                                Expanded(
                                  child: Text(result.whenToSeeVet,
                                      style: AppTheme.body.copyWith(height: 1.6)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppTheme.space4),
                        ],

                        // Similar cases
                        if (result.matchedCases.isNotEmpty) ...[
                          _sectionLabel('相似案例 · ${result.similarCasesCount} 个'),
                          ...result.matchedCases
                              .take(4)
                              .map((c) => _CaseCard(matchedCase: c)),
                          const SizedBox(height: AppTheme.space4),
                        ],

                        // Disclaimer
                        _disclaimer(),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _closeButton(BuildContext context, {bool light = false}) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: light
              ? Colors.black.withValues(alpha: 0.35)
              : AppTheme.separator,
        ),
        child: Icon(Icons.close_rounded,
            size: 18, color: light ? Colors.white : AppTheme.textSec),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: AppTheme.space1, bottom: AppTheme.space2),
      child: Text(text.toUpperCase(), style: AppTheme.sectionHeader),
    );
  }

  Widget _bulletRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8, right: AppTheme.space2),
            decoration: const BoxDecoration(
                color: AppTheme.blue, shape: BoxShape.circle),
          ),
          Expanded(child: Text(text, style: AppTheme.body.copyWith(height: 1.5))),
        ],
      ),
    );
  }

  Widget _disclaimer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline_rounded,
            color: AppTheme.textTert, size: 14),
        const SizedBox(width: AppTheme.space2),
        Expanded(
          child: Text(result.disclaimer,
              style: AppTheme.caption1.copyWith(color: AppTheme.textTert)),
        ),
      ],
    );
  }
}

// ============================================================
// Risk banner
// ============================================================
class _RiskBanner extends StatelessWidget {
  final RiskStyle risk;
  final String summary;
  const _RiskBanner({required this.risk, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        color: risk.bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: risk.color.withValues(alpha: 0.15),
            ),
            child: Icon(risk.icon, color: risk.color, size: 24),
          ),
          const SizedBox(width: AppTheme.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(risk.label,
                        style: AppTheme.title3.copyWith(color: risk.color)),
                    const SizedBox(width: AppTheme.space2),
                    Text(risk.sublabel,
                        style: AppTheme.footnote.copyWith(color: risk.color)),
                  ],
                ),
                const SizedBox(height: AppTheme.space1),
                Text(summary, style: AppTheme.subhead.copyWith(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Generic card
// ============================================================
class _Card extends StatelessWidget {
  final Widget child;
  final Color? bg;
  final Color? border;
  const _Card({required this.child, this.bg, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.space4),
      decoration: BoxDecoration(
        color: bg ?? AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: border != null ? Border.all(color: border!) : null,
        boxShadow: bg == null ? AppTheme.cardShadow : null,
      ),
      child: child,
    );
  }
}

// ============================================================
// Case card
// ============================================================
class _CaseCard extends StatelessWidget {
  final MatchedCase matchedCase;
  const _CaseCard({required this.matchedCase});

  @override
  Widget build(BuildContext context) {
    final risk = AppTheme.riskStyle(matchedCase.riskLevel);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppTheme.space2),
      padding: const EdgeInsets.all(AppTheme.space3),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: risk.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppTheme.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(matchedCase.title,
                    style: AppTheme.callout,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                if (matchedCase.realCaseSummary.isNotEmpty) ...[
                  const SizedBox(height: AppTheme.space1),
                  Text(matchedCase.realCaseSummary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.footnote.copyWith(height: 1.4)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
