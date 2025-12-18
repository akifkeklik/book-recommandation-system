import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sonkitap/l10n/app_localizations.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/models/book_model.dart';
import '../../../core/widgets/animated_empty_state.dart';
import '../../../core/widgets/book_card.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../viewmodel/home_viewmodel.dart';

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
      extendBodyBehindAppBar: false,
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.findNextBook,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Premium Kitap Deneyimi',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [_ProfileButton(), const SizedBox(width: 12)],
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.fetchRecommendations,
        child: CustomScrollView(
          slivers: [
            // Welcome Banner
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                decoration: BoxDecoration(
                  gradient: AppTheme.getGradient(AppThemeColor.deepPurple),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppTheme.premiumShadow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📚 Kişisel Kitap Asistanın',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Zevkine uygun kitapları keşfet',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white.withOpacity(0.8),
                        size: 48,
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
            ),

            // Search Bar (Glassmorphic - Optimized)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  borderRadius: 16,
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: viewModel.searchBooks,
                          decoration: InputDecoration(
                            hintText: 'Kitap veya yazar ara...',
                            hintStyle: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withOpacity(0.6),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                          ),
                          style: theme.textTheme.bodyMedium,
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                      if (viewModel.searchQuery.isNotEmpty)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: viewModel.clearSearch,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.clear,
                                size: 18,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 4),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Filtre özelliği yakında...'),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Filtre',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
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

            // Search Results
            if (viewModel.searchQuery.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Text(
                    viewModel.searchResults.isEmpty
                        ? 'Sonuç bulunamadı'
                        : '${viewModel.searchResults.length} sonuç bulundu',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            if (viewModel.searchQuery.isNotEmpty &&
                viewModel.searchResults.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: viewModel.searchResults.length,
                    itemBuilder: (context, index) {
                      return BookCard(
                        book: viewModel.searchResults[index],
                        heroPrefix: 'search',
                        animationIndex: index,
                      );
                    },
                  ),
                ),
              ),
            if (viewModel.searchQuery.isNotEmpty)
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Featured Section
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: l10n.speciallyForYou,
                subtitle: 'Senin için özenle seçildi',
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: _BookList(
                books: viewModel.recommendations,
                isLoading: viewModel.isLoading,
                isLarge: true,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Popular Section
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: l10n.popularBooks,
                subtitle: 'En çok okunan kitaplar',
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: _BookList(
                books: viewModel.popularBooks,
                isLoading: viewModel.isLoading,
                isLarge: false,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatefulWidget {
  final String title;
  final String? subtitle;

  const _SectionHeader({required this.title, this.subtitle});

  @override
  State<_SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<_SectionHeader> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push('/library');
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? theme.colorScheme.primary.withOpacity(0.15)
                        : theme.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _isHovered
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
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
      return SizedBox(
        height: 150,
        child: AnimatedEmptyState(
          title: 'Kitap bulunamadı',
          subtitle: 'Henüz bu kategoride kitap yok',
          icon: Icons.library_books_outlined,
        ),
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
            animationIndex: index,
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

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumShimmer(
            width: width,
            height: isLarge ? 220 : 160,
            borderRadius: 20,
          ),
          const SizedBox(height: 12),
          PremiumShimmer(width: width, height: 16, borderRadius: 8),
          const SizedBox(height: 8),
          PremiumShimmer(width: width * 0.6, height: 12, borderRadius: 8),
        ],
      ).animate().fadeIn(delay: 100.ms),
    );
  }
}

class _ProfileButton extends StatefulWidget {
  const _ProfileButton();

  @override
  State<_ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<_ProfileButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            context.go('/profile');
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered
                    ? theme.colorScheme.primary.withOpacity(0.3)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              color: _isHovered
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
