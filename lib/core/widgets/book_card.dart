import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../models/book_model.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final String heroPrefix;
  final bool isLarge;
  final int? animationIndex;

  const BookCard({
    super.key,
    required this.book,
    this.heroPrefix = 'book',
    this.isLarge = false,
    this.animationIndex,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final heroTag = '${widget.heroPrefix}-cover-${widget.book.id}';
    final width = widget.isLarge ? 160.0 : 120.0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final delay = widget.animationIndex != null
        ? Duration(milliseconds: 50 * widget.animationIndex!)
        : Duration.zero;

    Widget card = GestureDetector(
      onTap: () => context.push('/book/${widget.book.id}', extra: heroTag),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: width,
          margin: const EdgeInsets.only(right: 16.0),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -8.0 : 0.0)
            ..scale(_isHovered ? 1.02 : 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Cover with enhanced shadows
              Expanded(
                child: Hero(
                  tag: heroTag,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(0.6)
                              : theme.colorScheme.primary.withOpacity(0.25),
                          blurRadius: _isHovered ? 28 : 20,
                          offset: Offset(0, _isHovered ? 12 : 8),
                          spreadRadius: _isHovered ? 0 : -2,
                        ),
                        if (!isDark)
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.15),
                            blurRadius: _isHovered ? 36 : 28,
                            offset: const Offset(0, 6),
                          ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Enhanced book cover with cache
                          CachedNetworkImage(
                            imageUrl: widget.book.coverImageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    theme.colorScheme.primaryContainer,
                                    theme.colorScheme.secondaryContainer,
                                  ],
                                ),
                              ),
                              child: Icon(
                                Icons.auto_stories_rounded,
                                color: theme.colorScheme.primary,
                                size: 48,
                              ),
                            ),
                          ),
                          // Premium gradient overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Enhanced rating badge with glassmorphism
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFFD700),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.book.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Hover overlay effect
                          if (_isHovered)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      theme.colorScheme.primary.withOpacity(
                                        0.1,
                                      ),
                                      theme.colorScheme.primary.withOpacity(
                                        0.2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Premium Title
              Text(
                widget.book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 6),
              // Premium Author
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.animationIndex != null) {
      card = card
          .animate(delay: delay)
          .fadeIn(duration: 500.ms, curve: Curves.easeOut)
          .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
    }

    return card;
  }
}
