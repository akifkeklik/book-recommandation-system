import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// An animated empty state widget with customizable message and icon.
/// Uses flutter_animate for smooth entrance animations.
/// Note: Lottie animations can be added when JSON files are available.
class AnimatedEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const AnimatedEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.search_off_rounded,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Icon with pulse effect
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.05, 1.05),
                  duration: 1500.ms,
                  curve: Curves.easeInOut,
                ),
            
            const SizedBox(height: 24),
            
            // Title with fade-in
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
            
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
            
            if (onActionPressed != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
            ],
          ],
        ),
      ),
    );
  }
}

/// A loading state with animated shimmer effect
class AnimatedLoadingState extends StatelessWidget {
  final String? message;

  const AnimatedLoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loading indicator
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: theme.colorScheme.primary,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: 1000.ms),
          
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .fadeIn(duration: 800.ms)
                .then()
                .fadeOut(duration: 800.ms),
          ],
        ],
      ),
    );
  }
}
