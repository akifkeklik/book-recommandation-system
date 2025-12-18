class User {
  final int id;
  final List<int> preferredCategoryIds;

  User({
    required this.id,
    required this.preferredCategoryIds,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      preferredCategoryIds: List<int>.from(json['preferred_category_ids']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'preferred_category_ids': preferredCategoryIds,
    };
  }
}
