import 'package:flutter/material.dart';
import '../../../core/models/book_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/local_storage_service.dart';

class FavoritesViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorageService = LocalStorageService();

  List<Book> _favoriteBooks = [];
  bool _isLoading = false;
  bool _hasError = false;

  List<Book> get favoriteBooks => _favoriteBooks;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  FavoritesViewModel() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final favoriteIds = await _localStorageService.loadFavoriteBookIds();
      if (favoriteIds.isEmpty) {
        _favoriteBooks = [];
      } else {
        // In a real app, it's better to have an API endpoint like GET /books?ids=1,2,3
        // to avoid fetching all books.
        final allBooks = await _apiService.getBooks();
        _favoriteBooks = allBooks.where((book) => favoriteIds.contains(book.id)).toList();
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
