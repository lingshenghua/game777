import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 系统全局控制器
class SystemController extends GetxController {
  Locale _locale = const Locale("zh");

  /// 当前语言
  Locale get locale => _locale;

  final _isDarkMode = false.obs;

  /// 主题模式
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  /// 切换主题
  void toggleTheme() {
    _isDarkMode.toggle();
    Get.changeThemeMode(themeMode);
  }

  /// 切换多语言
  void switchLanguage(Locale newLocale) {
    _locale = newLocale;
    Get.updateLocale(locale);
  }
}
