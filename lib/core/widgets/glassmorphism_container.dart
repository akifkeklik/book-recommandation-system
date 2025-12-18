import 'dart:ui';
import 'package:flutter/material.dart';

/// A reusable glassmorphism container with frosted glass effect.
/// Uses BackdropFilter for blur and gradient border for premium look.
class GlassmorphismContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const GlassmorphismContainer({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    
    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Glass effect background
            color: isDark
                ? Colors.white.withOpacity(opacity)
                : Colors.white.withOpacity(opacity + 0.4),
            borderRadius: effectiveBorderRadius,
            // Subtle gradient border
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
            // Soft shadow for depth
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A more colorful glassmorphism variant with gradient overlay
class GradientGlassContainer extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const GradientGlassContainer({
    super.key,
    required this.child,
    this.gradientColors,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColors = gradientColors ?? [
      theme.colorScheme.primary.withOpacity(0.1),
      theme.colorScheme.secondary.withOpacity(0.05),
    ];
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: effectiveColors,
            ),
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
