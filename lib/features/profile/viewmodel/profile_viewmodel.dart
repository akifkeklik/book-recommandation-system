import 'package:flutter/material.dart';
import '../../../core/services/local_storage_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final LocalStorageService _localStorageService = LocalStorageService();

  int _favoriteCount = 0;
  int _readCount = 0; // V6.0
  bool _isLoading = false;

  int get favoriteCount => _favoriteCount;
  int get readCount => _readCount; // V6.0
  bool get isLoading => _isLoading;

  ProfileViewModel() {
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    _isLoading = true;
    notifyListeners();

    // Load Favorites
    final favoriteIds = await _localStorageService.loadFavoriteBookIds();
    _favoriteCount = favoriteIds.length;

    // Load Read Books (V6.0)
    final readIds = await _localStorageService.loadReadBookIds();
    _readCount = readIds.length;

    _isLoading = false;
    notifyListeners();
  }
}
