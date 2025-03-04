import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game777/common/export.dart';
import 'package:game777/core/cache/export.dart';
import 'package:game777/core/controllers/export.dart';
import 'package:get/get.dart';

class AppLocalizations {
  final Locale locale;
  final Map<LanguageEnum, Map<String, String>> _modules = {};
  static const _cacheDuration = Duration(hours: 1);
  final safeCache = SafeCache();

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// 强制更新指定模块
  Future<void> hotfixModule(LanguageEnum module) async {
    try {
      final remoteData = await _fetchRemote(module);
      _modules[module] = remoteData;
      _cacheModule(module, remoteData);
    } catch (e) {
      debugPrint('Hotfix failed: $e');
    }
  }

  /// 修改后的模块加载方法
  Future<void> loadModule(LanguageEnum module) async {
    if (_modules.containsKey(module)) return;

    /// 加载顺序：内存 -> 远程 -> 本地 -> 应急
    try {
      /// 尝试获取远程最新版本
      final remoteData = await _fetchRemote(module);
      _modules[module] = remoteData;
      _cacheModule(module, remoteData);
    } catch (e) {
      /// 失败后尝试读取缓存
      final cached = await _loadCached(module);
      if (cached != null) {
        _modules[module] = cached;
      } else {
        /// 最终回退本地文件
        _modules[module] = await _loadLocal(module);
      }
    }
  }

  /// 释放非核心模块
  void unloadModule(LanguageEnum module) {
    if (module != LanguageEnum.common) {
      _modules.remove(module);
      debugPrint('Unloaded module: $module');
    }
  }

  /// 翻译获取方法
  String getTr(String key, {LanguageEnum? module = LanguageEnum.common, List<dynamic>? valueList}) {
    final template = _modules[module]?[key] ?? _getFallbackText(module!, key);
    return _formatTemplate(template, valueList);
  }

  /// 远程缓存逻辑
  Future<void> _cacheModule(LanguageEnum module, Map<String, String> data) async {
    await safeCache.set(
      key: '${locale.languageCode}_$module',
      value: jsonEncode({'data': data, 'timestamp': DateTime.now().millisecondsSinceEpoch}),
    );
  }

  Future<Map<String, String>?> _loadCached(LanguageEnum module) async {
    final cached = safeCache.get('${locale.languageCode}_$module');
    if (cached != null) {
      final jsonData = jsonDecode(cached);
      final timestamp = jsonData['timestamp'] as int;
      if (DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp)) < _cacheDuration) {
        return Map<String, String>.from(jsonData['data']);
      }
    }
    return null;
  }

  /// 远程加载方法
  Future<Map<String, String>> _fetchRemote(LanguageEnum module) async {
    return _parseJson("");
  }

  /// 本地加载方法
  Future<Map<String, String>> _loadLocal(LanguageEnum module) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/l10n/${locale.languageCode}/${module.name}.json');
      return _parseJson(jsonStr);
    } catch (e) {
      return _getFallback(module);
    }
  }

  /// JSON解析方法
  static Map<String, String> _parseJson(String jsonStr) {
    return (jsonDecode(jsonStr) as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString()));
  }

  /// 应急数据
  Map<String, String> _getFallback(LanguageEnum module) {
    return {};
  }

  Map<LanguageEnum, Map<String, String>> _getFallbackTranslations() {
    return {};
  }

  String _getFallbackText(LanguageEnum module, String key) {
    return _getFallbackTranslations()[module]?[key] ?? '[$key]';
  }

  String _formatTemplate(String template, List<dynamic>? valueList) {
    final list = valueList ?? [];
    int currentIndex = 0;
    return template.replaceAllMapped(RegExp(r'%s'), (match) {
      final value = (currentIndex < list.length) ? list[currentIndex].toString() : '';
      currentIndex++;
      return value;
    });
  }

  static Future<void> changeLocale(Locale newLocale) async {
    SystemController systemController = Get.find<SystemController>();
    systemController.switchLanguage(newLocale);
  }
}
