import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // V2.0: Import GoRouter
import 'package:provider/provider.dart';
import 'package:sonkitap/l10n/app_localizations.dart'; // Corrected Import
import '../viewmodel/onboarding_viewmodel.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.chooseInterests,
                style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.chooseInterestsHint,
                style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: viewModel.isLoading
                    ? const _SkeletonGrid()
                    : _CategoryGrid(viewModel: viewModel),
              ),
              const SizedBox(height: 24),
              _ContinueButton(viewModel: viewModel, l10n: l10n),
            ],
          ),
        ),
      ),
    );
  }
}

// ... (CategoryGrid and CategoryCard remain the same)

class _ContinueButton extends StatelessWidget {
  final OnboardingViewModel viewModel;
  final AppLocalizations l10n;

  const _ContinueButton({required this.viewModel, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final canContinue = viewModel.selectedCategoryIds.isNotEmpty && !viewModel.isSaving;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: !canContinue
            ? null
            : () async {
                final success = await viewModel.savePreferences();
                if (success && context.mounted) {
                  // V2.0: Use GoRouter for declarative navigation
                  context.go('/home');
                }
              },
        child: viewModel.isSaving
            ? const SizedBox(
                width: 24, height: 24, 
                child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
            : Text(l10n.continueButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ... (Other widgets remain the same)

class _CategoryGrid extends StatelessWidget {
  final OnboardingViewModel viewModel;

  const _CategoryGrid({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: viewModel.categories.length,
      itemBuilder: (context, index) {
        final category = viewModel.categories[index];
        final isSelected = viewModel.selectedCategoryIds.contains(category.id);

        return _CategoryCard(
          category: category,
          isSelected: isSelected,
          onTap: () => viewModel.toggleCategorySelection(category.id),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final dynamic category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest, // Updated surfaceVariant
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: colorScheme.primary, width: 1.5) : null,
        ),
        child: Center(
          child: Text(
            category.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5); // Updated surfaceVariant

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}
