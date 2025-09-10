import 'package:flutter/material.dart';

class ThemeController {
  ThemeController._internal();
  static final ThemeController instance = ThemeController._internal();

  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  void setLight() => themeMode.value = ThemeMode.light;
  void setDark() => themeMode.value = ThemeMode.dark;
  void toggle() => themeMode.value =
      themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
}
