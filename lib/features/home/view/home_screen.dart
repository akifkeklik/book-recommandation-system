import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sonkitap/l10n/app_localizations.dart'; 
import '../viewmodel/home_viewmodel.dart';
import '../../../core/models/book_model.dart';
import '../../../core/widgets/book_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // Standard AppBar to avoid Sliver complexity issues
      appBar: AppBar(
        title: Text(
          l10n.findNextBook, // "Sonraki Kitabını Bul"
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const CircleAvatar(
              radius: 18,
              child: Icon(Icons.person, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.fetchRecommendations,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          children: [
             // Featured Section
            _SectionHeader(title: l10n.speciallyForYou), // "Sizin İçin"
            const SizedBox(height: 16),
            _BookList(
              books: viewModel.recommendations, 
              isLoading: viewModel.isLoading,
              isLarge: true,
            ),

            const SizedBox(height: 32),

            // Popular Section
            _SectionHeader(title: l10n.popularBooks), // "Popüler"
            const SizedBox(height: 16),
            _BookList(
              books: viewModel.popularBooks, 
              isLoading: viewModel.isLoading,
              isLarge: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0), // Consistent padding
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BookList extends StatelessWidget {
  final List<Book> books;
  final bool isLoading;
  final bool isLarge;

  const _BookList({
    required this.books, 
    required this.isLoading,
    required this.isLarge,
  });

  @override
  Widget build(BuildContext context) {
    // Determine card dimensions based on "isLarge"
    final height = isLarge ? 300.0 : 260.0;
    
    if (isLoading) {
      return SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: 3,
          itemBuilder: (_, __) => _SkeletonCard(isLarge: isLarge),
        ),
      );
    }

    if (books.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text("Kitap bulunamadı.")),
      );
    }

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookCard(
            book: books[index], 
            heroPrefix: isLarge ? 'featured' : 'popular',
            isLarge: isLarge,
          );
        },
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final bool isLarge;
  const _SkeletonCard({required this.isLarge});

  @override
  Widget build(BuildContext context) {
    final width = isLarge ? 160.0 : 120.0;
    
    // Use theme colors for shimmer to adapt to dark/light mode automatically
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlightColor = Theme.of(context).colorScheme.surface;

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: isLarge ? 220 : 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),
            Container(width: width, height: 16, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: width * 0.6, height: 12, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
