/// ErrorState - Reusable error state component
/// 
/// Displays when an error occurs with retry capability.

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_tokens.dart';

/// A widget to display error states with retry functionality.
/// 
/// Features:
/// - Error icon and message
/// - Retry button
/// - Optional detailed error text
/// - Consistent styling
/// 
/// Usage:
/// ```dart
/// ErrorState(
///   message: 'Failed to load data',
///   onRetry: () => loadData(),
/// )
/// ```
class ErrorState extends StatelessWidget {
  /// Error message to display
  final String message;

  /// Callback for retry action
  final VoidCallback onRetry;

  /// Optional detailed error information
  final String? details;

  /// Whether to show in compact mode
  final bool compact;

  /// Custom icon
  final IconData? icon;

  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.details,
    this.compact = false,
    this.icon,
  });

  // Common error states
  factory ErrorState.network({
    required VoidCallback onRetry,
    String? details,
  }) =>
      ErrorState(
        message: 'Network Error',
        onRetry: onRetry,
        details: details ?? 'Please check your internet connection and try again.',
        icon: Icons.wifi_off,
      );

  factory ErrorState.serverError({
    required VoidCallback onRetry,
    String? details,
  }) =>
      ErrorState(
        message: 'Server Error',
        onRetry: onRetry,
        details: details ?? 'Something went wrong on our end. Please try again later.',
        icon: Icons.error_outline,
      );

  factory ErrorState.notFound({
    required VoidCallback onRetry,
  }) =>
      ErrorState(
        message: 'Not Found',
        onRetry: onRetry,
        details: 'The requested resource could not be found.',
        icon: Icons.search_off,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              icon ?? Icons.error_outline,
              size: iconSize,
              color: AppColors.error,
            ),
            SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
            Text(
              message,
              style: (compact ? theme.textTheme.titleMedium : theme.textTheme.titleLarge)
                  ?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
              Text(
                details!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
