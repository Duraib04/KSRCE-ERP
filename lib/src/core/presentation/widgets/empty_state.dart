/// EmptyState - Reusable empty state component
/// 
/// Displays when lists or content areas have no data.

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_tokens.dart';

/// A widget to display when content is empty.
/// 
/// Features:
/// - Icon, title, and message
/// - Optional action button
/// - Consistent styling
/// - Customizable colors
/// 
/// Usage:
/// ```dart
/// EmptyState(
///   icon: Icons.assignment,
///   title: 'No Assignments',
///   message: 'You don't have any assignments yet.',
///   actionLabel: 'Refresh',
///   onAction: () => loadAssignments(),
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Title text
  final String title;

  /// Descriptive message
  final String message;

  /// Optional action button label
  final String? actionLabel;

  /// Optional action callback
  final VoidCallback? onAction;

  /// Icon color
  final Color? iconColor;

  /// Whether to show in compact mode (smaller)
  final bool compact;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.compact = false,
  });

  // Common empty states
  factory EmptyState.noData({
    String title = 'No Data',
    String message = 'There is no data to display.',
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      EmptyState(
        icon: Icons.inbox,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  factory EmptyState.noResults({
    String title = 'No Results',
    String message = 'Try adjusting your filters or search terms.',
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      EmptyState(
        icon: Icons.search_off,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  factory EmptyState.noNotifications({
    String title = 'No Notifications',
    String message = 'You are all caught up!',
  }) =>
      EmptyState(
        icon: Icons.notifications_none,
        title: title,
        message: message,
        iconColor: AppColors.success,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? AppColors.textSecondaryLight;
    final iconSize = compact ? AppIconSize.xl : AppIconSize.xxl;
    final verticalPadding = compact ? AppSpacing.xl : AppSpacing.xxxl;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: verticalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: effectiveIconColor,
            ),
            SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
            Text(
              title,
              style: (compact ? theme.textTheme.titleMedium : theme.textTheme.titleLarge)
                  ?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
