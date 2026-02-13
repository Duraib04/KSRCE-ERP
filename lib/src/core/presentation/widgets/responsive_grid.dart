/// ResponsiveGrid - Responsive grid layout component
/// 
/// Automatically adjusts column count based on screen width.

import 'package:flutter/material.dart';
import '../../theme/design_tokens.dart';

/// A responsive grid that adapts column count based on screen width.
/// 
/// Features:
/// - Automatic column calculation
/// - Breakpoint-based responsive design
/// - Configurable minimum item width
/// - Consistent spacing
/// 
/// Usage:
/// ```dart
/// ResponsiveGrid(
///   minItemWidth: 200,
///   children: [
///     Card(...),
///     Card(...),
///   ],
/// )
/// ```
class ResponsiveGrid extends StatelessWidget {
  /// Child widgets to display in grid
  final List<Widget> children;

  /// Minimum width for each grid item (used to calculate columns)
  final double minItemWidth;

  /// Spacing between grid items
  final double spacing;

  /// Aspect ratio of grid items (width / height)
  final double? childAspectRatio;

  /// Whether the grid should shrink wrap
  final bool shrinkWrap;

  /// Scroll physics
  final ScrollPhysics? physics;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 300,
    this.spacing = 12,
    this.childAspectRatio,
    this.shrinkWrap = false,
    this.physics,
  });

  int _calculateCrossAxisCount(double width) {
    // Calculate how many items can fit based on minimum width
    int count = (width / minItemWidth).floor();
    
    // Ensure at least 1 column
    if (count < 1) count = 1;
    
    // Apply breakpoint logic for better UX
    if (width < AppBreakpoint.tablet) {
      return 1; // Mobile: 1 column
    } else if (width < AppBreakpoint.desktop) {
      return count > 2 ? 2 : count; // Tablet: max 2 columns
    } else if (width < AppBreakpoint.desktopLarge) {
      return count > 3 ? 3 : count; // Small desktop: max 3 columns
    } else {
      return count > 4 ? 4 : count; // Large desktop: max 4 columns
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);
        
        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: shrinkWrap,
          physics: physics,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: childAspectRatio ?? _getDefaultAspectRatio(crossAxisCount),
          children: children,
        );
      },
    );
  }

  double _getDefaultAspectRatio(int columns) {
    // Adjust aspect ratio based on number of columns for better appearance
    if (columns == 1) return 2.5;  // Wider cards on mobile
    if (columns == 2) return 1.5;  // Slightly wider on tablet
    return 1.2;  // More square on desktop
  }
}

/// Responsive grid that wraps items instead of scrolling
class ResponsiveWrap extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;

  const ResponsiveWrap({
    super.key,
    required this.children,
    this.spacing = 12,
    this.runSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children,
    );
  }
}
