import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.from(colorScheme: const ColorScheme.light());
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeData get themeData => _themeData;
  // Test

  void toggleTheme() {
    if (_themeData == ThemeData.from(colorScheme: const ColorScheme.light())) {
      _themeData = ThemeData.from(colorScheme: const ColorScheme.dark());
      _isDarkMode = !_isDarkMode;
    } else {
      _themeData = ThemeData.from(colorScheme: const ColorScheme.light());
      _isDarkMode = !_isDarkMode;
    }
    notifyListeners();
  }
}
