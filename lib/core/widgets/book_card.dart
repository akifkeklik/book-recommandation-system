import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/book_model.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final String heroPrefix;
  final bool isLarge; // Option for larger cards
  final int? animationIndex; // For staggered animations

  const BookCard({
    super.key, 
    required this.book, 
    this.heroPrefix = 'book',
    this.isLarge = false,
    this.animationIndex,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = '$heroPrefix-cover-${book.id}';
    final width = isLarge ? 160.0 : 120.0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Calculate stagger delay based on index
    final delay = animationIndex != null 
        ? Duration(milliseconds: 50 * animationIndex!) 
        : Duration.zero;
    
    Widget card = GestureDetector(
      onTap: () => context.push('/book/${book.id}', extra: heroTag),
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image with Glassmorphism shadow
            Expanded(
              child: Hero(
                tag: heroTag,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      // Primary shadow
                      BoxShadow(
                        color: isDark 
                            ? Colors.black.withOpacity(0.5)
                            : theme.colorScheme.primary.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                        spreadRadius: -2,
                      ),
                      // Subtle glow effect
                      if (!isDark)
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          blurRadius: 24,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Book cover image
                        Image.network(
                          book.coverImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.book_rounded,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 40,
                              ),
                            );
                          },
                        ),
                        // Subtle gradient overlay for text readability
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Rating badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  book.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
              style: theme.textTheme.titleSmall?.copyWith(
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
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );

    // Apply entrance animation if index is provided
    if (animationIndex != null) {
      card = card
          .animate(delay: delay)
          .fadeIn(duration: 400.ms)
          .slideX(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
    }

    return card;
  }
}

