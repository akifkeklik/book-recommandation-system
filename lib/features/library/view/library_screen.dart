import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sonkitap/l10n/app_localizations.dart'; // Corrected Import
import '../viewmodel/library_viewmodel.dart';
import '../../../core/models/book_model.dart';
import '../../../core/models/category_model.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LibraryViewModel(),
      child: const _LibraryView(),
    );
  }
}

class _LibraryView extends StatelessWidget {
  const _LibraryView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LibraryViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            _SearchBar(viewModel: viewModel),
            const SizedBox(height: 16),
            _CategoryFilters(viewModel: viewModel),
            const SizedBox(height: 16),
            Expanded(
              child: _BookList(viewModel: viewModel),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookListItem extends StatelessWidget {
  final Book book;

  const _BookListItem({required this.book});

  @override
  Widget build(BuildContext context) {
    // V3.0: Unique tag for the Hero animation.
    final heroTag = 'library-book-cover-${book.id}';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.go('/book/${book.id}', extra: heroTag);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                height: 100,
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book.coverImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 70, height: 100, color: Colors.grey[300]),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(book.author, style: Theme.of(context).textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(book.rating.toString(), style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ... (Other widgets remain the same)

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Text(
        l10n.browseLibrary,
        style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final LibraryViewModel viewModel;
  const _SearchBar({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextField(
        onChanged: (query) => viewModel.searchBooks(query),
        decoration: InputDecoration(
          hintText: l10n.searchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.6), // Updated surfaceVariant
        ),
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  final LibraryViewModel viewModel;

  const _CategoryFilters({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (viewModel.isLoading || viewModel.categories.isEmpty) {
      return const SizedBox(height: 50);
    }
    final categoriesWithAll = [Category(id: -1, name: l10n.allCategories)]..addAll(viewModel.categories);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: categoriesWithAll.length,
        itemBuilder: (context, index) {
          final category = categoriesWithAll[index];
          final isSelected = (viewModel.selectedCategoryId ?? -1) == category.id;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category.name),
              selected: isSelected,
              onSelected: (_) {
                viewModel.selectCategory(category.id == -1 ? null : category.id);
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}

class _BookList extends StatelessWidget {
  final LibraryViewModel viewModel;

  const _BookList({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (viewModel.isLoading) {
      return const _BookListSkeleton();
    }

    if (viewModel.hasError) {
      return Center(child: Text(l10n.couldNotFetchBooks));
    }

    final books = viewModel.filteredBooks;
    if (books.isEmpty) {
      return Center(child: Text(l10n.noBooksFound));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return _BookListItem(book: books[index]);
      },
    );
  }
}

class _BookListSkeleton extends StatelessWidget {
  const _BookListSkeleton();

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5); // Updated surfaceVariant
    final highlightColor = Theme.of(context).colorScheme.surface.withOpacity(0.8);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(width: 70, height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 16, width: double.infinity, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 14, width: 150, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
