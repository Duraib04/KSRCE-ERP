import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'design_tokens.dart';

/// Comprehensive theme configuration for the KSRCE ERP application.
///
/// This centralizes the app's styling with Material Design 3 principles,
/// using design tokens for consistency and semantic colors for clarity.
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // ============================================================
  // LIGHT THEME
  // ============================================================
  
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color scheme based on blue primary color
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.info, // Blue as primary color
      brightness: Brightness.light,
      error: AppColors.error,
      surface: AppColors.surfaceLight,
      background: AppColors.backgroundLight,
    ),

    // Scaffold background
    scaffoldBackgroundColor: AppColors.backgroundLight,

    // App bar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: AppElevation.xs,
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimaryLight,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textPrimaryLight,
        size: AppIconSize.md,
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      elevation: AppElevation.sm,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusMd,
      ),
      color: AppColors.cardLight,
      margin: EdgeInsets.all(AppSpacing.sm),
      clipBehavior: Clip.antiAlias,
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: AppElevation.sm,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusSm,
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        minimumSize: const Size(64, 40),
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusSm,
        ),
        side: BorderSide(
          color: AppColors.outlineLight,
          width: 1.5,
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        minimumSize: const Size(64, 40),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusSm,
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Icon button theme
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        iconSize: AppIconSize.md,
        padding: EdgeInsets.all(AppSpacing.sm),
      ),
    ),

    // Floating action button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: AppElevation.md,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusLg,
      ),
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.backgroundLight,
      deleteIconColor: AppColors.textSecondaryLight,
      disabledColor: AppColors.inactive.withOpacity(0.3),
      selectedColor: AppColors.info.withOpacity(0.2),
      secondarySelectedColor: AppColors.info.withOpacity(0.3),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusFull,
        side: BorderSide(color: AppColors.outlineLight),
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: AppColors.outlineLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: AppColors.outlineLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: AppColors.info, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondaryLight,
      ),
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textHintLight,
      ),
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      elevation: AppElevation.xl,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusLg,
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryLight,
      ),
      contentTextStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondaryLight,
      ),
    ),

    // Bottom sheet theme
    bottomSheetTheme: BottomSheetThemeData(
      elevation: AppElevation.lg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      backgroundColor: AppColors.surfaceLight,
    ),

    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      elevation: AppElevation.md,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusSm,
      ),
      behavior: SnackBarBehavior.floating,
      contentTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Divider theme
    dividerTheme: DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
      space: AppSpacing.lg,
    ),

    // List tile theme
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusSm,
      ),
    ),

    // Navigation bar theme
    navigationBarTheme: NavigationBarThemeData(
      elevation: AppElevation.sm,
      height: 64,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),

    // Drawer theme
    drawerTheme: DrawerThemeData(
      elevation: AppElevation.lg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(AppRadius.lg),
        ),
      ),
    ),

    // Text theme with proper hierarchy
    textTheme: _buildTextTheme(Brightness.light),
  );

  // ============================================================
  // DARK THEME
  // ============================================================
  
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Color scheme based on blue primary color
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.info,
      brightness: Brightness.dark,
      error: AppColors.errorLight,
      surface: AppColors.surfaceDark,
      background: AppColors.backgroundDark,
    ),

    // Scaffold background
    scaffoldBackgroundColor: AppColors.backgroundDark,

    // App bar theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: AppElevation.xs,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textPrimaryDark,
        size: AppIconSize.md,
      ),
    ),

    // Card theme
    cardTheme: CardThemeData(
      elevation: AppElevation.sm,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusMd,
      ),
      color: AppColors.cardDark,
      margin: EdgeInsets.all(AppSpacing.sm),
      clipBehavior: Clip.antiAlias,
    ),

    // Elevated button theme (same as light mode)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: AppElevation.sm,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusSm,
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        minimumSize: const Size(64, 40),
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusSm,
        ),
        side: BorderSide(
          color: AppColors.outlineDark,
          width: 1.5,
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        minimumSize: const Size(64, 40),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusSm,
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Icon button theme
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        iconSize: AppIconSize.md,
        padding: EdgeInsets.all(AppSpacing.sm),
      ),
    ),

    // Floating action button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: AppElevation.md,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusLg,
      ),
    ),

    // Chip theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.backgroundDark,
      deleteIconColor: AppColors.textSecondaryDark,
      disabledColor: AppColors.inactive.withOpacity(0.3),
      selectedColor: AppColors.info.withOpacity(0.2),
      secondarySelectedColor: AppColors.info.withOpacity(0.3),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusFull,
        side: BorderSide(color: AppColors.outlineDark),
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: AppColors.outlineDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: AppColors.outlineDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: AppColors.info, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: AppColors.errorLight),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusSm,
        borderSide: BorderSide(color: AppColors.errorLight, width: 2),
      ),
      labelStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondaryDark,
      ),
      hintStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textHintDark,
      ),
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      elevation: AppElevation.xl,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusLg,
      ),
      backgroundColor: AppColors.surfaceDark,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
      ),
      contentTextStyle: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondaryDark,
      ),
    ),

    // Bottom sheet theme
    bottomSheetTheme: BottomSheetThemeData(
      elevation: AppElevation.lg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      backgroundColor: AppColors.surfaceDark,
    ),

    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      elevation: AppElevation.md,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusSm,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.surfaceDark,
      contentTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Divider theme
    dividerTheme: DividerThemeData(
      color: AppColors.dividerDark,
      thickness: 1,
      space: AppSpacing.lg,
    ),

    // List tile theme
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.radiusSm,
      ),
    ),

    // Navigation bar theme
    navigationBarTheme: NavigationBarThemeData(
      elevation: AppElevation.sm,
      height: 64,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),

    // Drawer theme
    drawerTheme: DrawerThemeData(
      elevation: AppElevation.lg,
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(AppRadius.lg),
        ),
      ),
    ),

    // Text theme with proper hierarchy
    textTheme: _buildTextTheme(Brightness.dark),
  );

  // ============================================================
  // TEXT THEME BUILDER
  // ============================================================
  
  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color primaryColor = brightness == Brightness.light 
        ? AppColors.textPrimaryLight 
        : AppColors.textPrimaryDark;
    final Color secondaryColor = brightness == Brightness.light 
        ? AppColors.textSecondaryLight 
        : AppColors.textSecondaryDark;

    return TextTheme(
      // Display styles - Largest text
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles - Page headers
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - Section headers
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: primaryColor,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles - Main content
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryColor,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles - Buttons, labels
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryColor,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }
}
