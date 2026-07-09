import 'package:flutter/material.dart';

/// 分析结果数据模型
class AnalysisResult {
  final String requestId;
  final String riskLevel;
  final String summary;
  final List<String> possibleCauses;
  final String homeCare;
  final String whenToSeeVet;
  final int similarCasesCount;
  final List<MatchedCase> matchedCases;
  final String disclaimer;
  final double elapsedMs;

  AnalysisResult({
    required this.requestId,
    required this.riskLevel,
    required this.summary,
    required this.possibleCauses,
    required this.homeCare,
    required this.whenToSeeVet,
    required this.similarCasesCount,
    required this.matchedCases,
    required this.disclaimer,
    required this.elapsedMs,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      requestId: json['request_id'] ?? '',
      riskLevel: json['risk_level'] ?? 'medium',
      summary: json['summary'] ?? '',
      possibleCauses: List<String>.from(json['possible_causes'] ?? []),
      homeCare: json['home_care'] ?? '',
      whenToSeeVet: json['when_to_see_vet'] ?? '',
      similarCasesCount: json['similar_cases_count'] ?? 0,
      matchedCases: (json['matched_cases'] as List<dynamic>?)
              ?.map((c) => MatchedCase.fromJson(c))
              .toList() ??
          [],
      disclaimer: json['disclaimer'] ?? '',
      elapsedMs: (json['elapsed_ms'] ?? 0).toDouble(),
    );
  }

  Color get riskColor {
    switch (riskLevel) {
      case 'low':
        return const Color(0xFF22C55E);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'high':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF8890A4);
    }
  }

  String get riskLabel {
    switch (riskLevel) {
      case 'low':
        return '低风险';
      case 'medium':
        return '中风险';
      case 'high':
        return '高风险';
      default:
        return '未知';
    }
  }

  IconData get riskIcon {
    switch (riskLevel) {
      case 'low':
        return Icons.check_circle_outline;
      case 'medium':
        return Icons.warning_amber_rounded;
      case 'high':
        return Icons.dangerous_rounded;
      default:
        return Icons.help_outline;
    }
  }
}

class MatchedCase {
  final String id;
  final String title;
  final String riskLevel;
  final String realCaseSummary;
  final double score;

  MatchedCase({
    required this.id,
    required this.title,
    required this.riskLevel,
    required this.realCaseSummary,
    required this.score,
  });

  factory MatchedCase.fromJson(Map<String, dynamic> json) {
    return MatchedCase(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      riskLevel: json['risk_level'] ?? 'medium',
      realCaseSummary: json['real_case_summary'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
    );
  }
}

class AlternativeItem {
  final String category;
  final String item;
  final String price;
  final String alternative;
  final String altPrice;
  final String reason;

  AlternativeItem({
    required this.category,
    required this.item,
    required this.price,
    required this.alternative,
    required this.altPrice,
    required this.reason,
  });

  factory AlternativeItem.fromJson(Map<String, dynamic> json) {
    return AlternativeItem(
      category: json['category'] ?? '',
      item: json['item'] ?? '',
      price: json['price'] ?? '',
      alternative: json['alternative'] ?? '',
      altPrice: json['alt_price'] ?? '',
      reason: json['reason'] ?? '',
    );
  }
}
