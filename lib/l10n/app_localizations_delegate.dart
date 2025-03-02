import 'package:flutter/material.dart';
import 'package:game777/common/export.dart';
import 'package:game777/l10n/export.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['id', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final l10n = AppLocalizations(locale);
    await l10n.loadModule(LanguageEnum.common);
    return l10n;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => true;
}
