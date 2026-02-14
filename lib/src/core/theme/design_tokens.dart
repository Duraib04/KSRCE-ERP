/// Design tokens for consistent spacing, sizing, and timing across the app.
/// 
/// This file defines the fundamental design system values used throughout
/// the KSRCE ERP application to ensure visual consistency.

import 'package:flutter/material.dart';

/// Spacing scale following 4px baseline grid system.
/// 
/// Usage:
/// ```dart
/// Padding(
///   padding: EdgeInsets.all(AppSpacing.md),
///   child: Text('Hello'),
/// )
/// ```
class AppSpacing {
  AppSpacing._(); // Private constructor to prevent instantiation

  /// 4px - Minimal spacing between tightly related elements
  static const double xs = 4.0;

  /// 8px - Small spacing for compact layouts
  static const double sm = 8.0;

  /// 12px - Medium-small spacing for list items
  static const double md = 12.0;

  /// 16px - Standard spacing for most elements (default)
  static const double lg = 16.0;

  /// 24px - Large spacing between sections
  static const double xl = 24.0;

  /// 32px - Extra large spacing for major sections
  static const double xxl = 32.0;

  /// 48px - Huge spacing for page-level separation
  static const double xxxl = 48.0;

  /// 64px - Maximum spacing for hero sections
  static const double jumbo = 64.0;

  // Common edge insets for convenience
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding
  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);

  // Gaps for Flex widgets (Row, Column)
  static const SizedBox gapXs = SizedBox(width: xs, height: xs);
  static const SizedBox gapSm = SizedBox(width: sm, height: sm);
  static const SizedBox gapMd = SizedBox(width: md, height: md);
  static const SizedBox gapLg = SizedBox(width: lg, height: lg);
  static const SizedBox gapXl = SizedBox(width: xl, height: xl);
  static const SizedBox gapXxl = SizedBox(width: xxl, height: xxl);
}

/// Border radius values for consistent rounded corners.
/// 
/// Usage:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: AppRadius.md,
///   ),
/// )
/// ```
class AppRadius {
  AppRadius._();

  /// 4px - Subtle rounding
  static const double xs = 4.0;

  /// 8px - Small rounding for buttons/chips
  static const double sm = 8.0;

  /// 12px - Medium rounding for cards (default)
  static const double md = 12.0;

  /// 16px - Large rounding for prominent cards
  static const double lg = 16.0;

  /// 20px - Extra large rounding
  static const double xl = 20.0;

  /// 28px - Very large rounding for special elements
  static const double xxl = 28.0;

  /// 999px - Fully rounded (pill shape)
  static const double full = 999.0;

  // BorderRadius objects for convenience
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));

  // Rounded rectangle borders for convenience
  static final RoundedRectangleBorder shapeXs = RoundedRectangleBorder(borderRadius: radiusXs);
  static final RoundedRectangleBorder shapeSm = RoundedRectangleBorder(borderRadius: radiusSm);
  static final RoundedRectangleBorder shapeMd = RoundedRectangleBorder(borderRadius: radiusMd);
  static final RoundedRectangleBorder shapeLg = RoundedRectangleBorder(borderRadius: radiusLg);
  static final RoundedRectangleBorder shapeXl = RoundedRectangleBorder(borderRadius: radiusXl);
  static final RoundedRectangleBorder shapeFull = RoundedRectangleBorder(borderRadius: radiusFull);
}

/// Elevation values for consistent shadow depth.
/// 
/// Usage:
/// ```dart
/// Card(
///   elevation: AppElevation.sm,
///   child: Text('Content'),
/// )
/// ```
class AppElevation {
  AppElevation._();

  /// 0 - No elevation (flat)
  static const double none = 0.0;

  /// 1 - Minimal elevation
  static const double xs = 1.0;

  /// 2 - Small elevation for cards
  static const double sm = 2.0;

  /// 4 - Medium elevation for raised elements
  static const double md = 4.0;

  /// 8 - Large elevation for floating elements
  static const double lg = 8.0;

  /// 12 - Extra large elevation for modals
  static const double xl = 12.0;

  /// 16 - Maximum elevation for dialogs
  static const double xxl = 16.0;
}

/// Animation duration values for consistent timing.
/// 
/// Usage:
/// ```dart
/// AnimatedContainer(
///   duration: AppDuration.medium,
///   child: Text('Animated'),
/// )
/// ```
class AppDuration {
  AppDuration._();

  /// 100ms - Instant feedback
  static const Duration instant = Duration(milliseconds: 100);

  /// 150ms - Fast animations for micro-interactions
  static const Duration fast = Duration(milliseconds: 150);

  /// 200ms - Quick animations
  static const Duration quick = Duration(milliseconds: 200);

  /// 300ms - Standard animation duration (default)
  static const Duration medium = Duration(milliseconds: 300);

  /// 500ms - Slow animations for emphasis
  static const Duration slow = Duration(milliseconds: 500);

  /// 800ms - Very slow animations
  static const Duration verySlow = Duration(milliseconds: 800);

  /// 1000ms - Maximum animation duration
  static const Duration extraSlow = Duration(milliseconds: 1000);
}

/// Icon size values for consistent icon sizing.
/// 
/// Usage:
/// ```dart
/// Icon(
///   Icons.home,
///   size: AppIconSize.md,
/// )
/// ```
class AppIconSize {
  AppIconSize._();

  /// 16px - Small icons
  static const double sm = 16.0;

  /// 24px - Standard icon size (default Material icon size)
  static const double md = 24.0;

  /// 32px - Large icons
  static const double lg = 32.0;

  /// 48px - Extra large icons
  static const double xl = 48.0;

  /// 64px - Hero icons
  static const double xxl = 64.0;
}

/// Breakpoint values for responsive design.
/// 
/// Usage:
/// ```dart
/// if (MediaQuery.of(context).size.width >= AppBreakpoint.tablet) {
///   // Tablet layout
/// }
/// ```
class AppBreakpoint {
  AppBreakpoint._();

  /// 360px - Minimum mobile width
  static const double mobile = 360.0;

  /// 600px - Tablet portrait
  static const double tablet = 600.0;

  /// 900px - Tablet landscape / small desktop
  static const double desktop = 900.0;

  /// 1200px - Large desktop
  static const double desktopLarge = 1200.0;

  /// 1536px - Extra large desktop
  static const double desktopXl = 1536.0;
}

/// Maximum width constraints for content areas.
class AppConstraints {
  AppConstraints._();

  /// 400px - Maximum width for forms
  static const double formMaxWidth = 400.0;

  /// 600px - Maximum width for content
  static const double contentMaxWidth = 600.0;

  /// 1200px - Maximum width for page content
  static const double pageMaxWidth = 1200.0;

  /// 1536px - Maximum width for wide layouts
  static const double wideMaxWidth = 1536.0;
}
