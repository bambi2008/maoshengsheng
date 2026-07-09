import 'package:flutter/material.dart';
import '../models/analysis_result.dart';

class ResultScreen extends StatelessWidget {
  final AnalysisResult result;
  final String? imagePath;

  const ResultScreen({super.key, required this.result, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('分析结果'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Risk level banner
            _RiskBanner(result: result),
            const SizedBox(height: 20),

            // Summary
            if (result.summary.isNotEmpty) ...[
              _SectionCard(
                title: '概要',
                icon: Icons.summarize_rounded,
                child: Text(result.summary,
                    style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5)),
              ),
              const SizedBox(height: 12),
            ],

            // Possible causes
            if (result.possibleCauses.isNotEmpty) ...[
              _SectionCard(
                title: '可能原因',
                icon: Icons.search_rounded,
                child: Column(
                  children: result.possibleCauses
                      .map((c) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: Color(0xFF3B82F6))),
                                Expanded(
                                    child: Text(c,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14, height: 1.4))),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Home care
            if (result.homeCare.isNotEmpty) ...[
              _SectionCard(
                title: '居家处理',
                icon: Icons.home_rounded,
                child: Text(result.homeCare,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6)),
              ),
              const SizedBox(height: 12),
            ],

            // When to see vet
            if (result.whenToSeeVet.isNotEmpty) ...[
              _SectionCard(
                title: '什么情况必须就医',
                icon: Icons.local_hospital_rounded,
                highlight: true,
                child: Text(result.whenToSeeVet,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6)),
              ),
              const SizedBox(height: 12),
            ],

            // Matched cases
            if (result.matchedCases.isNotEmpty) ...[
              _SectionCard(
                title: '相似案例 (${result.similarCasesCount}个)',
                icon: Icons.people_rounded,
                child: Column(
                  children: result.matchedCases
                      .map((c) => _MatchedCaseTile(matchedCase: c))
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Processing time
            Center(
              child: Text(
                '分析耗时 ${result.elapsedMs.toStringAsFixed(0)}ms',
                style: const TextStyle(color: Color(0xFF555A68), fontSize: 11),
              ),
            ),

            // Disclaimer
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF161822),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF8890A4), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      result.disclaimer,
                      style: const TextStyle(color: Color(0xFF8890A4), fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _RiskBanner extends StatelessWidget {
  final AnalysisResult result;
  const _RiskBanner({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: result.riskColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: result.riskColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(result.riskIcon, color: result.riskColor, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.riskLabel,
                  style: TextStyle(
                    color: result.riskColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result.summary,
                  style: const TextStyle(color: Color(0xFF8890A4), fontSize: 13),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final bool highlight;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFF2D1A1A) : const Color(0xFF161822),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? const Color(0xFFEF4444).withOpacity(0.3) : const Color(0xFF232636),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF3B82F6), size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MatchedCaseTile extends StatelessWidget {
  final MatchedCase matchedCase;
  const _MatchedCaseTile({required this.matchedCase});

  Color get _color {
    switch (matchedCase.riskLevel) {
      case 'low':
        return const Color(0xFF22C55E);
      case 'high':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(matchedCase.title,
                    style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3)),
                if (matchedCase.realCaseSummary.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(matchedCase.realCaseSummary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF8890A4), fontSize: 12, height: 1.4)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
