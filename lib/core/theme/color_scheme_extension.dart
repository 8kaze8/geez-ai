import 'package:flutter/material.dart';
import 'colors.dart';

/// BuildContext extension that provides theme-adaptive color helpers.
///
/// Usage:
///   ```dart
///   final bg = context.surfaceVariant;
///   if (context.isDark) { ... }
///   ```
///
/// This eliminates the `isDark ? GeezColors.xDark : GeezColors.x` pattern
/// and keeps widget code concise and readable.
extension GeezColorScheme on BuildContext {
  // ── Mode helpers ──────────────────────────────────────────────────────────

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ── Surface variants ──────────────────────────────────────────────────────

  /// Light-variant surface for inputs, chips, and containers (F5F5F5 / 2A2A2E).
  Color get surfaceVariant =>
      isDark ? GeezColors.surfaceVariantDark : GeezColors.surfaceVariant;

  /// Slightly elevated surface for detail boxes and info containers (F8F8F8 / 252528).
  Color get surfaceElevated =>
      isDark ? GeezColors.surfaceElevatedDark : GeezColors.surfaceElevated;

  // ── Borders ───────────────────────────────────────────────────────────────

  /// Subtle outer border for cards and containers (EEEEEE / 3A3A3E).
  Color get borderColor =>
      isDark ? GeezColors.borderDark : GeezColors.borderLight;

  /// Standard muted border for inputs and chips (E0E0E0 / 424242).
  Color get borderMuted =>
      isDark ? GeezColors.borderMutedDark : GeezColors.borderMutedLight;

  /// Thin divider line between list items (D0D0D0 / 3A3A3E).
  Color get dividerColor =>
      isDark ? GeezColors.dividerDark : GeezColors.divider;

  // ── Text ──────────────────────────────────────────────────────────────────

  Color get textPrimary =>
      isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

  Color get textSecondary =>
      isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

  // ── Named surfaces ────────────────────────────────────────────────────────

  Color get appSurface =>
      isDark ? GeezColors.surfaceDark : GeezColors.surface;

  Color get appBackground =>
      isDark ? GeezColors.backgroundDark : GeezColors.background;

  // ── Chat bubbles ──────────────────────────────────────────────────────────

  Color get chatAiBubble =>
      isDark ? GeezColors.chatAiBubbleDark : GeezColors.chatAiBubbleLight;

  // ── Pending/inactive indicator ────────────────────────────────────────────

  Color get pendingIndicator =>
      isDark ? GeezColors.pendingDark : GeezColors.pendingLight;
}
