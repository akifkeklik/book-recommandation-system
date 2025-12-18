import 'package:flutter/material.dart';
import '../../../core/models/book_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/local_storage_service.dart';

class BookDetailViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorageService = LocalStorageService();
  final int bookId;

  // State
  Book? _book;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isFavorite = false;
  bool _isRead = false; // V6.0: Track read status
  List<Book> _relatedBooks = [];

  // Getters
  Book? get book => _book;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isFavorite => _isFavorite;
  bool get isRead => _isRead; // V6.0
  List<Book> get relatedBooks => _relatedBooks;

  BookDetailViewModel({required this.bookId}) {
    fetchBookDetails();
  }

  Future<void> fetchBookDetails() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // V4.1: This logic is now much more complex, so we fetch calls in sequence

      // 1. Fetch the main book. In a real app, this would be a single `_apiService.getBookById(bookId)` call.
      final allBooks = await _apiService.getBooks(); // This is still inefficient but required for now.
      _book = allBooks.firstWhere((b) => b.id == bookId);

      // 2. If the book is found, fetch related books efficiently.
      if (_book != null) {
        final related = await _apiService.getBooksByCategory(_book!.category);
        _relatedBooks = related.where((b) => b.id != bookId).take(5).toList();
      }

      // 3. Check for favorite status
      final favoriteIds = await _localStorageService.loadFavoriteBookIds();
      _isFavorite = favoriteIds.contains(bookId);

      // 4. Check for read status (V6.0)
      final readIds = await _localStorageService.loadReadBookIds();
      _isRead = readIds.contains(bookId);

    } catch (e) {
      _hasError = true;
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite() async {
    if (_isFavorite) {
      await _localStorageService.removeFavoriteBook(bookId);
      _isFavorite = false;
    } else {
      await _localStorageService.addFavoriteBook(bookId);
      _isFavorite = true;
    }
    notifyListeners();
  }

  // V6.0: Toggle Read status
  Future<void> toggleRead() async {
    if (_isRead) {
      await _localStorageService.removeReadBook(bookId);
      _isRead = false;
    } else {
      await _localStorageService.addReadBook(bookId);
      _isRead = true;
    }
    notifyListeners();
  }
}
