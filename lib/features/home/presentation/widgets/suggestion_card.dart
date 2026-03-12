import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../domain/mock_data.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({
    super.key,
    required this.suggestion,
    this.onPlan,
  });

  final MockSuggestion suggestion;
  final VoidCallback? onPlan;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;

    return Container(
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GeezRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(GeezRadius.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image area with gradient overlay
            SizedBox(
              height: 110,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder image area with themed gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _gradientForCity(suggestion.city),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        suggestion.flag,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  // Bottom gradient overlay for text readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // City name on image
                  Positioned(
                    bottom: 8,
                    left: 12,
                    child: Text(
                      suggestion.city,
                      style: GeezTypography.h3.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content area
            Container(
              color: isDark ? GeezColors.surfaceDark : GeezColors.surface,
              padding: const EdgeInsets.all(GeezSpacing.sm + 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Country
                  Text(
                    suggestion.country,
                    style: GeezTypography.caption.copyWith(
                      color: isDark
                          ? GeezColors.textSecondaryDark
                          : GeezColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: GeezSpacing.xs),

                  // AI reasoning
                  Text(
                    '"${suggestion.reason}"',
                    style: GeezTypography.funFact.copyWith(
                      color: textColor,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: GeezSpacing.sm + 2),

                  // Plan button
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: GeezColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(GeezRadius.button),
                      child: InkWell(
                        onTap: onPlan,
                        borderRadius: BorderRadius.circular(GeezRadius.button),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: GeezSpacing.sm,
                          ),
                          child: Center(
                            child: Text(
                              'Planla',
                              style: GeezTypography.bodySmall.copyWith(
                                color: GeezColors.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _gradientForCity(String city) {
    switch (city) {
      case 'Roma':
        return [
          const Color(0xFF795548),
          const Color(0xFFD7CCC8),
        ];
      case 'Atina':
        return [
          const Color(0xFF1565C0),
          const Color(0xFF90CAF9),
        ];
      case 'Barselona':
        return [
          const Color(0xFFE65100),
          const Color(0xFFFFCC80),
        ];
      default:
        return [
          GeezColors.primary,
          GeezColors.primary.withValues(alpha: 0.5),
        ];
    }
  }
}
