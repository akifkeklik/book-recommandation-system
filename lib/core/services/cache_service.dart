import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/book_model.dart';

/// Enhanced caching service for improved performance and offline support
class CacheService {
  static const String _booksKey = 'cached_books';
  static const String _recommendationsKey = 'cached_recommendations';
  static const String _timestampSuffix = '_timestamp';
  static const Duration _cacheValidity = Duration(hours: 1);

  /// Cache books with timestamp
  Future<void> cacheBooks(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson = books.map((b) => b.toJson()).toList();
    await prefs.setString(_booksKey, json.encode(booksJson));
    await prefs.setInt(
      '$_booksKey$_timestampSuffix',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Get cached books if valid
  Future<List<Book>?> getCachedBooks() async {
    final prefs = await SharedPreferences.getInstance();
    if (!_isCacheValid(prefs, _booksKey)) return null;

    final cached = prefs.getString(_booksKey);
    if (cached == null) return null;

    try {
      final List<dynamic> decoded = json.decode(cached);
      return decoded.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  /// Cache recommendations
  Future<void> cacheRecommendations(int userId, List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_recommendationsKey}_$userId';
    final booksJson = books.map((b) => b.toJson()).toList();
    await prefs.setString(key, json.encode(booksJson));
    await prefs.setInt(
      '$key$_timestampSuffix',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Get cached recommendations
  Future<List<Book>?> getCachedRecommendations(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${_recommendationsKey}_$userId';
    if (!_isCacheValid(prefs, key)) return null;

    final cached = prefs.getString(key);
    if (cached == null) return null;

    try {
      final List<dynamic> decoded = json.decode(cached);
      return decoded.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      return null;
    }
  }

  /// Clear all cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_booksKey);
    await prefs.remove('$_booksKey$_timestampSuffix');
  }

  /// Check if cache is still valid
  bool _isCacheValid(SharedPreferences prefs, String key) {
    final timestamp = prefs.getInt('$key$_timestampSuffix');
    if (timestamp == null) return false;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(cacheTime) < _cacheValidity;
  }
}
