import 'package:flutter/material.dart';

import '../strings/auth_strings.dart';
import '../theme/auth_colors.dart';
import '../theme/auth_spacing.dart';
import '../theme/auth_theme.dart';
import '../theme/auth_typography.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';
import 'register_view.dart' show AuthIdentityType;

/// Forgot-password screen: type switcher (phone / email), account field,
/// continue button.
///
/// **Fully controlled** in the same way as [RegisterView] — host owns
/// both controllers, the type toggle, the prefix, every error, the
/// submit handler.
///
/// ## Example
///
/// ```dart
/// ForgotPasswordView(
///   strings: authStrings.forgotPassword,
///   phoneController: _phone,
///   emailController: _email,
///   identityType: _type,
///   onIdentityTypeChanged: (t) => setState(() => _type = t),
///   phonePrefix: _phonePrefix,
///   onPhonePrefixTap: _pickCountry,
///   phoneError: _phoneErr,
///   emailError: _emailErr,
///   canSubmit: _identityNonEmpty,
///   onSubmit: _send,
///   onClose: () => Navigator.of(context).pop(),
/// );
/// ```
class ForgotPasswordView extends StatelessWidget {
  /// Creates a forgot-password view.
  const ForgotPasswordView({
    required this.strings,
    required this.phoneController,
    required this.emailController,
    required this.identityType,
    required this.onIdentityTypeChanged,
    required this.phonePrefix,
    required this.onSubmit,
    super.key,
    this.onPhonePrefixTap,
    this.phoneError,
    this.emailError,
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
  final ForgotPasswordStrings strings;

  /// Phone-number controller (used when [identityType] is phone).
  final TextEditingController phoneController;

  /// Email controller (used when [identityType] is email).
  final TextEditingController emailController;

  /// Current identity type.
  final AuthIdentityType identityType;

  /// Fires when the user taps the type switcher to toggle.
  final ValueChanged<AuthIdentityType> onIdentityTypeChanged;

  /// Currently-selected phone prefix.
  final String phonePrefix;

  /// Submit handler.
  final VoidCallback onSubmit;

  /// Fires when the user taps the phone-prefix chip. `null` makes the
  /// chip non-tappable.
  final VoidCallback? onPhonePrefixTap;

  /// Error rendered under the phone field.
  final String? phoneError;

  /// Error rendered under the email field.
  final String? emailError;

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

  /// Gap between title and switcher. Defaults to 32.
  final double? titleGap;

  /// Gap between the switcher and the account field. Defaults to 16.
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
            _IdentityTypeSwitcher(
              label: strings.byLabel,
              valueLabel: identityType == AuthIdentityType.phone
                  ? strings.phoneTypeLabel
                  : strings.emailTypeLabel,
              onTap: () => onIdentityTypeChanged(
                identityType == AuthIdentityType.phone
                    ? AuthIdentityType.email
                    : AuthIdentityType.phone,
              ),
            ),
            SizedBox(height: fieldGap ?? 16),
            if (identityType == AuthIdentityType.email)
              AuthTextField(
                label: strings.accountLabel,
                hintText: strings.emailHint,
                controller: emailController,
                errorText: emailError,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onSubmitted: canSubmit ? (_) => onSubmit() : null,
              )
            else
              _PhoneField(
                label: strings.accountLabel,
                hint: strings.phoneHint,
                controller: phoneController,
                errorText: phoneError,
                phonePrefix: phonePrefix,
                onPhonePrefixTap: onPhonePrefixTap,
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
            label: strings.continueButton,
            onPressed: canSubmit ? onSubmit : null,
            enabled: canSubmit,
            loading: submitLoading,
          ),
        ),
      ),
    );
  }
}

class _IdentityTypeSwitcher extends StatelessWidget {
  const _IdentityTypeSwitcher({
    required this.label,
    required this.valueLabel,
    required this.onTap,
  });

  final String label;
  final String valueLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final spacing = theme.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: typography.label.copyWith(color: colors.textStrong)),
        SizedBox(height: spacing.fieldLabelGap),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(spacing.inputRadius),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, left: 12, right: 10, bottom: 10),
              decoration: ShapeDecoration(
                color: colors.inputBackground,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: colors.stroke),
                  borderRadius: BorderRadius.circular(spacing.inputRadius),
                ),
                shadows: [
                  BoxShadow(
                    color: colors.shadowSubtle,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      valueLabel,
                      style: typography.label.copyWith(color: colors.textStrong),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, size: 20, color: colors.textStrong),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.errorText,
    required this.phonePrefix,
    required this.onPhonePrefixTap,
    required this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? errorText;
  final String phonePrefix;
  final VoidCallback? onPhonePrefixTap;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final AuthTheme theme = AuthTheme.of(context);
    final AuthColors colors = theme.colors;
    final AuthTypography typography = theme.typography;
    final AuthSpacing spacing = theme.spacing;

    final Widget prefixChip = InkWell(
      onTap: onPhonePrefixTap,
      borderRadius: BorderRadius.circular(spacing.inputRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.inputBackground,
          borderRadius: BorderRadius.circular(spacing.inputRadius),
          border: Border.all(color: colors.stroke),
          boxShadow: [
            BoxShadow(
              color: colors.shadowSubtle,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(phonePrefix, style: typography.bodyMedium.copyWith(color: colors.textStrong)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 14, color: colors.textTertiary),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: typography.label.copyWith(color: colors.textStrong)),
        SizedBox(height: spacing.fieldLabelGap),
        Row(
          children: [
            prefixChip,
            const SizedBox(width: 12),
            Expanded(
              child: AuthTextField(
                label: '',
                hintText: hint,
                controller: controller,
                errorText: errorText,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: onSubmitted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
