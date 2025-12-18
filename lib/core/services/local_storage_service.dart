import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/theme/app_theme.dart';

class LocalStorageService {
  static const _themeModeKey = 'theme_mode';
  static const _themeColorKey = 'theme_color';
  static const _favoriteBooksKey = 'favorite_books';
  static const _readBooksKey = 'read_books';
  static const _languageKey = 'language';
  static const _onboardingCompletedKey = 'onboarding_completed';

  // --- Theme --- //

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index; 
    return ThemeMode.values[themeModeIndex];
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
  }

  Future<AppThemeColor> loadThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to deepPurple (index 0) if not set or if index is invalid
    final themeColorIndex = prefs.getInt(_themeColorKey) ?? 0;
    
    if (themeColorIndex >= 0 && themeColorIndex < AppThemeColor.values.length) {
      return AppThemeColor.values[themeColorIndex];
    }
    return AppThemeColor.deepPurple;
  }

  Future<void> saveThemeColor(AppThemeColor color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeColorKey, color.index);
  }

  // --- Language --- //

  Future<Locale> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    return Locale(languageCode);
  }

  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  // --- Onboarding --- //

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  // --- Favorites --- //

  Future<List<int>> loadFavoriteBookIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIdsAsString = prefs.getStringList(_favoriteBooksKey) ?? [];
    return favoriteIdsAsString.map(int.parse).toList();
  }

  Future<void> addFavoriteBook(int bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = await loadFavoriteBookIds();
    if (!currentFavorites.contains(bookId)) {
      currentFavorites.add(bookId);
      await prefs.setStringList(_favoriteBooksKey, currentFavorites.map((id) => id.toString()).toList());
    }
  }

  Future<void> removeFavoriteBook(int bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = await loadFavoriteBookIds();
    if (currentFavorites.contains(bookId)) {
      currentFavorites.remove(bookId);
      await prefs.setStringList(_favoriteBooksKey, currentFavorites.map((id) => id.toString()).toList());
    }
  }

  // --- Read Books --- //

  Future<List<int>> loadReadBookIds() async {
    final prefs = await SharedPreferences.getInstance();
    final readIdsAsString = prefs.getStringList(_readBooksKey) ?? [];
    return readIdsAsString.map(int.parse).toList();
  }

  Future<void> addReadBook(int bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentRead = await loadReadBookIds();
    if (!currentRead.contains(bookId)) {
      currentRead.add(bookId);
      await prefs.setStringList(_readBooksKey, currentRead.map((id) => id.toString()).toList());
    }
  }

  Future<void> removeReadBook(int bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentRead = await loadReadBookIds();
    if (currentRead.contains(bookId)) {
      currentRead.remove(bookId);
      await prefs.setStringList(_readBooksKey, currentRead.map((id) => id.toString()).toList());
    }
  }
}
