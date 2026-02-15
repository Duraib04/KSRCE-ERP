/// PageHeader - Consistent page header component
/// 
/// Displays page title, subtitle, and action buttons.

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_tokens.dart';

/// A consistent header for pages with title and actions.
/// 
/// Features:
/// - Title and optional subtitle
/// - Action buttons
/// - Optional back button
/// - Breadcrumbs support
/// - Consistent spacing
/// 
/// Usage:
/// ```dart
/// PageHeader(
///   title: 'Students',
///   subtitle: '1,234 total students',
///   actions: [
///     IconButton(icon: Icon(Icons.filter_list), onPressed: () {}),
///     ElevatedButton(child: Text('Add Student'), onPressed: () {}),
///   ],
/// )
/// ```
class PageHeader extends StatelessWidget {
  /// Page title
  final String title;

  /// Optional subtitle
  final String? subtitle;

  /// Action widgets (buttons, icons, etc.)
  final List<Widget>? actions;

  /// Whether to show back button
  final bool showBackButton;

  /// Custom back button callback
  final VoidCallback? onBack;

  /// Optional breadcrumb trail
  final List<String>? breadcrumbs;

  /// Background color
  final Color? backgroundColor;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = false,
    this.onBack,
    this.breadcrumbs,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: backgroundColor != null
          ? BoxDecoration(
              color: backgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumbs
          if (breadcrumbs != null && breadcrumbs!.isNotEmpty) ...[
            _buildBreadcrumbs(theme),
            SizedBox(height: AppSpacing.sm),
          ],

          // Main header row
          Row(
            children: [
              // Back button
              if (showBackButton) ...[
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                ),
                SizedBox(width: AppSpacing.sm),
              ],

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: AppSpacing.xs / 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              if (actions != null && actions!.isNotEmpty) ...[
                SizedBox(width: AppSpacing.md),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildActions(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs(ThemeData theme) {
    return Wrap(
      spacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < breadcrumbs!.length; i++) ...[
          if (i > 0)
            Icon(
              Icons.chevron_right,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          Text(
            breadcrumbs![i],
            style: theme.textTheme.bodySmall?.copyWith(
              color: i == breadcrumbs!.length - 1
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: i == breadcrumbs!.length - 1
                ? FontWeight.w600
                : FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildActions() {
    final widgets = <Widget>[];
    for (int i = 0; i < actions!.length; i++) {
      if (i > 0) {
        widgets.add(SizedBox(width: AppSpacing.sm));
      }
      widgets.add(actions![i]);
    }
    return widgets;
  }
}

/// Compact variant for smaller screens
class PageHeaderCompact extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const PageHeaderCompact({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
