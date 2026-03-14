import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/route/domain/route_stop_model.dart';

class StopCard extends StatefulWidget {
  const StopCard({
    super.key,
    required this.stop,
    this.travelFromNextMin,
    this.travelModeFromNext,
    this.isLast = false,
  });

  final RouteStopModel stop;

  /// Minutes to travel from this stop to the next one (null for last stop).
  final int? travelFromNextMin;

  /// Mode string for the travel connector (e.g. "walking", "transit").
  final String? travelModeFromNext;

  final bool isLast;

  @override
  State<StopCard> createState() => _StopCardState();
}

class _StopCardState extends State<StopCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Stop card
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isDark ? GeezColors.surfaceDark : GeezColors.surface,
              borderRadius: BorderRadius.circular(GeezRadius.card),
              border: Border.all(
                color: _isExpanded
                    ? GeezColors.primary.withValues(alpha: 0.3)
                    : (isDark
                        ? const Color(0xFF2A2A2E)
                        : const Color(0xFFEEEEEE)),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: _isExpanded ? 0.08 : 0.04),
                  blurRadius: _isExpanded ? 16 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Collapsed header — always visible
                _CollapsedHeader(
                  stop: widget.stop,
                  isExpanded: _isExpanded,
                  isDark: isDark,
                ),

                // Expanded content
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: _ExpandedContent(
                    stop: widget.stop,
                    isDark: isDark,
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  sizeCurve: Curves.easeInOut,
                ),
              ],
            ),
          ),
        ),

        // Travel connector to next stop
        if (!widget.isLast && widget.travelFromNextMin != null)
          _TravelConnector(
            durationMin: widget.travelFromNextMin!,
            mode: widget.travelModeFromNext,
            isDark: isDark,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Collapsed header
// ---------------------------------------------------------------------------

class _CollapsedHeader extends StatelessWidget {
  const _CollapsedHeader({
    required this.stop,
    required this.isExpanded,
    required this.isDark,
  });

  final RouteStopModel stop;
  final bool isExpanded;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(GeezSpacing.md),
      child: Row(
        children: [
          // Stop number badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: GeezColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${stop.stopOrder}',
                style: GeezTypography.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name + time range
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.placeName,
                  style: GeezTypography.body.copyWith(
                    color: isDark
                        ? GeezColors.textPrimaryDark
                        : GeezColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _timeRange(stop),
                  style: GeezTypography.caption.copyWith(
                    color: isDark
                        ? GeezColors.textSecondaryDark
                        : GeezColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Rating + entry fee
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (stop.googleRating != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 16, color: Color(0xFFFFC107)),
                    const SizedBox(width: 2),
                    Text(
                      stop.googleRating!.toStringAsFixed(1),
                      style: GeezTypography.bodySmall.copyWith(
                        color: isDark
                            ? GeezColors.textPrimaryDark
                            : GeezColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 2),
              Text(
                _priceLabel(stop),
                style: GeezTypography.caption.copyWith(
                  color: stop.entryFeeAmount == null || stop.entryFeeAmount == 0
                      ? GeezColors.success
                      : (isDark
                          ? GeezColors.textSecondaryDark
                          : GeezColors.textSecondary),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(width: 4),
          AnimatedRotation(
            turns: isExpanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDark
                  ? GeezColors.textSecondaryDark
                  : GeezColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _timeRange(RouteStopModel stop) {
    final start = stop.suggestedStartTime;
    final end = stop.suggestedEndTime;
    if (start != null && end != null) return '$start-$end';
    if (start != null) return start;
    final dur = stop.estimatedDurationMin;
    if (dur != null) return '$dur dk';
    return '';
  }

  String _priceLabel(RouteStopModel stop) {
    if (stop.entryFeeText != null) return stop.entryFeeText!;
    final amount = stop.entryFeeAmount;
    if (amount == null || amount == 0) return 'Ücretsiz';
    return '${stop.entryFeeCurrency} ${amount.toStringAsFixed(0)}';
  }
}

// ---------------------------------------------------------------------------
// Expanded content
// ---------------------------------------------------------------------------

class _ExpandedContent extends StatelessWidget {
  const _ExpandedContent({
    required this.stop,
    required this.isDark,
  });

  final RouteStopModel stop;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GeezSpacing.md,
        0,
        GeezSpacing.md,
        GeezSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Description
          if (stop.description != null) ...[
            Text(
              stop.description!,
              style: GeezTypography.bodySmall.copyWith(
                color: isDark
                    ? GeezColors.textPrimaryDark
                    : GeezColors.textPrimary,
              ),
            ),
            const SizedBox(height: GeezSpacing.md),
          ],

          // AI Insight / Insider tip
          if (stop.insiderTip != null) ...[
            _InfoSection(
              emoji: '💡',
              title: 'AI Insight',
              content: stop.insiderTip!,
              backgroundColor: GeezColors.primary.withValues(alpha: 0.06),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
          ],

          // Review summary
          if (stop.reviewSummary != null) ...[
            _InfoSection(
              emoji: '📝',
              title: stop.reviewCount != null
                  ? 'Review Özeti (${_formatCount(stop.reviewCount!)})'
                  : 'Review Özeti',
              content: stop.reviewSummary!,
              backgroundColor: GeezColors.secondary.withValues(alpha: 0.06),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
          ],

          // Fun fact
          if (stop.funFact != null) ...[
            _InfoSection(
              emoji: '🎯',
              title: 'Fun Fact',
              content: stop.funFact!,
              backgroundColor: GeezColors.accent.withValues(alpha: 0.06),
              isDark: isDark,
            ),
            const SizedBox(height: GeezSpacing.md),
          ],

          // Practical details box
          if (_hasPracticalDetails(stop))
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF252528)
                    : const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detaylar',
                    style: GeezTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? GeezColors.textPrimaryDark
                          : GeezColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (stop.bestTime != null)
                    _DetailRow(
                      icon: '⏱️',
                      text: 'En iyi: ${stop.bestTime!}',
                      isDark: isDark,
                    ),
                  if (stop.entryFeeText != null)
                    _DetailRow(
                      icon: '💰',
                      text: stop.entryFeeText!,
                      isDark: isDark,
                    )
                  else if (stop.entryFeeAmount != null &&
                      stop.entryFeeAmount! > 0)
                    _DetailRow(
                      icon: '💰',
                      text:
                          '${stop.entryFeeCurrency} ${stop.entryFeeAmount!.toStringAsFixed(0)}',
                      isDark: isDark,
                    ),
                  if (stop.warnings != null)
                    _DetailRow(
                      icon: '⚠️',
                      text: stop.warnings!,
                      isDark: isDark,
                      isWarning: true,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool _hasPracticalDetails(RouteStopModel stop) {
    return stop.bestTime != null ||
        stop.entryFeeText != null ||
        (stop.entryFeeAmount != null && stop.entryFeeAmount! > 0) ||
        stop.warnings != null;
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      final k = count / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}K';
    }
    return count.toString();
  }
}

// ---------------------------------------------------------------------------
// Reusable sub-widgets
// ---------------------------------------------------------------------------

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.emoji,
    required this.title,
    required this.content,
    required this.backgroundColor,
    required this.isDark,
  });

  final String emoji;
  final String title;
  final String content;
  final Color backgroundColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                title,
                style: GeezTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? GeezColors.textPrimaryDark
                      : GeezColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GeezTypography.bodySmall.copyWith(
              color: isDark
                  ? GeezColors.textPrimaryDark.withValues(alpha: 0.85)
                  : GeezColors.textPrimary.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.text,
    required this.isDark,
    this.isWarning = false,
  });

  final String icon;
  final String text;
  final bool isDark;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GeezTypography.caption.copyWith(
                color: isWarning
                    ? GeezColors.warning
                    : (isDark
                        ? GeezColors.textSecondaryDark
                        : GeezColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Travel connector between stops
// ---------------------------------------------------------------------------

class _TravelConnector extends StatelessWidget {
  const _TravelConnector({
    required this.durationMin,
    required this.isDark,
    this.mode,
  });

  final int durationMin;
  final String? mode;
  final bool isDark;

  String get _icon {
    switch (mode?.toLowerCase()) {
      case 'transit':
      case 'bus':
        return '🚌';
      case 'car':
      case 'driving':
        return '🚗';
      case 'cycling':
      case 'bike':
        return '🚲';
      default:
        return '🚶';
    }
  }

  String get _label => '$durationMin dk';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 30),
          // Dotted connector line
          Column(
            children: [
              Container(
                width: 2,
                height: 8,
                color: isDark
                    ? const Color(0xFF3A3A3E)
                    : const Color(0xFFD0D0D0),
              ),
              const SizedBox(height: 3),
              Container(
                width: 2,
                height: 8,
                color: isDark
                    ? const Color(0xFF3A3A3E)
                    : const Color(0xFFD0D0D0),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Text(_icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            _label,
            style: GeezTypography.caption.copyWith(
              color: isDark
                  ? GeezColors.textSecondaryDark
                  : GeezColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
