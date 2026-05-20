import 'package:flutter/material.dart';

import '../strings/auth_strings.dart';
import '../theme/auth_theme.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

/// Reset-password screen: new password, confirm password, submit button.
///
/// **Fully controlled.** Host owns both controllers, both obscure flags,
/// the gating boolean, the error string, and the submit handler.
///
/// ## Example
///
/// ```dart
/// ResetPasswordView(
///   strings: authStrings.resetPassword,
///   passwordController: _pwdCtrl,
///   confirmPasswordController: _confirmCtrl,
///   passwordError: _pwdErr,
///   obscurePassword: _hidden1,
///   obscureConfirm: _hidden2,
///   onObscurePasswordToggle: () => setState(() => _hidden1 = !_hidden1),
///   onObscureConfirmToggle: () => setState(() => _hidden2 = !_hidden2),
///   canSubmit: _bothFieldsFilled,
///   onSubmit: _reset,
///   onClose: () => Navigator.of(context).pop(),
/// );
/// ```
class ResetPasswordView extends StatelessWidget {
  /// Creates a reset-password view.
  const ResetPasswordView({
    required this.strings,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSubmit,
    super.key,
    this.passwordError,
    this.obscurePassword = true,
    this.obscureConfirm = true,
    this.onObscurePasswordToggle,
    this.onObscureConfirmToggle,
    this.canSubmit = true,
    this.submitLoading = false,
    this.onClose,
    // Visual overrides
    this.backgroundColor,
    this.background,
    this.bodyPadding,
    this.bottomBarPadding,
    this.titleStyle,
    this.titleGap,
    this.fieldGap,
    this.logo,
  });

  /// Localized strings.
  final ResetPasswordStrings strings;

  /// New-password controller.
  final TextEditingController passwordController;

  /// Confirm-password controller.
  final TextEditingController confirmPasswordController;

  /// Submit handler.
  final VoidCallback onSubmit;

  /// Error rendered between the two fields and in red. The original
  /// design renders the same error under both fields' borders; mirror
  /// that by re-passing this same value to your own error wiring.
  final String? passwordError;

  /// Whether the new-password input masks characters.
  final bool obscurePassword;

  /// Whether the confirm-password input masks characters.
  final bool obscureConfirm;

  /// Toggle for the new-password eye icon.
  final VoidCallback? onObscurePasswordToggle;

  /// Toggle for the confirm-password eye icon.
  final VoidCallback? onObscureConfirmToggle;

  /// Gates the submit button.
  final bool canSubmit;

  /// When true, the submit button shows a spinner.
  final bool submitLoading;

  /// Tap handler for the close button. `null` hides it.
  final VoidCallback? onClose;

  // --- Visual overrides ----------------------------------------------------

  /// Scaffold background color.
  final Color? backgroundColor;

  /// Full-screen background decoration.
  final Decoration? background;

  /// Body padding. Defaults to `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? bodyPadding;

  /// Bottom-bar padding. Defaults to `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? bottomBarPadding;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Gap between title and first field. Defaults to 32.
  final double? titleGap;

  /// Gap between password and confirm-password. Defaults to 16.
  final double? fieldGap;

  /// Optional logo above the title.
  final Widget? logo;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final Widget body = SingleChildScrollView(
      child: Padding(
        padding: bodyPadding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (logo != null) Padding(padding: const EdgeInsets.only(bottom: 16), child: logo),
            Text(
              strings.title,
              style: titleStyle ??
                  typography.title.copyWith(fontSize: 24, color: colors.textStrong),
            ),
            SizedBox(height: titleGap ?? 32),
            AuthTextField(
              label: strings.passwordLabel,
              hintText: strings.passwordHint,
              controller: passwordController,
              errorText: passwordError,
              obscureText: obscurePassword,
              onObscureToggle: onObscurePasswordToggle,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: fieldGap ?? 16),
            AuthTextField(
              label: strings.confirmPasswordLabel,
              hintText: strings.confirmPasswordHint,
              controller: confirmPasswordController,
              errorText: passwordError,
              obscureText: obscureConfirm,
              onObscureToggle: onObscureConfirmToggle,
              textInputAction: TextInputAction.done,
              onSubmitted: canSubmit ? (_) => onSubmit() : null,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: background != null ? Colors.transparent : (backgroundColor ?? Colors.white),
      appBar: AuthAppBar(onClose: onClose),
      body: background == null ? body : DecoratedBox(decoration: background!, child: body),
      bottomNavigationBar: BottomAppBar(
        color: background != null ? Colors.transparent : (backgroundColor ?? Colors.white),
        shadowColor: Colors.transparent,
        child: Padding(
          padding: bottomBarPadding ?? const EdgeInsets.all(16),
          child: AuthPrimaryButton(
            label: strings.submitButton,
            onPressed: canSubmit ? onSubmit : null,
            enabled: canSubmit,
            loading: submitLoading,
          ),
        ),
      ),
    );
  }
}
