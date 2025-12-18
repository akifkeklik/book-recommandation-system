import 'package:flutter/material.dart';
import 'dart:collection';
import '../../../core/models/book_model.dart';
import '../../../core/services/api_service.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // State
  List<Book> _recommendations = [];
  List<Book> _popularBooks = []; 
  bool _isLoading = false;
  bool _hasError = false;

  // Getters 
  UnmodifiableListView<Book> get recommendations => UnmodifiableListView(_recommendations);
  UnmodifiableListView<Book> get popularBooks => UnmodifiableListView(_popularBooks);
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

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
}
