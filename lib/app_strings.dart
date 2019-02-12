import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'i18n/messages_all.dart';

class AppStrings {
  final String _localeName;
  AppStrings(Locale locale) : _localeName = locale.toString();
  static Future<AppStrings> load(Locale locale) {
    return initializeMessages(locale.toString()).then((_) {
      return AppStrings(locale);
    });
  }

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings);
  }

  String title() {
    return Intl.message("Flutter工具盒子",
        name: 'title', desc: '应用标题', locale: _localeName);
  }

  String click() {
    return Intl.message('Click',
        name: 'click', desc: '点击', locale: _localeName);
  }

  String hello() {
    return Intl.message('Hello~',
        name: 'hello', desc: '问候', locale: _localeName);
  }

  String _str(String name) {
    return Intl.message(name, name: name, locale: _localeName);
  }

  operator [](String name) => _str(name);
}
