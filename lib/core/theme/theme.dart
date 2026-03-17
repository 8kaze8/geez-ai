import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

class GeezTheme {
  GeezTheme._();

  // ─── Light Theme ───────────────────────────────────────────────

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'Inter',

        // Color scheme
        colorScheme: const ColorScheme.light(
          primary: GeezColors.primary,
          secondary: GeezColors.secondary,
          tertiary: GeezColors.accent,
          surface: GeezColors.surface,
          error: GeezColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: GeezColors.textPrimary,
          onError: Colors.white,
          outline: GeezColors.borderMutedLight,
          surfaceContainerHighest: GeezColors.background,
        ),

        // Scaffold
        scaffoldBackgroundColor: GeezColors.background,

        // AppBar
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: false,
          backgroundColor: GeezColors.surface,
          foregroundColor: GeezColors.textPrimary,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: GeezColors.textPrimary,
          ),
        ),

        // Cards
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GeezRadius.card),
          ),
          color: GeezColors.surface,
          surfaceTintColor: Colors.transparent,
          clipBehavior: Clip.antiAlias,
        ),

        // Elevated buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: GeezColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: GeezSpacing.lg,
              vertical: GeezSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(GeezRadius.button),
            ),
            textStyle: GeezTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Outlined buttons
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: GeezColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: GeezSpacing.lg,
              vertical: GeezSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(GeezRadius.button),
            ),
            side: const BorderSide(color: GeezColors.primary, width: 1.5),
            textStyle: GeezTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text buttons
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: GeezColors.primary,
            textStyle: GeezTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Floating action button
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: GeezColors.secondary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: CircleBorder(),
        ),

        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: GeezColors.background,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: GeezSpacing.md,
            vertical: GeezSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GeezRadius.button),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GeezRadius.button),
            borderSide: const BorderSide(color: GeezColors.borderMutedLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GeezRadius.button),
            borderSide:
                const BorderSide(color: GeezColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GeezRadius.button),
            borderSide: const BorderSide(color: GeezColors.error),
          ),
          hintStyle: GeezTypography.body.copyWith(
            color: GeezColors.textSecondary,
          ),
        ),

        // Chips
        chipTheme: ChipThemeData(
          backgroundColor: GeezColors.background,
          selectedColor: GeezColors.primary.withValues(alpha: 0.12),
          labelStyle: GeezTypography.bodySmall,
          padding: const EdgeInsets.symmetric(
            horizontal: GeezSpacing.sm,
            vertical: GeezSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GeezRadius.chip),
          ),
          side: const BorderSide(color: GeezColors.borderMutedLight),
        ),

        // Bottom navigation bar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: GeezColors.surface,
          selectedItemColor: GeezColors.primary,
          unselectedItemColor: GeezColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),

        // Navigation bar (Material 3)
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: GeezColors.surface,
          indicatorColor: GeezColors.primary.withValues(alpha: 0.12),
          labelTextStyle: WidgetStatePropertyAll(
            GeezTypography.caption.copyWith(fontWeight: FontWeight.w600),
          ),
          elevation: 2,
          height: 64,
        ),

        // Bottom sheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: GeezColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          showDragHandle: true,
          dragHandleColor: GeezColors.borderMutedLight,
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: GeezColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GeezRadius.card),
          ),
          titleTextStyle: GeezTypography.h3.copyWith(
            color: GeezColors.textPrimary,
          ),
          contentTextStyle: GeezTypography.body.copyWith(
            color: GeezColors.textSecondary,
          ),
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: GeezColors.borderLight,
          thickness: 1,
          space: 1,
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: GeezColors.textPrimary,
          contentTextStyle: GeezTypography.bodySmall.copyWith(
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GeezRadius.stamp),
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // Text theme
        textTheme: const TextTheme(
          headlineLarge: GeezTypography.h1,
          headlineMedium: GeezTypography.h2,
          headlineSmall: GeezTypography.h3,
          bodyLarge: GeezTypography.body,
          bodyMedium: GeezTypography.bodySmall,
          bodySmall: GeezTypography.caption,
          labelLarge: GeezTypography.body,
        ),
      );

  // ─── Dark Theme ────────────────────────────────────────────────

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Inter',

        // Color scheme
        colorScheme: const ColorScheme.dark(
          primary: GeezColors.primary,
          secondary: GeezColors.secondary,
          tertiary: GeezColors.accent,
          surface: GeezColors.surfaceDark,
          error: GeezColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: GeezColors.textPrimaryDark,
          onError: Colors.white,
          outline: GeezColors.borderMutedDark,
          surfaceContainerHighest: GeezColors.backgroundDark,
        ),

        // Scaffold
        scaffoldBackgroundColor: GeezColors.backgroundDark,

        // AppBar
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: false,
          backgroundColor: GeezColors.surfaceDark,
          foregroundColor: GeezColors.textPrimaryDark,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: GeezColors.textPrimaryDark,
          ),
        ),

        // Cards
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GeezRadius.card),
          ),
          color: GeezColors.surfaceDark,
          surfaceTintColor: Colors.transparent,
          clipBehavior: Clip.antiAlias,
        ),

        // Elevated buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: GeezColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: GeezSpacing.lg,
              vertical: GeezSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(GeezRadius.button),
            ),
            textStyle: GeezTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Outlined buttons
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: GeezColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: GeezSpacing.lg,
              vertical: GeezSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(GeezRadius.button),
            ),
            side: const BorderSide(color: GeezColors.primary, width: 1.5),
            textStyle: GeezTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text buttons
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: GeezColors.primary,
            textStyle: GeezTypography.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Floating action button
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: GeezColors.secondary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: CircleBorder(),
        ),

        // Input decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: GeezColors.backgroundDark,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: GeezSpacing.md,
            vertical: GeezSpacing.md,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GeezRadius.button),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GeezRadius.button),
            borderSide: const BorderSide(color: GeezColors.borderMutedDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GeezRadius.button),
            borderSide:
                const BorderSide(color: GeezColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GeezRadius.button),
            borderSide: const BorderSide(color: GeezColors.error),
          ),
          hintStyle: GeezTypography.body.copyWith(
            color: GeezColors.textSecondaryDark,
          ),
        ),

        // Chips
        chipTheme: ChipThemeData(
          backgroundColor: GeezColors.surfaceDark,
          selectedColor: GeezColors.primary.withValues(alpha: 0.24),
          labelStyle: GeezTypography.bodySmall.copyWith(
            color: GeezColors.textPrimaryDark,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: GeezSpacing.sm,
            vertical: GeezSpacing.xs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GeezRadius.chip),
          ),
          side: const BorderSide(color: GeezColors.borderMutedDark),
        ),

        // Bottom navigation bar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: GeezColors.surfaceDark,
          selectedItemColor: GeezColors.primary,
          unselectedItemColor: GeezColors.textSecondaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),

        // Navigation bar (Material 3)
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: GeezColors.surfaceDark,
          indicatorColor: GeezColors.primary.withValues(alpha: 0.24),
          labelTextStyle: WidgetStatePropertyAll(
            GeezTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: GeezColors.textPrimaryDark,
            ),
          ),
          elevation: 2,
          height: 64,
        ),

        // Bottom sheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: GeezColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          showDragHandle: true,
          dragHandleColor: GeezColors.textSecondary,
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: GeezColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GeezRadius.card),
          ),
          titleTextStyle: GeezTypography.h3.copyWith(
            color: GeezColors.textPrimaryDark,
          ),
          contentTextStyle: GeezTypography.body.copyWith(
            color: GeezColors.textSecondaryDark,
          ),
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: GeezColors.borderMutedDark,
          thickness: 1,
          space: 1,
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: GeezColors.textPrimaryDark,
          contentTextStyle: GeezTypography.bodySmall.copyWith(
            color: GeezColors.backgroundDark,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GeezRadius.stamp),
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // Text theme
        textTheme: TextTheme(
          headlineLarge:
              GeezTypography.h1.copyWith(color: GeezColors.textPrimaryDark),
          headlineMedium:
              GeezTypography.h2.copyWith(color: GeezColors.textPrimaryDark),
          headlineSmall:
              GeezTypography.h3.copyWith(color: GeezColors.textPrimaryDark),
          bodyLarge:
              GeezTypography.body.copyWith(color: GeezColors.textPrimaryDark),
          bodyMedium: GeezTypography.bodySmall
              .copyWith(color: GeezColors.textPrimaryDark),
          bodySmall: GeezTypography.caption
              .copyWith(color: GeezColors.textSecondaryDark),
          labelLarge:
              GeezTypography.body.copyWith(color: GeezColors.textPrimaryDark),
        ),
      );
}
