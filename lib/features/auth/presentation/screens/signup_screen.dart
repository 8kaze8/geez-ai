import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/typography.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/shared/widgets/geez_button.dart';
import 'package:geez_ai/features/auth/domain/auth_state.dart';
import 'package:geez_ai/features/auth/presentation/providers/auth_provider.dart';
import 'package:geez_ai/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:geez_ai/features/onboarding/data/onboarding_repository.dart';
import 'package:geez_ai/features/onboarding/presentation/providers/onboarding_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _passwordMatchError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) return;

    if (password != confirmPassword) {
      setState(() => _passwordMatchError = 'Sifreler uyusmuyor');
      return;
    }

    if (password.length < 6) {
      setState(() => _passwordMatchError = 'Sifre en az 6 karakter olmali');
      return;
    }

    setState(() => _passwordMatchError = null);

    await ref.read(authStateProvider.notifier).signUp(
          email: email,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authStateProvider);

    // Navigate on successful auth — drain any pending onboarding answers first.
    ref.listen<AuthState>(authStateProvider, (prev, next) async {
      if (next.isAuthenticated && next.user != null) {
        // Flush quiz answers that were saved before signup.
        final repo = ref.read(onboardingRepositoryProvider);
        final hadPending = await OnboardingNotifier.flushPendingOnboardingWith(
          repo,
          next.user!.id,
        );
        if (!context.mounted) return;
        // Quiz was completed before signup → go to home.
        // No pending data → go to onboarding so user can take the quiz.
        if (hadPending) {
          context.go('/');
        } else {
          context.go('/onboarding');
        }
      }
    });

    return Scaffold(
      backgroundColor:
          isDark ? GeezColors.backgroundDark : GeezColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: GeezSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: GeezSpacing.xxl),

              // Logo area
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.travel_explore_rounded,
                      size: 56,
                      color: GeezColors.primary,
                    ),
                    const SizedBox(height: GeezSpacing.md),
                    Text(
                      'Hesap Olustur',
                      style: GeezTypography.h1.copyWith(
                        color: isDark
                            ? GeezColors.textPrimaryDark
                            : GeezColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: GeezSpacing.sm),
                    Text(
                      'Kisisel seyahat deneyimine basla',
                      style: GeezTypography.body.copyWith(
                        color: GeezColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: GeezSpacing.xxl),

              // Error message
              if (authState.errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(GeezSpacing.md),
                  decoration: BoxDecoration(
                    color: GeezColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(GeezRadius.button),
                    border: Border.all(
                      color: GeezColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: GeezColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: GeezSpacing.sm),
                      Expanded(
                        child: Text(
                          authState.errorMessage!,
                          style: GeezTypography.bodySmall.copyWith(
                            color: GeezColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GeezSpacing.lg),
              ],

              // Email
              AuthTextField(
                controller: _emailController,
                label: 'E-posta',
                hint: 'ornek@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),

              const SizedBox(height: GeezSpacing.md),

              // Password
              AuthTextField(
                controller: _passwordController,
                label: 'Sifre',
                hint: 'En az 6 karakter',
                isPassword: true,
                prefixIcon: Icons.lock_outlined,
              ),

              const SizedBox(height: GeezSpacing.md),

              // Confirm password
              AuthTextField(
                controller: _confirmPasswordController,
                label: 'Sifre Tekrar',
                hint: 'Sifreni tekrar gir',
                isPassword: true,
                prefixIcon: Icons.lock_outlined,
                textInputAction: TextInputAction.done,
                errorText: _passwordMatchError,
                onSubmitted: (_) => _handleSignup(),
              ),

              const SizedBox(height: GeezSpacing.lg),

              // Signup button
              SizedBox(
                width: double.infinity,
                child: GeezButton(
                  label: 'Kayit Ol',
                  onTap: _handleSignup,
                  isLoading: authState.isLoading,
                  icon: Icons.person_add_rounded,
                ),
              ),

              const SizedBox(height: GeezSpacing.lg),

              // Terms
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: GeezSpacing.md),
                  child: Text(
                    'Kayit olarak Kullanim Sartlarini ve Gizlilik Politikasini kabul etmis olursun.',
                    style: GeezTypography.caption.copyWith(
                      color: GeezColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: GeezSpacing.lg),

              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: GeezSpacing.md),
                    child: Text(
                      'veya',
                      style: GeezTypography.bodySmall.copyWith(
                        color: GeezColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: GeezSpacing.lg),

              // Go to login
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Zaten hesabin var mi? ',
                      style: GeezTypography.body.copyWith(
                        color: GeezColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Giris Yap',
                        style: GeezTypography.body.copyWith(
                          color: GeezColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: GeezSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
