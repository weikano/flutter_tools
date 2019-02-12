import 'package:flutter/widgets.dart';
import 'package:flutter_tools/app_strings.dart';

class _AppLocaleDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppLocaleDelegate();
  @override
  bool isSupported(Locale locale) => ['zh', 'en'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) {
    return AppStrings.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppStrings> old) => false;
}

class AppLocale {
  static const LocalizationsDelegate<AppStrings> delegate =
      _AppLocaleDelegate();
}
