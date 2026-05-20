import 'package:flutter/material.dart';

import '../strings/auth_strings.dart';
import '../theme/auth_theme.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_text_field.dart';

/// Choice for the register / forgot-password type switcher.
///
/// The view is locale-agnostic — labels come from [RegisterStrings] or
/// [ForgotPasswordStrings]. The enum only encodes which input the screen
/// should render next.
enum AuthIdentityType {
  /// Phone-number flow. The account field renders a country-code chip on
  /// the leading edge.
  phone,

  /// Email flow. The account field renders without a leading chip.
  email,
}

/// Register screen: first/last name, identity (phone OR email),
/// password, confirm password.
///
/// **Fully controlled.** The host owns every controller, every error
/// string, the [identityType] toggle, the phone prefix, the obscure
/// flags, the gating boolean, and the submit handler. The view never
/// calls navigation or storage.
///
/// **Country code picker is host-owned.** The view renders the current
/// [phonePrefix] as a tappable chip and emits [onPhonePrefixTap]. The
/// host shows its own picker / bottom sheet and updates [phonePrefix].
///
/// ## Example
///
/// ```dart
/// RegisterView(
///   strings: authStrings.register,
///   firstNameController: _firstNameCtrl,
///   lastNameController: _lastNameCtrl,
///   phoneController: _phoneCtrl,
///   emailController: _emailCtrl,
///   passwordController: _pwdCtrl,
///   confirmPasswordController: _confirmCtrl,
///   identityType: _type,
///   onIdentityTypeChanged: (t) => setState(() => _type = t),
///   phonePrefix: _phonePrefix,
///   onPhonePrefixTap: _showCountryPicker,
///   obscurePassword: _obscurePwd,
///   obscureConfirm: _obscureConfirm,
///   onObscurePasswordToggle: () => setState(() => _obscurePwd = !_obscurePwd),
///   onObscureConfirmToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
///   canSubmit: _formValid,
///   onSubmit: _doRegister,
///   onClose: () => Navigator.of(context).pop(),
/// );
/// ```
class RegisterView extends StatelessWidget {
  /// Creates a register view.
  const RegisterView({
    required this.strings,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.identityType,
    required this.onIdentityTypeChanged,
    required this.phonePrefix,
    required this.onSubmit,
    super.key,
    this.onPhonePrefixTap,
    this.firstNameError,
    this.lastNameError,
    this.phoneError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
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
    this.fieldGap,
    this.titleGap,
    this.formGap,
    this.logo,
    this.titleStyle,
    this.subtitleStyle,
  });

  /// Localized strings.
  final RegisterStrings strings;

  /// First-name input controller.
  final TextEditingController firstNameController;

  /// Last-name input controller.
  final TextEditingController lastNameController;

  /// Phone-number input controller. Used only when
  /// [identityType] == [AuthIdentityType.phone].
  final TextEditingController phoneController;

  /// Email input controller. Used only when
  /// [identityType] == [AuthIdentityType.email].
  final TextEditingController emailController;

  /// Password input controller.
  final TextEditingController passwordController;

  /// Confirm-password input controller.
  final TextEditingController confirmPasswordController;

  /// Currently selected identity type. The view renders the matching
  /// field (phone OR email) and the matching hint / error.
  final AuthIdentityType identityType;

  /// Fires when the user taps the type switcher to toggle between phone
  /// and email.
  final ValueChanged<AuthIdentityType> onIdentityTypeChanged;

  /// Currently selected phone prefix (e.g. `'+84'`). Rendered as a
  /// tappable chip on the leading edge of the phone input.
  final String phonePrefix;

  /// Submit handler invoked when the bottom CTA is tapped while
  /// [canSubmit] is true.
  final VoidCallback onSubmit;

  /// Fires when the user taps the phone-prefix chip. Hosts open their
  /// own country picker. When `null` the chip is not tappable.
  final VoidCallback? onPhonePrefixTap;

  /// Error rendered under the first-name field.
  final String? firstNameError;

  /// Error rendered under the last-name field.
  final String? lastNameError;

  /// Error rendered under the phone field.
  final String? phoneError;

  /// Error rendered under the email field.
  final String? emailError;

  /// Error rendered under the password field.
  final String? passwordError;

  /// Error rendered under the confirm-password field. Hosts typically
  /// set this when the two passwords mismatch.
  final String? confirmPasswordError;

  /// Whether the password input masks characters.
  final bool obscurePassword;

  /// Whether the confirm-password input masks characters.
  final bool obscureConfirm;

  /// Toggle for the password eye icon. `null` hides the icon.
  final VoidCallback? onObscurePasswordToggle;

  /// Toggle for the confirm-password eye icon. `null` hides the icon.
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

  /// Vertical gap between consecutive form fields. Defaults to 16.
  final double? fieldGap;

  /// Gap between title and subtitle. Defaults to 6.
  final double? titleGap;

  /// Gap between subtitle and first input. Defaults to 32.
  final double? formGap;

  /// Optional logo above the title.
  final Widget? logo;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Subtitle text style.
  final TextStyle? subtitleStyle;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final double gap = fieldGap ?? 16;

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
            SizedBox(height: titleGap ?? 6),
            Text(
              strings.subtitle,
              style:
                  subtitleStyle ?? typography.subtitle.copyWith(color: colors.textSecondary),
            ),
            SizedBox(height: formGap ?? 32),
            AuthTextField(
              label: strings.firstNameLabel,
              hintText: strings.firstNameHint,
              controller: firstNameController,
              errorText: firstNameError,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: gap),
            AuthTextField(
              label: strings.lastNameLabel,
              hintText: strings.lastNameHint,
              controller: lastNameController,
              errorText: lastNameError,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: gap),
            _IdentityTypeSwitcher(
              label: strings.registerByLabel,
              valueLabel: identityType == AuthIdentityType.phone
                  ? strings.phoneTypeLabel
                  : strings.emailTypeLabel,
              onTap: () => onIdentityTypeChanged(
                identityType == AuthIdentityType.phone
                    ? AuthIdentityType.email
                    : AuthIdentityType.phone,
              ),
            ),
            SizedBox(height: gap),
            _AccountField(
              label: strings.accountLabel,
              identityType: identityType,
              phoneController: phoneController,
              emailController: emailController,
              phoneHint: strings.phoneHint,
              emailHint: strings.emailHint,
              phoneError: phoneError,
              emailError: emailError,
              phonePrefix: phonePrefix,
              onPhonePrefixTap: onPhonePrefixTap,
            ),
            SizedBox(height: gap),
            AuthTextField(
              label: strings.passwordLabel,
              hintText: strings.passwordHint,
              controller: passwordController,
              errorText: passwordError,
              obscureText: obscurePassword,
              onObscureToggle: onObscurePasswordToggle,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: gap),
            AuthTextField(
              label: strings.confirmPasswordLabel,
              hintText: strings.confirmPasswordHint,
              controller: confirmPasswordController,
              errorText: confirmPasswordError,
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
            label: strings.registerButton,
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
                  Icon(Icons.unfold_more, size: 16, color: colors.textStrong),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AccountField extends StatelessWidget {
  const _AccountField({
    required this.label,
    required this.identityType,
    required this.phoneController,
    required this.emailController,
    required this.phoneHint,
    required this.emailHint,
    required this.phoneError,
    required this.emailError,
    required this.phonePrefix,
    required this.onPhonePrefixTap,
  });

  final String label;
  final AuthIdentityType identityType;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final String phoneHint;
  final String emailHint;
  final String? phoneError;
  final String? emailError;
  final String phonePrefix;
  final VoidCallback? onPhonePrefixTap;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final spacing = theme.spacing;

    if (identityType == AuthIdentityType.email) {
      return AuthTextField(
        label: label,
        hintText: emailHint,
        controller: emailController,
        errorText: emailError,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      );
    }

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
            BoxShadow(color: colors.shadowSubtle, blurRadius: 2, offset: const Offset(0, 1)),
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
                hintText: phoneHint,
                controller: phoneController,
                errorText: phoneError,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
