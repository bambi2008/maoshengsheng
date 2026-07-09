import 'package:flutter/material.dart';
import 'screens/camera_screen.dart';
import 'screens/knowledge_screen.dart';

void main() {
  runApp(const MaoShengShengApp());
}

class MaoShengShengApp extends StatelessWidget {
  const MaoShengShengApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '猫省省',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.blue,
          secondary: AppColors.blue,
          surface: AppColors.card,
          error: AppColors.red,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bg,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Text',
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.bg,
          selectedItemColor: AppColors.blue,
          unselectedItemColor: AppColors.textTert,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        ),
        fontFamily: 'SF Pro Text',
      ),
      home: const MainScreen(),
    );
  }
}

// ============================================================
// Design System
// ============================================================

abstract class AppColors {
  static const Color blue = Color(0xFF3B82F6);
  static const Color blueDark = Color(0xFF2563EB);
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFF59E0B);
  static const Color red = Color(0xFFEF4444);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color teal = Color(0xFF06B6D4);

  static const Color bg = Color(0xFF090A0E);
  static const Color card = Color(0xFF13141A);
  static const Color header = Color(0xFF0D0E14);
  static const Color divider = Color(0xFF1E2030);

  static const Color text = Color(0xFFF5F5F7);
  static const Color textSec = Color(0xFF8E8E93);
  static const Color textTert = Color(0xFF555A68);
}

abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

abstract class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double full = 999;
}

// ============================================================
// Main Screen
// ============================================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CameraScreen(),
    KnowledgeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt_rounded, size: 24),
                label: '拍照',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lightbulb_outline_rounded, size: 24),
                label: '避坑',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
