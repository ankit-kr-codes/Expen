import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    var prefs = await SharedPreferences.getInstance();
    int? savedTheme = prefs.getInt('themeMode');
    if (savedTheme != null) {
      _themeMode =
          AppTheme.values[savedTheme] == AppTheme.light
              ? ThemeMode.light
              : AppTheme.values[savedTheme] == AppTheme.dark
              ? ThemeMode.dark
              : ThemeMode.system;
      notifyListeners();
    }
  }

  Future<void> setTheme(AppTheme theme) async {
    _themeMode =
        theme == AppTheme.light
            ? ThemeMode.light
            : theme == AppTheme.dark
            ? ThemeMode.dark
            : ThemeMode.system;
    notifyListeners();

    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', theme.index);
  }
}
