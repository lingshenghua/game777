import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // 需要添加依赖: google_fonts: ^5.0.0

final ThemeData blueTheme = ThemeData(
  useMaterial3: true,
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2196F3),
    // 主蓝色
    brightness: Brightness.light,
    secondary: const Color(0xFF4FC3F7),
    // 浅蓝
    tertiary: const Color(0xFFB3E5FC),
    // 超浅蓝
    surface: Colors.white,
    onSurface: const Color(0xFF1A237E),
    // 深蓝文字
    error: const Color(0xFFD32F2F),
  ),
  scaffoldBackgroundColor: Colors.blue.shade50, // 内容区背景
  textTheme: GoogleFonts.interTextTheme().copyWith(
    displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
    bodyLarge: const TextStyle(color: Color(0xFF1A237E)),
    labelLarge: const TextStyle(letterSpacing: 1.2),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    filled: true,
    fillColor: Colors.grey.shade50,
  ),
  cardTheme: CardTheme(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.grey.shade100),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFFE3F2FD), // 浅蓝背景
    titleTextStyle: TextStyle(
      color: Colors.blue.shade900,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    centerTitle: true,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    showSelectedLabels: true,
    showUnselectedLabels: true,
    enableFeedback: false,                 // 关闭点击音效
    // selectedItemColor: const Color(0xFF1565C0),
    // // 深蓝选中色
    // unselectedItemColor: Colors.grey.shade600,
    // 文字样式
    selectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.blue.shade800,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade600,
    ),
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    // landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
  ),
  iconTheme: const IconThemeData(color: Color(0xFF0D47A1)),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF1976D2),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFF1976D2),
    linearTrackColor: Color(0xFFBBDEFB),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.blue.shade100,
    thickness: 0.8,
    space: 1,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
