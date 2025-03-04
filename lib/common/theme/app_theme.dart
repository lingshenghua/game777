import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  /// 启用 Material 3 设计规范
  useMaterial3: true,

  /// 禁用按压高亮效果
  highlightColor: Colors.transparent,

  /// 禁用水波纹效果
  splashColor: Colors.transparent,
  colorScheme: ColorScheme.fromSeed(
    /// 主色种子（生成配色体系）
    seedColor: const Color(0xFF2196F3),

    /// 亮度模式
    brightness: Brightness.light,

    /// 次要色（按钮/进度条）
    secondary: const Color(0xFF4FC3F7),

    /// 强调色（图标/标签）
    tertiary: const Color(0xFFB3E5FC),

    /// 卡片/对话框背景
    surface: Colors.white,

    /// 表面元素文字颜色
    onSurface: const Color(0xFF1A237E),

    /// 错误色
    error: const Color(0xFFD32F2F),
  ),

  /// 页面脚手架背景
  scaffoldBackgroundColor: Colors.blue.shade50,
  textTheme: TextTheme(
    /// 大标题文字颜色
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),

    /// 正文字体颜色
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.grey.shade800,
    ),

    /// 按钮文字颜色
    labelLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
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
    /// 浅蓝背景
    backgroundColor: const Color(0xFFE3F2FD),
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
    enableFeedback: false,
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

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF90CAF9),

    /// 暗色主色种子
    brightness: Brightness.dark,
    secondary: const Color(0xFF29B6F6),
    tertiary: const Color(0xFFE1F5FE),

    /// 暗色表面
    surface: const Color(0xFF1E1E1E),

    /// 暗色文字
    onSurface: Colors.white70,

    /// 暗色错误提示
    error: const Color(0xFFEF9A9A),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),

  /// 暗色标题
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white70,
    ),

    /// 暗色正文
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.grey.shade300,
    ),

    /// 暗色按钮文字
    labelLarge: TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w500,
    ),
  ),

  /// 暗色按钮背景
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1976D2),
    ),
  ),

  /// 暗色输入框背景
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color(0xFF2D2D2D),
  ),

  /// 暗色卡片背景
  cardTheme: CardTheme(
    color: const Color(0xFF242424),
  ),

  /// 深蓝背景
  appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF1A237E),
  ),

  /// 暗色底部导航
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF1E1E1E),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF90CAF9)),
);
