import 'package:flutter/material.dart';

/// 猫省省设计系统 — 对齐 iOS HIG 原生浅色风格
/// 参考 SnapDeduct 高品质标准
class AppTheme {
  AppTheme._();

  // ============================================================
  // 品牌色
  // ============================================================
  static const Color blue = Color(0xFF007AFF);      // 主色
  static const Color blueDark = Color(0xFF0056CC);  // 按压态
  static const Color blueLight = Color(0xFFE8F2FF); // 选中背景

  // ============================================================
  // 语义色 (风险分级)
  // ============================================================
  static const Color green = Color(0xFF34C759);   // 低风险
  static const Color orange = Color(0xFFFF9500);  // 中风险
  static const Color red = Color(0xFFFF3B30);     // 高风险
  static const Color purple = Color(0xFFAF52DE);  // 会员/高级

  // ============================================================
  // 中性色
  // ============================================================
  static const Color bg = Color(0xFFF2F2F7);       // 应用背景
  static const Color bgCard = Color(0xFFFFFFFF);   // 卡片背景
  static const Color bgHeader = Color(0xFFF9F9FB); // 导航栏背景
  static const Color separator = Color(0xFFE5E5EA);// 分割线
  static const Color fill = Color(0xFFE5E5EA);     // 输入框填充
  static const Color text = Color(0xFF1C1C1E);     // 主文字
  static const Color textSec = Color(0xFF8E8E93);  // 次要文字
  static const Color textTert = Color(0xFFC7C7CC); // 占位文字

  // ============================================================
  // 分类色 (症状品类)
  // ============================================================
  static const Map<String, Color> categoryColors = {
    'skin': Color(0xFFAF52DE),
    'digestive': Color(0xFFFF9500),
    'urinary': Color(0xFF5AC8FA),
    'eye': Color(0xFF5856D6),
    'respiratory': Color(0xFF34C759),
    'oral': Color(0xFFFF2D55),
    'other': Color(0xFF8E8E93),
  };

  static const Map<String, String> categoryEmoji = {
    'skin': '🐾',
    'digestive': '🤮',
    'urinary': '💧',
    'eye': '👁',
    'respiratory': '🫁',
    'oral': '🦷',
    'other': '🐱',
  };

  // ============================================================
  // 间距网格 (4pt)
  // ============================================================
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;
  static const double space12 = 48;

  // ============================================================
  // 圆角
  // ============================================================
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;

  // ============================================================
  // 阴影
  // ============================================================
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // ============================================================
  // 字体
  // ============================================================
  static const String fontFamily = 'SF Pro Text';

  static const TextStyle largeTitle = TextStyle(
      fontSize: 34, fontWeight: FontWeight.w700, height: 41 / 34, color: text);
  static const TextStyle title1 = TextStyle(
      fontSize: 28, fontWeight: FontWeight.w700, height: 34 / 28, color: text);
  static const TextStyle title2 = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w700, height: 28 / 22, color: text);
  static const TextStyle title3 = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, height: 25 / 20, color: text);
  static const TextStyle headline = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w600, height: 22 / 17, color: text);
  static const TextStyle body = TextStyle(
      fontSize: 17, fontWeight: FontWeight.w400, height: 22 / 17, color: text);
  static const TextStyle callout = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, height: 21 / 16, color: text);
  static const TextStyle subhead = TextStyle(
      fontSize: 15, fontWeight: FontWeight.w500, height: 20 / 15, color: text);
  static const TextStyle footnote = TextStyle(
      fontSize: 13, fontWeight: FontWeight.w400, height: 18 / 13, color: textSec);
  static const TextStyle caption1 = TextStyle(
      fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12, color: textSec);
  static const TextStyle caption2 = TextStyle(
      fontSize: 11, fontWeight: FontWeight.w600, height: 13 / 11, color: textSec);

  /// 分区标题 (uppercase, tracked)
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: textSec,
  );

  // ============================================================
  // ThemeData
  // ============================================================
  static ThemeData get theme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: bg,
        fontFamily: fontFamily,
        colorScheme: const ColorScheme.light(
          primary: blue,
          secondary: blue,
          surface: bgCard,
          error: red,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bgHeader,
          foregroundColor: text,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
          titleTextStyle: headline,
        ),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      );

  // ============================================================
  // 风险配置
  // ============================================================
  static RiskStyle riskStyle(String level) {
    switch (level) {
      case 'low':
        return const RiskStyle(
          color: green,
          bg: Color(0xFFEAF9EE),
          icon: Icons.check_circle_rounded,
          label: '低风险',
          sublabel: '可居家观察',
          emoji: '🟢',
        );
      case 'high':
        return const RiskStyle(
          color: red,
          bg: Color(0xFFFFEBEA),
          icon: Icons.error_rounded,
          label: '高风险',
          sublabel: '建议尽快就医',
          emoji: '🔴',
        );
      default:
        return const RiskStyle(
          color: orange,
          bg: Color(0xFFFFF4E5),
          icon: Icons.warning_rounded,
          label: '中风险',
          sublabel: '观察并护理',
          emoji: '🟡',
        );
    }
  }
}

class RiskStyle {
  final Color color;
  final Color bg;
  final IconData icon;
  final String label;
  final String sublabel;
  final String emoji;
  const RiskStyle({
    required this.color,
    required this.bg,
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.emoji,
  });
}
