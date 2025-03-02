import 'package:flutter/material.dart';
import 'package:game777/common/enums/export.dart';
import 'package:game777/l10n/export.dart';

class I10nUtil {
  static final _instance = I10nUtil._internal();

  factory I10nUtil() => _instance;

  I10nUtil._internal();

  late AppLocalizations _current;

  void init(BuildContext context) {
    _current = AppLocalizations.of(context)!;
  }

  static String tr(String key, {LanguageEnum? module = LanguageEnum.common, List<dynamic>? valueList}) {
    return _instance._current.getTr(key, module: module, valueList: valueList);
  }
}
