/// StatusBadge - Reusable status badge/chip component
/// 
/// Displays status with consistent color coding across all modules.
/// Replaces inline Chip implementations.

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/design_tokens.dart';

/// A badge widget for displaying status with semantic colors.
/// 
/// Features:
/// - Pre-configured colors for common statuses
/// - Optional dot indicator
/// - Consistent sizing and padding
/// - Uppercase styling
/// - Support for custom colors
/// 
/// Usage:
/// ```dart
/// StatusBadge.active()
/// StatusBadge.pending()
/// StatusBadge.overdue()
/// StatusBadge(label: 'Custom', color: Colors.blue)
/// ```
class StatusBadge extends StatelessWidget {
  /// Label text to display
  final String label;

  /// Background color of the badge
  final Color backgroundColor;

  /// Text color
  final Color textColor;

  /// Whether to show a dot indicator
  final bool showDot;

  /// Optional icon to display
  final IconData? icon;

  /// Size variant
  final StatusBadgeSize size;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.showDot = false,
    this.icon,
    this.size = StatusBadgeSize.medium,
  });

  // ============================================================
  // FACTORY CONSTRUCTORS FOR COMMON STATUSES
  // ============================================================

  /// Active status (green)
  factory StatusBadge.active({String? label}) => StatusBadge(
        label: label ?? 'Active',
        backgroundColor: AppColors.active.withOpacity(0.1),
        textColor: AppColors.active,
        showDot: true,
      );

  /// Inactive status (grey)
  factory StatusBadge.inactive({String? label}) => StatusBadge(
        label: label ?? 'Inactive',
        backgroundColor: AppColors.inactive.withOpacity(0.1),
        textColor: AppColors.inactive,
        showDot: true,
      );

  /// Pending status (orange)
  factory StatusBadge.pending({String? label}) => StatusBadge(
        label: label ?? 'Pending',
        backgroundColor: AppColors.pending.withOpacity(0.1),
        textColor: AppColors.pending,
        showDot: true,
      );

  /// Approved status (green)
  factory StatusBadge.approved({String? label}) => StatusBadge(
        label: label ?? 'Approved',
        backgroundColor: AppColors.approved.withOpacity(0.1),
        textColor: AppColors.approved,
        icon: Icons.check_circle,
      );

  /// Rejected status (red)
  factory StatusBadge.rejected({String? label}) => StatusBadge(
        label: label ?? 'Rejected',
        backgroundColor: AppColors.rejected.withOpacity(0.1),
        textColor: AppColors.rejected,
        icon: Icons.cancel,
      );

  /// Overdue status (red)
  factory StatusBadge.overdue({String? label}) => StatusBadge(
        label: label ?? 'Overdue',
        backgroundColor: AppColors.overdue.withOpacity(0.1),
        textColor: AppColors.overdue,
        icon: Icons.warning,
      );

  /// Completed status (green)
  factory StatusBadge.completed({String? label}) => StatusBadge(
        label: label ?? 'Completed',
        backgroundColor: AppColors.completed.withOpacity(0.1),
        textColor: AppColors.completed,
        icon: Icons.check_circle_outline,
      );

  /// In Progress status (blue)
  factory StatusBadge.inProgress({String? label}) => StatusBadge(
        label: label ?? 'In Progress',
        backgroundColor: AppColors.inProgress.withOpacity(0.1),
        textColor: AppColors.inProgress,
        showDot: true,
      );

  /// Draft status (grey)
  factory StatusBadge.draft({String? label}) => StatusBadge(
        label: label ?? 'Draft',
        backgroundColor: AppColors.draft.withOpacity(0.1),
        textColor: AppColors.draft,
      );

  // ============================================================
  // ATTENDANCE STATUSES
  // ============================================================

  /// Present status (green)
  factory StatusBadge.present({String? label}) => StatusBadge(
        label: label ?? 'Present',
        backgroundColor: AppColors.present.withOpacity(0.1),
        textColor: AppColors.present,
        icon: Icons.check,
      );

  /// Absent status (red)
  factory StatusBadge.absent({String? label}) => StatusBadge(
        label: label ?? 'Absent',
        backgroundColor: AppColors.absent.withOpacity(0.1),
        textColor: AppColors.absent,
        icon: Icons.close,
      );

  /// Late status (orange)
  factory StatusBadge.late({String? label}) => StatusBadge(
        label: label ?? 'Late',
        backgroundColor: AppColors.late.withOpacity(0.1),
        textColor: AppColors.late,
        icon: Icons.schedule,
      );

  /// On Leave status (blue)
  factory StatusBadge.onLeave({String? label}) => StatusBadge(
        label: label ?? 'On Leave',
        backgroundColor: AppColors.onLeave.withOpacity(0.1),
        textColor: AppColors.onLeave,
      );

  // ============================================================
  // PRIORITY LEVELS
  // ============================================================

  /// Critical priority (red)
  factory StatusBadge.critical({String? label}) => StatusBadge(
        label: label ?? 'Critical',
        backgroundColor: AppColors.priorityCritical.withOpacity(0.1),
        textColor: AppColors.priorityCritical,
        icon: Icons.error,
      );

  /// High priority (orange)
  factory StatusBadge.high({String? label}) => StatusBadge(
        label: label ?? 'High',
        backgroundColor: AppColors.priorityHigh.withOpacity(0.1),
        textColor: AppColors.priorityHigh,
        icon: Icons.arrow_upward,
      );

  /// Medium priority (orange)
  factory StatusBadge.medium({String? label}) => StatusBadge(
        label: label ?? 'Medium',
        backgroundColor: AppColors.priorityMedium.withOpacity(0.1),
        textColor: AppColors.priorityMedium,
      );

  /// Low priority (green)
  factory StatusBadge.low({String? label}) => StatusBadge(
        label: label ?? 'Low',
        backgroundColor: AppColors.priorityLow.withOpacity(0.1),
        textColor: AppColors.priorityLow,
        icon: Icons.arrow_downward,
      );

  // ============================================================
  // FEEDBACK TYPES
  // ============================================================

  /// Success message (green)
  factory StatusBadge.success({String? label}) => StatusBadge(
        label: label ?? 'Success',
        backgroundColor: AppColors.success.withOpacity(0.1),
        textColor: AppColors.success,
        icon: Icons.check_circle,
      );

  /// Error message (red)
  factory StatusBadge.error({String? label}) => StatusBadge(
        label: label ?? 'Error',
        backgroundColor: AppColors.error.withOpacity(0.1),
        textColor: AppColors.error,
        icon: Icons.error,
      );

  /// Warning message (orange)
  factory StatusBadge.warning({String? label}) => StatusBadge(
        label: label ?? 'Warning',
        backgroundColor: AppColors.warning.withOpacity(0.1),
        textColor: AppColors.warning,
        icon: Icons.warning,
      );

  /// Info message (blue)
  factory StatusBadge.info({String? label}) => StatusBadge(
        label: label ?? 'Info',
        backgroundColor: AppColors.info.withOpacity(0.1),
        textColor: AppColors.info,
        icon: Icons.info,
      );

  @override
  Widget build(BuildContext context) {
    final (fontSize, height, iconSize, padding) = _getSizeParams();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.radiusFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: AppSpacing.xs),
          ],
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize,
              color: textColor,
            ),
            SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: height,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  (double, double, double, EdgeInsets) _getSizeParams() {
    switch (size) {
      case StatusBadgeSize.small:
        return (
          10,
          1.2,
          12.0,
          EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs / 2,
          ),
        );
      case StatusBadgeSize.medium:
        return (
          12,
          1.2,
          14.0,
          EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
        );
      case StatusBadgeSize.large:
        return (
          14,
          1.2,
          16.0,
          EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        );
    }
  }
}

/// Size variants for StatusBadge
enum StatusBadgeSize {
  small,
  medium,
  large,
}
