import 'package:flutter/material.dart';

class ColorUtil {
  static final ColorUtil _instance = ColorUtil._internal();

  factory ColorUtil() => _instance;

  ColorUtil._internal();

  static late ColorScheme _colors;
  static late TextTheme _textTheme;

  /// 初始化方法（必须在使用前调用）
  void init(BuildContext context) {
    _colors = Theme.of(context).colorScheme;
    _textTheme = Theme.of(context).textTheme;
  }

  /// ========== 颜色快捷访问 ==========
  static Color get primary => _colors.primary;

  static Color get secondary => _colors.secondary;

  static TextStyle get bodyText => _textTheme.bodyLarge!;

  /// ========== 业务扩展颜色 ==========
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
}
