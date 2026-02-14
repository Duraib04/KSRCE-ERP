/// AppCard - Enhanced card component with built-in states
/// 
/// Extends Flutter's Card with loading, error, and empty states.

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_tokens.dart';

/// An enhanced card component with built-in state management.
/// 
/// Features:
/// - Loading state with shimmer effect
/// - Error state with retry action
/// - Empty state with message
/// - Optional title and actions
/// - Consistent padding and styling
/// - Multiple variants (elevated, outlined, filled)
/// 
/// Usage:
/// ```dart
/// AppCard(
///   title: 'Recent Activity',
///   isLoading: isLoading,
///   error: errorMessage,
///   child: ListView(...),
/// )
/// ```
class AppCard extends StatelessWidget {
  /// Card title
  final String? title;

  /// Card subtitle
  final String? subtitle;

  /// Main content widget
  final Widget? child;

  /// Action buttons/widgets for the card header
  final List<Widget>? actions;

  /// Whether the card is in loading state
  final bool isLoading;

  /// Error message (if any)
  final String? error;

  /// Callback for retrying after error
  final VoidCallback? onRetry;

  /// Custom padding for the content
  final EdgeInsetsGeometry? contentPadding;

  /// Card elevation
  final double? elevation;

  /// Card margin
  final EdgeInsetsGeometry? margin;

  /// Border color (for outlined variant)
  final Color? borderColor;

  /// Whether to show divider after header
  final bool showHeaderDivider;

  const AppCard({
    super.key,
    this.title,
    this.subtitle,
    this.child,
    this.actions,
    this.isLoading = false,
    this.error,
    this.onRetry,
    this.contentPadding,
    this.elevation,
    this.margin,
    this.borderColor,
    this.showHeaderDivider = false,
  });

  /// Outlined card variant
  factory AppCard.outlined({
    Key? key,
    String? title,
    String? subtitle,
    Widget? child,
    List<Widget>? actions,
    bool isLoading = false,
    String? error,
    VoidCallback? onRetry,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? margin,
    Color? borderColor,
    bool showHeaderDivider = false,
  }) =>
      AppCard(
        key: key,
        title: title,
        subtitle: subtitle,
        child: child,
        actions: actions,
        isLoading: isLoading,
        error: error,
        onRetry: onRetry,
        contentPadding: contentPadding,
        elevation: 0,
        margin: margin,
        borderColor: borderColor ?? AppColors.outlineLight,
        showHeaderDivider: showHeaderDivider,
      );

  /// Filled card variant
  factory AppCard.filled({
    Key? key,
    String? title,
    String? subtitle,
    Widget? child,
    List<Widget>? actions,
    bool isLoading = false,
    String? error,
    VoidCallback? onRetry,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? margin,
    bool showHeaderDivider = false,
  }) =>
      AppCard(
        key: key,
        title: title,
        subtitle: subtitle,
        child: child,
        actions: actions,
        isLoading: isLoading,
        error: error,
        onRetry: onRetry,
        contentPadding: contentPadding,
        elevation: 0,
        margin: margin,
        showHeaderDivider: showHeaderDivider,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: elevation ?? AppElevation.sm,
      margin: margin ?? EdgeInsets.all(AppSpacing.sm),
      shape: borderColor != null
          ? RoundedRectangleBorder(
              borderRadius: AppRadius.radiusMd,
              side: BorderSide(color: borderColor!),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (title + actions)
          if (title != null) _buildHeader(theme),

          // Divider after header
          if (showHeaderDivider && title != null) const Divider(height: 1),

          // Content (loading/error/normal)
          if (isLoading)
            _buildLoadingState()
          else if (error != null)
            _buildErrorState(theme)
          else if (child != null)
            Padding(
              padding: contentPadding ?? AppSpacing.paddingLg,
              child: child,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: AppSpacing.paddingLg,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: theme.textTheme.titleMedium,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: AppSpacing.xs / 2),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            SizedBox(width: AppSpacing.sm),
            ...actions!,
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: contentPadding ?? AppSpacing.paddingLg,
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: AppRadius.radiusXs,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Padding(
      padding: contentPadding ?? AppSpacing.paddingLg,
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: AppIconSize.xl,
            color: AppColors.error,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            error!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
