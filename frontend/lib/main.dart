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
        scaffoldBackgroundColor: const Color(0xFF0F1117),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF3B82F6),
          surface: Color(0xFF161822),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1117),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0F1117),
          selectedItemColor: Color(0xFF3B82F6),
          unselectedItemColor: Color(0xFF8890A4),
        ),
        fontFamily: 'PingFang SC',
      ),
      home: const MainScreen(),
    );
  }
}

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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_rounded),
            label: '拍照分析',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline_rounded),
            label: '避坑百科',
          ),
        ],
      ),
    );
  }
}
