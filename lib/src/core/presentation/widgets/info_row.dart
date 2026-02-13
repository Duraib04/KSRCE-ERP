/// InfoRow - Reusable information row component
/// 
/// Displays an icon, label, and value in a consistent layout.
/// Replaces duplicate _InfoColumn implementations.

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_tokens.dart';

/// A row widget for displaying information with icon, label, and value.
/// 
/// Features:
/// - Icon + label + value layout
/// - Optional action widget
/// - Consistent spacing and styling
/// - Responsive layout
/// - Copy-to-clipboard support (optional)
/// 
/// Usage:
/// ```dart
/// InfoRow(
///   icon: Icons.email,
///   label: 'Email',
///   value: 'student@ksrce.edu',
/// )
/// ```
class InfoRow extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Label text
  final String label;

  /// Value text
  final String value;

  /// Optional color for icon
  final Color? iconColor;

  /// Optional action widget (e.g., copy button, link)
  final Widget? action;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Whether to show divider below
  final bool showDivider;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.action,
    this.onTap,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: AppRadius.radiusSm,
          child: Padding(
            padding: AppSpacing.paddingVerticalSm,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withOpacity(0.1),
                    borderRadius: AppRadius.radiusSm,
                  ),
                  child: Icon(
                    icon,
                    size: AppIconSize.sm,
                    color: effectiveIconColor,
                  ),
                ),

                SizedBox(width: AppSpacing.md),

                // Label and value
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs / 2),
                      Text(
                        value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Optional action
                if (action != null) ...[
                  SizedBox(width: AppSpacing.sm),
                  action!,
                ],
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, indent: AppIconSize.sm + AppSpacing.md * 2 + AppSpacing.sm),
      ],
    );
  }
}

/// Compact variant for horizontal layout
class InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final TextAlign textAlign;
  final Color? valueColor;

  const InfoColumn({
    super.key,
    required this.label,
    required this.value,
    this.textAlign = TextAlign.start,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : textAlign == TextAlign.end
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondaryLight,
          ),
          textAlign: textAlign,
        ),
        SizedBox(height: AppSpacing.xs / 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
          textAlign: textAlign,
        ),
      ],
    );
  }
}
