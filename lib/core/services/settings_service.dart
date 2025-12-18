import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _themeModeKey = 'theme_mode';

  /// Loads the user's preferred ThemeMode from local storage.
  /// 
  /// Defaults to [ThemeMode.system] if no preference is found.
  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? 0; // Default to system
    return ThemeMode.values[themeModeIndex];
  }

  /// Persists the user's preferred ThemeMode to local storage.
  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
  }
}
