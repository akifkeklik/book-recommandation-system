import 'dart:collection';

import 'package:flutter/material.dart';

import '../../../core/models/book_model.dart';
import '../../../core/services/api_service.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State
  List<Book> _recommendations = [];
  List<Book> _popularBooks = [];
  List<Book> _searchResults = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _isSearching = false;
  String _searchQuery = '';

  // Getters
  UnmodifiableListView<Book> get recommendations =>
      UnmodifiableListView(_recommendations);
  UnmodifiableListView<Book> get popularBooks =>
      UnmodifiableListView(_popularBooks);
  UnmodifiableListView<Book> get searchResults =>
      UnmodifiableListView(_searchResults);
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;

  HomeViewModel() {
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final recommendationsData = await _apiService.getRecommendations(1);

      // If API returns empty (and mock fails which is unlikely), handle it gracefully
      if (recommendationsData.isEmpty) {
        _hasError = true;
      } else {
        _recommendations = recommendationsData;
        _popularBooks = List<Book>.from(recommendationsData);
        _popularBooks.sort((a, b) => b.popularity.compareTo(a.popularity));
      }
    } catch (e) {
      _hasError = true;
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchBooks(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      // Search in both recommendations and popular books
      final allBooks = [..._recommendations, ..._popularBooks];
      _searchResults = allBooks.where((book) {
        final titleMatch = book.title.toLowerCase().contains(
          query.toLowerCase(),
        );
        final authorMatch = book.author.toLowerCase().contains(
          query.toLowerCase(),
        );
        return titleMatch || authorMatch;
      }).toList();
    } catch (e) {
      print('Search error: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }
}
