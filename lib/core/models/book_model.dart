
class Book {
  final int id;
  final String title;
  final String author;
  final String coverImageUrl;
  final String category;
  final double rating;
  final int popularity;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImageUrl,
    required this.category,
    required this.rating,
    required this.popularity,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      coverImageUrl: json['cover_image_url'],
      category: json['category'],
      rating: json['rating'].toDouble(),
      popularity: json['popularity'],
      description: json['description'],
    );
  }
}
