import 'package:flutter/material.dart';
import '../../../core/models/category_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/local_storage_service.dart';

class OnboardingViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorageService = LocalStorageService();

  // State Variables
  List<Category> _categories = [];
  final Set<int> _selectedCategoryIds = {};
  bool _isLoading = false;
  bool _isSaving = false;

  // Getters for the View
  List<Category> get categories => _categories;
  Set<int> get selectedCategoryIds => _selectedCategoryIds;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  OnboardingViewModel() {
    fetchCategories();
  }

  //--- Actions ---

  /// Fetches the list of categories from the backend.
  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
    } catch (e) {
      // In a real app, you'd handle this error with a logger and user-facing message.
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggles the selection status of a category.
  void toggleCategorySelection(int categoryId) {
    if (_selectedCategoryIds.contains(categoryId)) {
      _selectedCategoryIds.remove(categoryId);
    } else {
      _selectedCategoryIds.add(categoryId);
    }
    notifyListeners();
  }

  /// Saves the user's selected preferences to the backend.
  /// Returns true if saving was successful, false otherwise.
  Future<bool> savePreferences() async {
    if (_selectedCategoryIds.isEmpty) {
      // Optional: Prevent continuing without any selection.
      return false;
    }

    _isSaving = true;
    notifyListeners();

    try {
      // Using a hardcoded user ID of 1 for this example.
      // In a real app, this would come from an authentication service.
      await _apiService.savePreferences(1, _selectedCategoryIds.toList());
      
      // Mark onboarding as completed locally
      await _localStorageService.setOnboardingCompleted();
      
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
