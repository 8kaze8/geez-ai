import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/route/domain/route_model.dart';

/// A card that represents a single past route in the Route History list.
///
/// Tapping the card triggers [onTap] which should navigate to
/// [RouteDetailScreen] for this route.
class RouteHistoryCard extends StatelessWidget {
  const RouteHistoryCard({
    super.key,
    required this.route,
    required this.onTap,
  });

  final RouteModel route;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? GeezColors.surfaceDark : GeezColors.surface;
    final primaryTextColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final secondaryTextColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;
    final dividerColor = isDark
        ? GeezColors.surfaceVariantDark
        : GeezColors.surfaceElevated;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(GeezRadius.card),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: isDark
              ? Border.all(color: GeezColors.surfaceVariantDark, width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: destination + status badge
            Padding(
              padding: const EdgeInsets.fromLTRB(
                GeezSpacing.md,
                GeezSpacing.md,
                GeezSpacing.md,
                GeezSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Destination pin icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: GeezColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: GeezColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: GeezSpacing.sm),

                  // City + country
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.city,
                          style: GeezTypography.h3.copyWith(
                            color: primaryTextColor,
                            fontSize: 17,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          route.country,
                          style: GeezTypography.bodySmall.copyWith(
                            color: secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: GeezSpacing.sm),

                  // Status badge
                  _StatusBadge(status: route.status),
                ],
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.md),
              child: Text(
                route.title,
                style: GeezTypography.bodySmall.copyWith(
                  color: secondaryTextColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: GeezSpacing.md),

            // Divider
            Divider(height: 1, thickness: 1, color: dividerColor),

            // Bottom meta row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GeezSpacing.md,
                vertical: GeezSpacing.sm,
              ),
              child: Row(
                children: [
                  _MetaChip(
                    icon: Icons.calendar_today_rounded,
                    label: _formatDate(route.createdAt),
                    isDark: isDark,
                  ),
                  const SizedBox(width: GeezSpacing.sm),
                  _MetaChip(
                    icon: Icons.wb_sunny_rounded,
                    label: '${route.durationDays} gün',
                    isDark: isDark,
                  ),
                  const SizedBox(width: GeezSpacing.sm),
                  _MetaChip(
                    icon: _styleIcon(route.travelStyle),
                    label: _styleLabel(route.travelStyle),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    final local = dt.toLocal();
    const months = [
      'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
      'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
    ];
    return '${local.day} ${months[local.month - 1]} ${local.year}';
  }

  IconData _styleIcon(String style) {
    switch (style.toLowerCase()) {
      case 'historical':
        return Icons.account_balance_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'adventure':
        return Icons.terrain_rounded;
      case 'nature':
        return Icons.park_rounded;
      case 'mixed':
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  String _styleLabel(String style) {
    switch (style.toLowerCase()) {
      case 'historical':
        return 'Tarihi';
      case 'food':
        return 'Yemek';
      case 'adventure':
        return 'Macera';
      case 'nature':
        return 'Doğa';
      case 'mixed':
        return 'Karma';
      default:
        return style;
    }
  }
}

// ---------------------------------------------------------------------------
// Status badge
// ---------------------------------------------------------------------------

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color, bgAlpha) = switch (status.toLowerCase()) {
      'completed' => ('Tamamlandı', GeezColors.success, 0.12),
      'active' => ('Aktif', GeezColors.primary, 0.12),
      'draft' => ('Taslak', GeezColors.warning, 0.15),
      _ => ('Taslak', GeezColors.warning, 0.15),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: bgAlpha),
        borderRadius: BorderRadius.circular(GeezRadius.stamp),
      ),
      child: Text(
        label,
        style: GeezTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Meta chip (icon + label)
// ---------------------------------------------------------------------------

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: GeezTypography.caption.copyWith(color: color),
        ),
      ],
    );
  }
}
