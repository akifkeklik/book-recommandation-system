import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/book_model.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final String heroPrefix;
  final bool isLarge; // New: Option for larger cards

  const BookCard({
    super.key, 
    required this.book, 
    this.heroPrefix = 'book',
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = '$heroPrefix-cover-${book.id}';
    final width = isLarge ? 160.0 : 120.0;
    
    return GestureDetector(
      onTap: () => context.push('/book/${book.id}', extra: heroTag), // FIXED: Uses push for history stack
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 16.0),
        color: Colors.transparent, // Hit test behavior
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Expanded(
              child: Hero(
                tag: heroTag,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(book.coverImageUrl),
                      fit: BoxFit.cover,
                      onError: (_, __) {}, // Handled by builder if needed
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book.coverImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.book, color: Colors.white24),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            // Author
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
