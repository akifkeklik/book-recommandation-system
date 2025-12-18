import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sonkitap/l10n/app_localizations.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/models/book_model.dart';
import '../../../core/widgets/book_card.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../viewmodel/book_detail_viewmodel.dart';

class BookDetailScreen extends StatelessWidget {
  final int bookId;
  final String? heroTag;

  const BookDetailScreen({super.key, required this.bookId, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookDetailViewModel(bookId: bookId),
      child: _BookDetailView(heroTag: heroTag),
    );
  }
}

class _BookDetailView extends StatelessWidget {
  final String? heroTag;
  const _BookDetailView({this.heroTag});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<BookDetailViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: viewModel.isLoading
          ? const _BookDetailSkeleton()
          : viewModel.hasError || viewModel.book == null
          ? Center(child: Text(l10n.couldNotLoadBookDetails))
          : _BookDetails(book: viewModel.book!, heroTag: heroTag),
    );
  }
}

class _BookDetails extends StatelessWidget {
  final Book book;
  final String? heroTag;

  const _BookDetails({required this.book, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<BookDetailViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 450.0,
          pinned: true,
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.5),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Hero Image with Cache
                Hero(
                  tag: heroTag ?? 'book-cover-${book.id}',
                  child: CachedNetworkImage(
                    imageUrl: book.coverImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                        theme.colorScheme.surface,
                      ],
                      stops: const [0.0, 0.4, 0.8, 1.0],
                    ),
                  ),
                ),
                // Glassmorphic Title Card at Bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.byAuthor(book.author),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: viewModel.isFavorite
                    ? Colors.red.withOpacity(0.9)
                    : Colors.black.withOpacity(0.5),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: viewModel.isFavorite
                        ? Colors.red.withOpacity(0.5)
                        : Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  viewModel.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () => viewModel.toggleFavorite(),
                tooltip: l10n.toggleFavorite,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Premium Info Cards
                _InfoRow(book: book, l10n: l10n)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 500.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 32),
                // Description Section with Glass Card
                GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.getGradient(
                                    AppThemeColor.deepPurple,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.description_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.description,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            book.description,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.7,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 500.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 32),
                _ActionButtons(viewModel: viewModel, l10n: l10n),
              ],
            ),
          ),
        ),
        if (viewModel.relatedBooks.isNotEmpty)
          SliverToBoxAdapter(
            child: _RelatedBooks(books: viewModel.relatedBooks, l10n: l10n),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final BookDetailViewModel viewModel;
  final AppLocalizations l10n;
  const _ActionButtons({required this.viewModel, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRead = viewModel.isRead;

    return Row(
      children: [
        Expanded(
          child:
              Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: OutlinedButton.icon(
                      icon: Icon(
                        viewModel.isFavorite
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                      ),
                      label: Text(l10n.myList),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        viewModel.toggleFavorite();
                        _showPremiumSnackBar(
                          context,
                          viewModel.isFavorite
                              ? l10n.addedToFavorites
                              : l10n.removedFromFavorites,
                          viewModel.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          theme.colorScheme.primary,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 500.ms)
                  .slideX(begin: -0.2, end: 0)
                  .scale(begin: const Offset(0.8, 0.8)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child:
              Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: isRead
                          ? LinearGradient(
                              colors: [
                                theme.colorScheme.tertiary,
                                theme.colorScheme.tertiary.withOpacity(0.8),
                              ],
                            )
                          : AppTheme.getGradient(AppThemeColor.deepPurple),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isRead
                                      ? theme.colorScheme.tertiary
                                      : theme.colorScheme.primary)
                                  .withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: FilledButton.icon(
                      icon: Icon(
                        isRead
                            ? Icons.check_circle_rounded
                            : Icons.auto_stories_rounded,
                      ),
                      label: Text(isRead ? l10n.read : l10n.read),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        viewModel.toggleRead();
                        _showPremiumSnackBar(
                          context,
                          viewModel.isRead
                              ? l10n.markedAsRead
                              : l10n.markedAsUnread,
                          viewModel.isRead
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          theme.colorScheme.tertiary,
                        );
                      },
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 500.ms)
                  .slideX(begin: 0.2, end: 0)
                  .scale(begin: const Offset(0.8, 0.8)),
        ),
      ],
    );
  }
}

void _showPremiumSnackBar(
  BuildContext context,
  String message,
  IconData icon,
  Color color,
) {
  final theme = Theme.of(context);
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

class _RelatedBooks extends StatelessWidget {
  final List<Book> books;
  final AppLocalizations l10n;
  const _RelatedBooks({required this.books, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            l10n.youMightAlsoLike,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemBuilder: (context, index) {
              return BookCard(book: books[index], heroPrefix: 'detail');
            },
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final Book book;
  final AppLocalizations l10n;

  const _InfoRow({required this.book, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InfoChip(
          icon: Icons.star_rounded,
          label: l10n.rating,
          value: book.rating.toString(),
        ),
        const SizedBox(width: 12),
        _InfoChip(
          icon: Icons.trending_up_rounded,
          label: l10n.popularity,
          value: book.popularity.toString(),
        ),
        const SizedBox(width: 12),
        _InfoChip(
          icon: Icons.category_rounded,
          label: l10n.category,
          value: book.category,
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppTheme.getGradient(AppThemeColor.deepPurple),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookDetailSkeleton extends StatelessWidget {
  const _BookDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(
      context,
    ).colorScheme.surfaceContainerHighest.withOpacity(0.5);

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          backgroundColor: color,
          leading: const BackButton(),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 30, width: 250, color: color),
                const SizedBox(height: 12),
                Container(height: 20, width: 150, color: color),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    3,
                    (_) => Container(height: 60, width: 80, color: color),
                  ),
                ),
                const SizedBox(height: 32),
                Container(height: 24, width: 180, color: color),
                const SizedBox(height: 16),
                Container(height: 100, width: double.infinity, color: color),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
