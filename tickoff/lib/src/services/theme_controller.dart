import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  ThemeController._internal();
  static final ThemeController instance = ThemeController._internal();

  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  static const String _themeKey = 'app_theme';

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    themeMode.value = ThemeMode.values[themeIndex];
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeMode.value.index);
  }

  Future<void> setLight() async {
    themeMode.value = ThemeMode.light;
    await _saveTheme();
  }

  Future<void> setDark() async {
    themeMode.value = ThemeMode.dark;
    await _saveTheme();
  }

  Future<void> toggle() async {
    themeMode.value = themeMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await _saveTheme();
  }
}
