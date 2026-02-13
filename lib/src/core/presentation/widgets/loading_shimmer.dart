/// LoadingShimmer - Skeleton loading component
/// 
/// Displays animated loading placeholders.

import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

/// A shimmer loading widget for skeleton screens.
/// 
/// Features:
/// - Animated shimmer effect
/// - Multiple variants (card, list, grid)
/// - Customizable count and height
/// 
/// Usage:
/// ```dart
/// LoadingShimmer.card()
/// LoadingShimmer.list(count: 5)
/// LoadingShimmer.grid(count: 6)
/// ```
class LoadingShimmer extends StatefulWidget {
  /// Height of the shimmer block
  final double height;

  /// Width of the shimmer block
  final double? width;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Number of shimmer blocks to show
  final int count;

  /// Spacing between blocks
  final double spacing;

  const LoadingShimmer({
    super.key,
    this.height = 16,
    this.width,
    this.borderRadius,
    this.count = 1,
    this.spacing = 12,
  });

  /// Loading shimmer for card layout
  factory LoadingShimmer.card({
    int count = 1,
  }) =>
      LoadingShimmer(
        height: 200,
        borderRadius: AppRadius.radiusMd,
        count: count,
        spacing: AppSpacing.sm,
      );

  /// Loading shimmer for list items
  factory LoadingShimmer.list({
    int count = 5,
  }) =>
      LoadingShimmer(
        height: 72,
        borderRadius: AppRadius.radiusSm,
        count: count,
        spacing: AppSpacing.sm,
      );

  /// Loading shimmer for small items
  factory LoadingShimmer.compact({
    int count = 3,
  }) =>
      LoadingShimmer(
        height: 40,
        borderRadius: AppRadius.radiusSm,
        count: count,
        spacing: AppSpacing.xs,
      );

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.count,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index < widget.count - 1 ? widget.spacing : 0,
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius ?? AppRadius.radiusXs,
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.grey.shade300,
                      Colors.grey.shade200,
                      Colors.grey.shade300,
                    ],
                    stops: [
                      0.0,
                      _animation.value,
                      1.0,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Grid variant of loading shimmer
class LoadingShimmerGrid extends StatelessWidget {
  final int count;
  final int crossAxisCount;

  const LoadingShimmerGrid({
    super.key,
    this.count = 6,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      children: List.generate(
        count,
        (index) => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: AppRadius.radiusMd,
          ),
        ),
      ),
    );
  }
}
