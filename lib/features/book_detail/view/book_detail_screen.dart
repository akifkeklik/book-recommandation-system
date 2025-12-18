import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sonkitap/l10n/app_localizations.dart'; // Corrected Import
import '../viewmodel/book_detail_viewmodel.dart';
import '../../../core/models/book_model.dart';
import '../../../core/widgets/book_card.dart'; // Correctly imported shared widget

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
          expandedHeight: 400.0,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(), // Works with go_router
            style: IconButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.3)),
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(book.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            centerTitle: true,
            background: Hero(
              tag: heroTag ?? 'book-cover-${book.id}',
              child: Image.network(book.coverImageUrl, fit: BoxFit.cover, color: Colors.black.withOpacity(0.4), colorBlendMode: BlendMode.darken),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(viewModel.isFavorite ? Icons.favorite : Icons.favorite_border, color: viewModel.isFavorite ? Colors.red.shade400 : Colors.white),
              onPressed: () => viewModel.toggleFavorite(),
              tooltip: l10n.toggleFavorite,
              style: IconButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.3)),
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
                Text(book.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(l10n.byAuthor(book.author), style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                _InfoRow(book: book, l10n: l10n),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(l10n.description, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(book.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
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
          child: OutlinedButton.icon(
            icon: Icon(viewModel.isFavorite ? Icons.check : Icons.add),
            label: Text(l10n.myList),
            onPressed: () => viewModel.toggleFavorite(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton.icon(
            icon: Icon(isRead ? Icons.check_circle : Icons.book_online),
            label: Text(isRead ? l10n.read : l10n.read), // Reuse "Read" string, or add "Mark as Read"
            style: FilledButton.styleFrom(
              backgroundColor: isRead ? theme.colorScheme.tertiary : theme.colorScheme.primary,
            ),
            onPressed: () => viewModel.toggleRead(),
          ),
        ),
      ],
    );
  }
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
          child: Text(l10n.youMightAlsoLike, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _InfoChip(icon: Icons.star, label: l10n.rating, value: book.rating.toString()),
        _InfoChip(icon: Icons.trending_up, label: l10n.popularity, value: book.popularity.toString()),
        _InfoChip(icon: Icons.category, label: l10n.category, value: book.category),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 28),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _BookDetailSkeleton extends StatelessWidget {
  const _BookDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5);

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(expandedHeight: 400, backgroundColor: color, leading: const BackButton()),
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
                  children: List.generate(3, (_) => Container(height: 60, width: 80, color: color)),
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
