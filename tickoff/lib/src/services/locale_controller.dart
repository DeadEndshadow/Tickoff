import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController {
  LocaleController._internal();
  static final LocaleController instance = LocaleController._internal();

  final ValueNotifier<Locale> locale = ValueNotifier(const Locale('de'));

  static const String _localeKey = 'app_locale';

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey) ?? 'de';
    locale.value = Locale(languageCode);
  }

  Future<void> setLocale(Locale newLocale) async {
    locale.value = newLocale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, newLocale.languageCode);
  }

  void setGerman() => setLocale(const Locale('de'));
  void setEnglish() => setLocale(const Locale('en'));
  void setFrench() => setLocale(const Locale('fr'));

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'de':
        return 'Deutsch';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return languageCode;
    }
  }

  static const List<Locale> supportedLocales = [
    Locale('de'),
    Locale('en'),
    Locale('fr'),
  ];
}
