import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _themeData;

  // Test

  void toggleTheme() {
    if (_themeData == ThemeData.light()) {
      _themeData = ThemeData.dark();
      _isDarkMode = !_isDarkMode;
    } else {
      _themeData = ThemeData.light();
      _isDarkMode = !_isDarkMode;
    }
    notifyListeners();
  }
}
