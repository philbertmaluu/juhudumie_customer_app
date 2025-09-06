import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

/// Theme manager for handling theme switching and persistence
class ThemeManager extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  
  /// Current theme mode
  ThemeMode get themeMode => _themeMode;
  
  /// Check if current theme is dark
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
  
  /// Check if current theme is light
  bool get isLightMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.light;
    }
    return _themeMode == ThemeMode.light;
  }
  
  /// Check if using system theme
  bool get isSystemMode => _themeMode == ThemeMode.system;
  
  /// Initialize theme manager and load saved theme
  Future<void> initialize() async {
    await _loadTheme();
  }
  
  /// Load theme from shared preferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      _themeMode = ThemeMode.values[themeIndex];
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
      _themeMode = ThemeMode.system;
    }
  }
  
  /// Save theme to shared preferences
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _themeMode.index);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
  
  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _saveTheme();
      notifyListeners();
    }
  }
  
  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.system) {
      // If system mode, switch to light
      await setThemeMode(ThemeMode.light);
    } else if (_themeMode == ThemeMode.light) {
      // If light mode, switch to dark
      await setThemeMode(ThemeMode.dark);
    } else {
      // If dark mode, switch to system
      await setThemeMode(ThemeMode.system);
    }
  }
  
  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }
  
  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }
  
  /// Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
  
  /// Get theme data based on current mode
  ThemeData getThemeData(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.system:
        final brightness = MediaQuery.of(context).platformBrightness;
        return brightness == Brightness.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
    }
  }
  
  /// Get theme mode display name
  String get themeModeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
  
  /// Get theme mode description
  String get themeModeDescription {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Always use light theme';
      case ThemeMode.dark:
        return 'Always use dark theme';
      case ThemeMode.system:
        return 'Follow system theme';
    }
  }
}
