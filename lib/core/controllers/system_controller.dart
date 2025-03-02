import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 全局控制器
class SystemController extends GetxController {
  Locale _locale = const Locale("zh");

  /// 当前语言
  Locale get locale => _locale;

  /// 切换多语言
  void switchLanguage(Locale newLocale) {
    _locale = newLocale;
    update();
  }
}
