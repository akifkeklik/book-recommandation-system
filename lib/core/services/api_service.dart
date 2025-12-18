import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import '../models/category_model.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5000'; // Emulator localhost

  // Fallback data in case server is down
  List<Book> _getMockBooks() {
    return [
      Book(id: 1, title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', coverImageUrl: 'https://covers.openlibrary.org/b/id/8264424-L.jpg', category: 'Fiction', rating: 4.5, popularity: 800, description: 'A novel about the American dream.'),
      Book(id: 2, title: '1984', author: 'George Orwell', coverImageUrl: 'https://covers.openlibrary.org/b/id/13093386-L.jpg', category: 'Science Fiction', rating: 4.9, popularity: 980, description: 'A dystopian novel.'),
      Book(id: 3, title: 'The Hobbit', author: 'J.R.R. Tolkien', coverImageUrl: 'https://covers.openlibrary.org/b/id/10549213-L.jpg', category: 'Fantasy', rating: 4.9, popularity: 990, description: 'Adventure of a hobbit.'),
      Book(id: 4, title: 'Sapiens', author: 'Yuval Noah Harari', coverImageUrl: 'https://covers.openlibrary.org/b/id/8259253-L.jpg', category: 'History', rating: 4.9, popularity: 970, description: 'Brief history of humankind.'),
      Book(id: 5, title: 'Atomic Habits', author: 'James Clear', coverImageUrl: 'https://covers.openlibrary.org/b/id/10526084-L.jpg', category: 'Business', rating: 4.9, popularity: 990, description: 'Build good habits.'),
    ];
  }

  Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/books'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      }
    } catch (e) {
      print("API Error (getBooks): $e. Using Mock Data.");
    }
    return _getMockBooks();
  }

  Future<List<Book>> getBooksByCategory(String categoryName) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/books/category/$categoryName'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      }
    } catch (e) {
      print("API Error (getBooksByCategory): $e");
    }
    return _getMockBooks().where((b) => b.category == categoryName).toList();
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      }
    } catch (e) {
       print("API Error (getCategories): $e");
    }
    return [Category(id: 1, name: 'Fiction'), Category(id: 2, name: 'Sci-Fi')];
  }

  Future<List<Book>> getRecommendations(int userId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/recommendations/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      }
    } catch (e) {
      print("API Error (getRecommendations): $e. Using Mock Data.");
    }
    // Return mock data if connection fails, so the UI is never empty
    return _getMockBooks(); 
  }

  Future<void> savePreferences(int userId, List<int> categoryIds) async {
    try {
      await http.post(
        Uri.parse('$_baseUrl/users/preferences'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'preferred_category_ids': categoryIds,
        }),
      );
    } catch (e) {
      print("API Error (savePreferences): $e");
    }
  }
}
