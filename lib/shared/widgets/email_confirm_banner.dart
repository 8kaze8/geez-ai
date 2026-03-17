import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/auth/domain/auth_state.dart' as geez_auth;

/// Session-scoped provider — tracks whether the user dismissed the banner.
/// Resets to false on every cold start (no persistence by design).
final emailBannerDismissedProvider = StateProvider<bool>((ref) => false);

/// Tracks the async state of the resend operation.
///
/// Values:
///   null  — idle
///   true  — success
///   false — in-progress or error (error message surfaced separately)
final _resendStateProvider =
    StateProvider<({bool sending, bool sent, String? error})>(
  (ref) => (sending: false, sent: false, error: null),
);

/// Shows a warning banner when the authenticated user's email is not yet
/// confirmed. Renders nothing in all other cases.
///
/// Place this widget above the main scroll content of any screen.
class EmailConfirmBanner extends ConsumerWidget {
  const EmailConfirmBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final dismissed = ref.watch(emailBannerDismissedProvider);

    // Only show for authenticated users with an unconfirmed email.
    if (authState.status != geez_auth.AuthStatus.authenticated) return const SizedBox.shrink();
    final user = authState.user;
    if (user == null) return const SizedBox.shrink();
    if (user.emailConfirmedAt != null) return const SizedBox.shrink();
    if (dismissed) return const SizedBox.shrink();

    return _BannerContent(userEmail: user.email ?? '');
  }
}

class _BannerContent extends ConsumerWidget {
  const _BannerContent({required this.userEmail});

  final String userEmail;

  Future<void> _resend(WidgetRef ref) async {
    if (userEmail.isEmpty) return;

    ref.read(_resendStateProvider.notifier).state =
        (sending: true, sent: false, error: null);

    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: userEmail,
      );
      ref.read(_resendStateProvider.notifier).state =
          (sending: false, sent: true, error: null);
    } catch (e) {
      ref.read(_resendStateProvider.notifier).state =
          (sending: false, sent: false, error: e.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resend = ref.watch(_resendStateProvider);

    // Theme-aware colours.
    final bgColor = isDark
        ? GeezColors.warning.withValues(alpha: 0.15)
        : GeezColors.warning.withValues(alpha: 0.12);
    final borderColor = GeezColors.warning.withValues(alpha: 0.5);
    final textColor =
        isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary;
    final mutedColor =
        isDark ? GeezColors.textSecondaryDark : GeezColors.textSecondary;
    final resendColor = isDark
        ? GeezColors.warning
        : GeezColors.warningDeep; // deeper amber for legibility on light

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.lg,
        vertical: GeezSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: GeezSpacing.md,
        vertical: GeezSpacing.sm + 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(GeezRadius.card),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning icon
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.mark_email_unread_outlined,
              size: 20,
              color: GeezColors.warning,
            ),
          ),
          const SizedBox(width: GeezSpacing.sm + 4),

          // Text content + action row
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'E-posta adresinizi doğrulayın',
                  style: GeezTypography.bodySmall.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  resend.sent
                      ? 'Doğrulama e-postası gönderildi. Lütfen gelen kutunuzu kontrol edin.'
                      : 'Hesabınızı etkinleştirmek için e-postanızı doğrulayın.',
                  style: GeezTypography.caption.copyWith(color: mutedColor),
                ),
                if (resend.error != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Gönderilemedi. Lütfen tekrar deneyin.',
                    style: GeezTypography.caption.copyWith(
                      color: GeezColors.error,
                    ),
                  ),
                ],
                if (!resend.sent) ...[
                  const SizedBox(height: GeezSpacing.sm),
                  Semantics(
                    label: resend.sending
                        ? 'Doğrulama e-postası gönderiliyor'
                        : 'Doğrulama e-postasını tekrar gönder',
                    button: true,
                    child: GestureDetector(
                      onTap: resend.sending ? null : () => _resend(ref),
                      child: resend.sending
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  GeezColors.warning,
                                ),
                              ),
                            )
                          : Text(
                              'Tekrar Gönder',
                              style: GeezTypography.caption.copyWith(
                                color: resendColor,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: resendColor,
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Dismiss button
          Semantics(
            label: 'Bildirimi kapat',
            button: true,
            child: GestureDetector(
              onTap: () =>
                  ref.read(emailBannerDismissedProvider.notifier).state = true,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: mutedColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
