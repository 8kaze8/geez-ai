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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    await ref.read(authStateProvider.notifier).signIn(
          email: email,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authStateProvider);

    // Navigate on successful auth
    ref.listen<AuthState>(authStateProvider, (prev, next) {
      if (next.isAuthenticated) {
        context.go('/');
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
                      'Tekrar Hosgeldin',
                      style: GeezTypography.h1.copyWith(
                        color: isDark
                            ? GeezColors.textPrimaryDark
                            : GeezColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: GeezSpacing.sm),
                    Text(
                      'Hesabina giris yap ve kesfe devam et',
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
                hint: 'Sifreni gir',
                isPassword: true,
                prefixIcon: Icons.lock_outlined,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleLogin(),
              ),

              const SizedBox(height: GeezSpacing.lg),

              // Login button
              SizedBox(
                width: double.infinity,
                child: GeezButton(
                  label: 'Giris Yap',
                  onTap: _handleLogin,
                  isLoading: authState.isLoading,
                  icon: Icons.login_rounded,
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

              // Go to signup
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hesabin yok mu? ',
                      style: GeezTypography.body.copyWith(
                        color: GeezColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: Text(
                        'Kayit Ol',
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
