/// StatCard - Reusable statistics card component
/// 
/// Displays a title, value, and optional subtitle with consistent styling.
/// Replaces duplicate implementations across Student, Faculty, and Admin modules.

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_tokens.dart';

/// A card widget for displaying statistics or summary information.
/// 
/// Features:
/// - Consistent styling across all modules
/// - Optional icon and color customization
/// - Loading state support
/// - Tap callback for interactive stats
/// - Responsive sizing
/// 
/// Usage:
/// ```dart
/// StatCard(
///   title: 'Total Students',
///   value: '1,234',
///   subtitle: '+12% from last month',
///   icon: Icons.people,
///   color: AppColors.student,
///   onTap: () => navigateToStudentsList(),
/// )
/// ```
class StatCard extends StatelessWidget {
  /// Title text displayed at the top
  final String title;

  /// Main value to display (large and prominent)
  final String value;

  /// Optional subtitle for additional context
  final String? subtitle;

  /// Optional icon to display
  final IconData? icon;

  /// Color for icon and accent elements
  final Color? color;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Whether to show loading state
  final bool isLoading;

  /// Optional trend icon (up/down arrow)
  final IconData? trendIcon;

  /// Custom trailing widget
  final Widget? trailing;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.color,
    this.onTap,
    this.isLoading = false,
    this.trendIcon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Card(
      elevation: AppElevation.sm,
      margin: EdgeInsets.all(AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.radiusMd,
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: isLoading 
              ? _buildLoadingState()
              : _buildContent(context, theme, effectiveColor),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children:  [
        Container(
          width: 80,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: AppRadius.radiusXs,
          ),
        ),
        AppSpacing.gapMd,
        Container(
          width: 120,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: AppRadius.radiusXs,
          ),
        ),
        AppSpacing.gapSm,
        Container(
          width: 100,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: AppRadius.radiusXs,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme, Color effectiveColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header row with title and icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null || trailing != null) ...[
              SizedBox(width: AppSpacing.sm),
              trailing ?? Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: effectiveColor.withOpacity(0.1),
                  borderRadius: AppRadius.radiusSm,
                ),
                child: Icon(
                  icon,
                  size: AppIconSize.sm,
                  color: effectiveColor,
                ),
              ),
            ],
          ],
        ),
        
        SizedBox(height: AppSpacing.md),

        // Main value
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // Subtitle with optional trend icon
        if (subtitle != null) ...[
          SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              if (trendIcon != null) ...[
                Icon(
                  trendIcon,
                  size: 14,
                  color: _getTrendColor(),
                ),
                SizedBox(width: AppSpacing.xs),
              ],
              Expanded(
                child: Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: trendIcon != null 
                        ? _getTrendColor() 
                        : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Color _getTrendColor() {
    if (trendIcon == Icons.trending_up) {
      return AppColors.success;
    } else if (trendIcon == Icons.trending_down) {
      return AppColors.error;
    }
    return AppColors.textSecondaryLight;
  }
}

/// Compact variant of StatCard for smaller spaces
class StatCardCompact extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  const StatCardCompact({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusSm,
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppIconSize.sm, color: effectiveColor),
              SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
