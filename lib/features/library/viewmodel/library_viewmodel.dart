import 'package:flutter/material.dart';
import '../../../core/models/book_model.dart';
import '../../../core/models/category_model.dart';
import '../../../core/services/api_service.dart';

class LibraryViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Internal State
  List<Book> _allBooks = [];
  List<Category> _allCategories = [];
  bool _isLoading = false;
  bool _hasError = false;
  int? _selectedCategoryId; 
  String _searchQuery = ''; // V2.0: State for the search query

  // Getters for the View
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  int? get selectedCategoryId => _selectedCategoryId;
  List<Category> get categories => _allCategories;
  
  List<Book> get filteredBooks {
    List<Book> books = _allBooks;

    // 1. Filter by category
    if (_selectedCategoryId != null) {
      final categoryName = _allCategories
          .firstWhere((cat) => cat.id == _selectedCategoryId, orElse: () => Category(id: -1, name: ''))
          .name;
      books = books.where((book) => book.category == categoryName).toList();
    }

    // 2. Filter by search query (V2.0)
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      books = books.where((book) {
        final titleMatch = book.title.toLowerCase().contains(query);
        final authorMatch = book.author.toLowerCase().contains(query);
        return titleMatch || authorMatch;
      }).toList();
    }

    return books;
  }

  LibraryViewModel() {
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getBooks(),
        _apiService.getCategories(),
      ]);

      _allBooks = results[0] as List<Book>;
      _allCategories = results[1] as List<Category>;

    } catch (e) {
      _hasError = true;
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sets the category filter.
  void selectCategory(int? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  /// Sets the search query. (V2.0)
  void searchBooks(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
