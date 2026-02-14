/// Color system for the KSRCE ERP application.
/// 
/// Defines semantic colors, status colors, and module-specific colors
/// for consistent visual design across the application.

import 'package:flutter/material.dart';

/// Application color palette with semantic meaning.
/// 
/// Usage:
/// ```dart
/// Container(
///   color: AppColors.success,
///   child: Text('Success!'),
/// )
/// ```
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ============================================================
  // KSRCE OFFICIAL BRAND COLORS
  // ============================================================

  /// Primary Academic Blue - Core brand color
  /// Used for: AppBar, Sidebar, Primary buttons, Active navigation
  static const Color primaryBlue = Color(0xFF0B3D91);

  /// Secondary Blue - Light variant for interactions
  /// Used for: Hover states, Selected tabs, Icons
  static const Color secondaryBlue = Color(0xFF1F5FBF);

  /// Accent Gold - Premium highlight color
  /// Used for: Highlights, Notification badges, Important buttons
  static const Color accentGold = Color(0xFFF4B400);

  /// Background color - Clean professional ERP background
  static const Color backgroundLight = Color(0xFFF5F7FA);

  /// Primary text color
  static const Color textPrimaryLight = Color(0xFF1A1A1A);

  /// Text on blue backgrounds
  static const Color textOnBlue = Color(0xFFFFFFFF);

  // ============================================================
  // SEMANTIC COLORS - For feedback and status indication
  // ============================================================

  /// Success color - Used for positive actions, confirmations
  /// Light mode: Green 600
  static const Color success = Color(0xFF43A047);
  static const Color successLight = Color(0xFF76D275);
  static const Color successDark = Color(0xFF2E7D32);

  /// Error color - Used for errors, deletions, critical warnings
  /// Light mode: Red 600
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFC62828);

  /// Warning color - Used for warnings, cautions
  /// Light mode: Orange 600
  static const Color warning = Color(0xFFFB8C00);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFEF6C00);

  /// Info color - Used for informational messages (kept for compatibility)
  /// Light mode: Blue 600
  static const Color info = Color(0xFF1E88E5);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1565C0);

  // ============================================================
  // MODULE COLORS - For visual distinction between modules
  // ============================================================

  /// Student module primary color - Uses KSRCE Primary Blue
  static const Color student = Color(0xFF0B3D91); // KSRCE Primary Blue
  static const Color studentLight = Color(0xFF1F5FBF); // KSRCE Secondary Blue
  static const Color studentDark = Color(0xFF062651);

  /// Faculty module primary color
  static const Color faculty = Color(0xFF9C27B0); // Purple 500
  static const Color facultyLight = Color(0xFFBA68C8);
  static const Color facultyDark = Color(0xFF7B1FA2);

  /// Admin module primary color
  static const Color admin = Color(0xFFFF5722); // Deep Orange 500
  static const Color adminLight = Color(0xFFFF8A65);
  static const Color adminDark = Color(0xFFE64A19);

  // ============================================================
  // STATUS COLORS - For various entity states
  // ============================================================

  /// Active status - Entity is currently active/enabled
  static const Color active = Color(0xFF4CAF50); // Green 500
  
  /// Inactive status - Entity is inactive/disabled
  static const Color inactive = Color(0xFF9E9E9E); // Grey 500
  
  /// Pending status - Awaiting action or approval
  static const Color pending = Color(0xFFFF9800); // Orange 500
  
  /// Approved status - Successfully approved
  static const Color approved = Color(0xFF43A047); // Green 600
  
  /// Rejected status - Rejected or declined
  static const Color rejected = Color(0xFFE53935); // Red 600
  
  /// Draft status - Work in progress/not finalized
  static const Color draft = Color(0xFF757575); // Grey 600
  
  /// Overdue status - Past deadline
  static const Color overdue = Color(0xFFD32F2F); // Red 700
  
  /// Completed status - Task or process completed
  static const Color completed = Color(0xFF388E3C); // Green 700
  
  /// In Progress status - Currently being worked on
  static const Color inProgress = Color(0xFF1976D2); // Blue 700

  // ============================================================
  // ATTENDANCE STATUS COLORS
  // ============================================================

  /// Present - Student/Faculty marked present
  static const Color present = Color(0xFF4CAF50); // Green 500
  
  /// Absent - Student/Faculty marked absent
  static const Color absent = Color(0xFFE53935); // Red 600
  
  /// Late - Arrived late
  static const Color late = Color(0xFFFF9800); // Orange 500
  
  /// On Leave - Official leave
  static const Color onLeave = Color(0xFF2196F3); // Blue 500
  
  /// Holiday - Institutional holiday
  static const Color holiday = Color(0xFF9C27B0); // Purple 500

  // ============================================================
  // GRADE/PERFORMANCE COLORS
  // ============================================================

  /// Excellent performance (90-100%)
  static const Color gradeExcellent = Color(0xFF2E7D32); // Dark Green
  
  /// Good performance (75-89%)
  static const Color gradeGood = Color(0xFF43A047); // Green
  
  /// Average performance (60-74%)
  static const Color gradeAverage = Color(0xFFFFA726); // Orange
  
  /// Poor performance (40-59%)
  static const Color gradePoor = Color(0xFFFF7043); // Deep Orange
  
  /// Failing performance (<40%)
  static const Color gradeFail = Color(0xFFE53935); // Red

  // ============================================================
  // BACKGROUND & SURFACE COLORS
  // ============================================================

  /// Surface colors for cards and elevated components
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  static const Color cardLight = Color(0xFFFFFFFF); // White

  /// Dark mode background colors
  static const Color backgroundDark = Color(0xFF121212); // Almost black
  static const Color surfaceDark = Color(0xFF1E1E1E); // Dark grey
  static const Color cardDark = Color(0xFF2C2C2C); // Slightly lighter grey

  // ============================================================
  // NEUTRAL COLORS - For borders, dividers, text
  // ============================================================

  /// Border and outline colors
  static const Color outlineLight = Color(0xFFE0E0E0); // Grey 300
  static const Color outlineDark = Color(0xFF424242); // Grey 800
  
  /// Divider colors
  static const Color dividerLight = Color(0xFFBDBDBD); // Grey 400
  static const Color dividerDark = Color(0xFF616161); // Grey 700

  /// Shadow colors
  static const Color shadowLight = Color(0x1F000000); // Black with 12% opacity
  static const Color shadowDark = Color(0x3D000000); // Black with 24% opacity

  // ============================================================
  // TEXT COLORS
  // ============================================================

  /// Primary text color for dark mode
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // 100% white

  /// Secondary text color (medium emphasis)
  static const Color textSecondaryLight = Color(0x99000000); // 60% black
  static const Color textSecondaryDark = Color(0xB3FFFFFF); // 70% white

  /// Disabled text color (low emphasis)
  static const Color textDisabledLight = Color(0x61000000); // 38% black
  static const Color textDisabledDark = Color(0x61FFFFFF); // 38% white

  /// Hint text color
  static const Color textHintLight = Color(0x61000000); // 38% black
  static const Color textHintDark = Color(0x61FFFFFF); // 38% white

  // ============================================================
  // PRIORITY COLORS - For task/issue priority
  // ============================================================

  /// Critical priority
  static const Color priorityCritical = Color(0xFFD32F2F); // Red 700
  
  /// High priority
  static const Color priorityHigh = Color(0xFFFF5722); // Deep Orange
  
  /// Medium priority
  static const Color priorityMedium = Color(0xFFFFA726); // Orange
  
  /// Low priority
  static const Color priorityLow = Color(0xFF66BB6A); // Green

  // ============================================================
  // NOTIFICATION COLORS - For different notification types
  // ============================================================

  /// Academic notifications
  static const Color notificationAcademic = Color(0xFF1976D2); // Blue 700
  
  /// Administrative notifications
  static const Color notificationAdmin = Color(0xFFFF5722); // Deep Orange
  
  /// Exam notifications
  static const Color notificationExam = Color(0xFF7B1FA2); // Purple 700
  
  /// Fee notifications
  static const Color notificationFee = Color(0xFFFF9800); // Orange
  
  /// Event notifications
  static const Color notificationEvent = Color(0xFF43A047); // Green 600

  // ============================================================
  // UTILITY FUNCTIONS
  // ============================================================

  /// Get color for attendance percentage
  /// - Excellent: >= 90%
  /// - Good: >= 75%
  /// - Average: >= 60%
  /// - Poor: < 60%
  static Color getAttendanceColor(double percentage) {
    if (percentage >= 90) return gradeExcellent;
    if (percentage >= 75) return gradeGood;
    if (percentage >= 60) return gradeAverage;
    return gradePoor;
  }

  /// Get color for grade/marks
  /// Same thresholds as attendance
  static Color getGradeColor(double percentage) {
    if (percentage >= 90) return gradeExcellent;
    if (percentage >= 75) return gradeGood;
    if (percentage >= 60) return gradeAverage;
    if (percentage >= 40) return gradePoor;
    return gradeFail;
  }

  /// Get color for priority level
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return priorityCritical;
      case 'high':
        return priorityHigh;
      case 'medium':
        return priorityMedium;
      case 'low':
        return priorityLow;
      default:
        return priorityMedium;
    }
  }

  /// Get color for status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return active;
      case 'inactive':
        return inactive;
      case 'pending':
        return pending;
      case 'approved':
        return approved;
      case 'rejected':
        return rejected;
      case 'draft':
        return draft;
      case 'overdue':
        return overdue;
      case 'completed':
        return completed;
      case 'in progress':
      case 'inprogress':
        return inProgress;
      default:
        return inactive;
    }
  }

  /// Get lighter shade of any color (for backgrounds)
  static Color withLightOpacity(Color color, [double opacity = 0.1]) {
    return color.withOpacity(opacity);
  }

  /// Get contrasting text color for a background color
  /// Returns white for dark backgrounds, black for light backgrounds
  static Color getContrastingTextColor(Color backgroundColor) {
    // Calculate relative luminance
    final luminance = backgroundColor.computeLuminance();
    // Use white text for dark backgrounds, black for light backgrounds
    return luminance > 0.5 ? textPrimaryLight : textPrimaryDark;
  }
}
