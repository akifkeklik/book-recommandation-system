import 'dart:ui';

import 'package:flutter/material.dart';

/// Premium glassmorphic card widget
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Border? border;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blur = 10,
    this.opacity = 0.1,
    this.padding,
    this.margin,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border:
            border ??
            Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(opacity),
                  Colors.white.withOpacity(opacity * 0.5),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Premium gradient background
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackground({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: begin, end: end),
      ),
      child: child,
    );
  }
}

/// Premium shimmer effect
class PremiumShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const PremiumShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.grey[800]!, Colors.grey[700]!, Colors.grey[800]!]
              : [Colors.grey[300]!, Colors.grey[200]!, Colors.grey[300]!],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

/// Premium animated container with hover effect
class PremiumContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final List<BoxShadow>? boxShadow;

  const PremiumContainer({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.color,
    this.boxShadow,
  });

  @override
  State<PremiumContainer> createState() => _PremiumContainerState();
}

class _PremiumContainerState extends State<PremiumContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: widget.padding,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: widget.color ?? Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.boxShadow,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Premium badge widget
class PremiumBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const PremiumBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (backgroundColor ?? theme.colorScheme.primary).withOpacity(
              0.3,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? theme.colorScheme.onPrimaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Premium divider with gradient
class GradientDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final List<Color>? colors;

  const GradientDivider({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              colors ??
              [
                theme.colorScheme.primary.withOpacity(0.1),
                theme.colorScheme.primary.withOpacity(0.3),
                theme.colorScheme.primary.withOpacity(0.1),
              ],
        ),
      ),
    );
  }
}
