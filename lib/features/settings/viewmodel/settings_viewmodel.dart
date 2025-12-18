import 'package:flutter/material.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../app/theme/app_theme.dart'; // V5.0: Import AppTheme

class SettingsViewModel extends ChangeNotifier {
  final LocalStorageService _localStorageService = LocalStorageService();

  late ThemeMode _themeMode;
  late AppThemeColor _themeColor; // V5.0: State for the selected color theme
  late Locale _locale;
  bool _isLoading = true;

  ThemeMode get themeMode => _themeMode;
  AppThemeColor get themeColor => _themeColor; // V5.0: Getter
  Locale get locale => _locale;
  bool get isLoading => _isLoading;

  SettingsViewModel();

  Future<void> loadSettings() async {
    _isLoading = true;
    
    // Load theme mode, theme color, and language
    _themeMode = await _localStorageService.loadThemeMode();
    _themeColor = await _localStorageService.loadThemeColor();
    _locale = await _localStorageService.loadLanguage();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    await _localStorageService.saveThemeMode(mode);
  }

  // V5.0: New method to update and persist the color theme
  Future<void> setThemeColor(AppThemeColor color) async {
    if (color == _themeColor) return;
    _themeColor = color;
    notifyListeners();
    await _localStorageService.saveThemeColor(color);
  }

  Future<void> setLocale(Locale locale) async {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
    await _localStorageService.saveLanguage(locale.languageCode);
  }
}
