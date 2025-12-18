import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sonkitap/l10n/app_localizations.dart'; // Corrected Import

import '../../../core/models/book_model.dart';
import '../viewmodel/favorites_viewmodel.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesViewModel(),
      child: const _FavoritesView(),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FavoritesViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favorites)),
      body: RefreshIndicator(
        onRefresh: viewModel.loadFavorites,
        child: _buildBody(context, viewModel, l10n),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    FavoritesViewModel viewModel,
    AppLocalizations l10n,
  ) {
    if (viewModel.isLoading) {
      return const _FavoritesListSkeleton();
    }

    if (viewModel.hasError) {
      return Center(child: Text(l10n.couldNotLoadFavorites));
    }

    if (viewModel.favoriteBooks.isEmpty) {
      return const _EmptyFavorites();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.favoriteBooks.length,
      itemBuilder: (context, index) {
        return _FavoriteBookListItem(book: viewModel.favoriteBooks[index]);
      },
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noFavoritesYet,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noFavoritesHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _FavoriteBookListItem extends StatelessWidget {
  final Book book;

  const _FavoriteBookListItem({required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // V2.0: CORRECTED to use `push` which returns a Future, allowing .then()
          context.push('/book/${book.id}').then((_) {
            // When we return from the detail screen, refresh the list
            if (context.mounted) {
              context.read<FavoritesViewModel>().loadFavorites();
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book.coverImageUrl,
                  width: 70,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 70,
                    height: 100,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoritesListSkeleton extends StatelessWidget {
  const _FavoritesListSkeleton();

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest
        .withOpacity(0.5); // Updated surfaceVariant
    final highlightColor = Theme.of(
      context,
    ).colorScheme.surface.withOpacity(0.8);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          color: Colors.white,
                        ),
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
