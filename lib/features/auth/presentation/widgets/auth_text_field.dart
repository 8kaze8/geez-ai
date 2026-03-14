import 'package:flutter/material.dart';
import 'package:geez_ai/core/theme/colors.dart';
import 'package:geez_ai/core/theme/spacing.dart';
import 'package:geez_ai/core/theme/typography.dart';

/// Styled text field for auth screens (login, signup).
///
/// Supports password visibility toggle via [isPassword].
/// Dark mode aware via [GeezColors].
class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.errorText,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final IconData? prefixIcon;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GeezTypography.bodySmall.copyWith(
            color: isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: GeezSpacing.sm),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          style: GeezTypography.body.copyWith(
            color: isDark ? GeezColors.textPrimaryDark : GeezColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GeezTypography.body.copyWith(
              color: GeezColors.textSecondary,
            ),
            errorText: widget.errorText,
            errorStyle: GeezTypography.caption.copyWith(
              color: GeezColors.error,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: GeezColors.textSecondary,
                    size: 20,
                  )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: GeezColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  )
                : null,
            filled: true,
            fillColor: isDark
                ? GeezColors.surfaceDark
                : GeezColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: GeezSpacing.md,
              vertical: GeezSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GeezRadius.button),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GeezRadius.button),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GeezRadius.button),
              borderSide: const BorderSide(
                color: GeezColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GeezRadius.button),
              borderSide: const BorderSide(
                color: GeezColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GeezRadius.button),
              borderSide: const BorderSide(
                color: GeezColors.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
