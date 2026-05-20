import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../assets/auth_assets.dart';
import '../strings/auth_strings.dart';
import '../theme/auth_theme.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_social_button.dart';
import '../widgets/auth_text_field.dart';

/// Credential screen: identity + password fields, submit button, optional
/// "forgot password" link, optional social-login row, optional bottom
/// "register now" CTA.
///
/// **Fully controlled.** The host owns:
/// - both [TextEditingController]s,
/// - the obscure-password toggle,
/// - validation state (`identityError`, `passwordError`),
/// - the gating boolean (`canSubmit`),
/// - the submit / loading flags,
/// - every callback (no navigation happens inside the view).
///
/// **Theme-first, override-everywhere.** [strings] and [assets] are
/// required; every visual property below is nullable and resolves through
/// [AuthTheme.of] when omitted.
///
/// ## Example
///
/// ```dart
/// PancakeIdLoginView(
///   strings: authStrings.pancakeIdLogin,
///   assets: AuthAssets.bundled,
///   identityController: _identityCtrl,
///   passwordController: _passwordCtrl,
///   identityError: _identityErr,
///   passwordError: _passwordErr,
///   obscurePassword: _obscured,
///   onObscureToggle: () => setState(() => _obscured = !_obscured),
///   canSubmit: _identity.isNotEmpty && _password.isNotEmpty,
///   submitLoading: _submitting,
///   onSubmit: _signin,
///   onClose: () => Navigator.of(context).pop(),
///   onForgotPassword: _goToForgotPassword,
///   onSignUp: _goToRegister,
///   onFacebookPressed: _facebook,
///   onGooglePressed: _google,
///   onApplePressed: _apple,
///   showAppleButton: Platform.isIOS,
/// );
/// ```
class PancakeIdLoginView extends StatelessWidget {
  /// Creates a credential view.
  const PancakeIdLoginView({
    required this.strings,
    required this.assets,
    required this.identityController,
    required this.passwordController,
    required this.onSubmit,
    super.key,
    this.identityError,
    this.passwordError,
    this.obscurePassword = true,
    this.onObscureToggle,
    this.canSubmit = true,
    this.submitLoading = false,
    this.onClose,
    this.onForgotPassword,
    this.onSignUp,
    this.onFacebookPressed,
    this.onGooglePressed,
    this.onApplePressed,
    this.showFacebookButton = true,
    this.showGoogleButton = true,
    this.showAppleButton = true,
    this.showRegisterPrompt = true,
    this.enabledFacebook = true,
    this.enabledGoogle = true,
    this.enabledApple = true,
    this.loadingFacebook = false,
    this.loadingGoogle = false,
    this.loadingApple = false,
    // Visual overrides
    this.backgroundColor,
    this.bodyPadding,
    this.bottomBarPadding,
    this.headerGap,
    this.subtitleGap,
    this.formGap,
    this.fieldGap,
    this.forgotPasswordGap,
    this.submitGap,
    this.socialDividerGap,
    this.logo,
    this.background,
  });

  /// Localized strings.
  final PancakeIdLoginStrings strings;

  /// Asset configuration (only the social-row icons are read here).
  final AuthAssets assets;

  /// Identity (phone / email / username) text controller.
  final TextEditingController identityController;

  /// Password text controller.
  final TextEditingController passwordController;

  /// Called when the submit button is tapped while [canSubmit] is true.
  final VoidCallback onSubmit;

  /// Error rendered under the identity field. `null` or empty hides it.
  final String? identityError;

  /// Error rendered under the password field.
  final String? passwordError;

  /// Whether the password input masks characters.
  final bool obscurePassword;

  /// Invoked when the eye-toggle suffix is tapped. Pass `null` to hide
  /// the suffix.
  final VoidCallback? onObscureToggle;

  /// Gates the submit button. Typically computed in the host as
  /// `identity.isNotEmpty && password.isNotEmpty`.
  final bool canSubmit;

  /// When true, the submit button shows a spinner.
  final bool submitLoading;

  /// Tap handler for the close-button in the app bar. When `null` the
  /// close button is hidden.
  final VoidCallback? onClose;

  /// Tap handler for the "Quên mật khẩu?" link. When `null` the link is
  /// not rendered.
  final VoidCallback? onForgotPassword;

  /// Tap handler for the bottom "Đăng ký ngay" CTA. When `null` the
  /// bottom bar collapses.
  final VoidCallback? onSignUp;

  /// Tap handler for the compact Facebook social button.
  final VoidCallback? onFacebookPressed;

  /// Tap handler for the compact Google social button.
  final VoidCallback? onGooglePressed;

  /// Tap handler for the compact Apple social button.
  final VoidCallback? onApplePressed;

  /// Renders the Facebook compact button when true.
  final bool showFacebookButton;

  /// Renders the Google compact button when true.
  final bool showGoogleButton;

  /// Renders the Apple compact button when true. Hosts typically wire
  /// this to `Platform.isIOS`.
  final bool showAppleButton;

  /// Renders the bottom "noAccountPrompt + registerNow" CTA when true.
  final bool showRegisterPrompt;

  /// Whether the Facebook compact button accepts taps.
  final bool enabledFacebook;

  /// Whether the Google compact button accepts taps.
  final bool enabledGoogle;

  /// Whether the Apple compact button accepts taps.
  final bool enabledApple;

  /// When true, Facebook button shows a spinner (rare in icon-only row).
  final bool loadingFacebook;

  /// When true, Google button shows a spinner.
  final bool loadingGoogle;

  /// When true, Apple button shows a spinner.
  final bool loadingApple;

  // --- Visual overrides ----------------------------------------------------

  /// Scaffold background. Defaults to white.
  final Color? backgroundColor;

  /// Padding around the scrollable body content. Defaults to
  /// `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? bodyPadding;

  /// Padding inside the bottom register-CTA bar. Defaults to
  /// `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? bottomBarPadding;

  /// Gap between the logo and the title. Defaults to 16.
  final double? headerGap;

  /// Gap between the title and the subtitle. Defaults to 6.
  final double? subtitleGap;

  /// Gap between the subtitle and the first input. Defaults to 32.
  final double? formGap;

  /// Gap between two stacked inputs. Defaults to 16.
  final double? fieldGap;

  /// Gap between the last input and the "forgot password" link. Defaults
  /// to 16.
  final double? forgotPasswordGap;

  /// Gap between the "forgot password" link and the submit button.
  /// Defaults to 16.
  final double? submitGap;

  /// Gap between the submit button and the "or login with" divider.
  /// Defaults to 12.
  final double? socialDividerGap;

  /// Replace the default brand logo widget rendered above the title.
  /// Pass `const SizedBox.shrink()` to drop the logo entirely.
  final Widget? logo;

  /// Replace the entire screen background. Wraps the [Scaffold] body in a
  /// [DecoratedBox] when set. Takes precedence over [backgroundColor].
  final Decoration? background;

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
            logo ??
                SvgPicture.asset(
                  assets.logo,
                  package: assets.packageName,
                  height: theme.spacing.logoHeight,
                  fit: BoxFit.cover,
                ),
            SizedBox(height: headerGap ?? 16),
            Text(strings.title, style: typography.title.copyWith(color: colors.textStrong)),
            SizedBox(height: subtitleGap ?? 6),
            Text(
              strings.subtitle,
              style: typography.subtitle.copyWith(color: colors.textSecondary),
            ),
            SizedBox(height: formGap ?? 32),
            AuthTextField(
              label: strings.accountLabel,
              controller: identityController,
              errorText: identityError,
              autofocus: true,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: fieldGap ?? 16),
            AuthTextField(
              label: strings.passwordLabel,
              controller: passwordController,
              errorText: passwordError,
              obscureText: obscurePassword,
              onObscureToggle: onObscureToggle,
              textInputAction: TextInputAction.done,
              onSubmitted: canSubmit ? (_) => onSubmit() : null,
            ),
            if (onForgotPassword != null) ...[
              SizedBox(height: forgotPasswordGap ?? 16),
              InkWell(
                onTap: onForgotPassword,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Text(
                    strings.forgotPassword,
                    style: typography.linkSecondary.copyWith(color: colors.textSecondary),
                  ),
                ),
              ),
            ],
            SizedBox(height: submitGap ?? 16),
            AuthPrimaryButton(
              label: strings.loginButton,
              onPressed: canSubmit ? onSubmit : null,
              enabled: canSubmit,
              loading: submitLoading,
            ),
            SizedBox(height: socialDividerGap ?? 12),
            if (_hasSocial)
              _SocialRow(
                strings: strings,
                assets: assets,
                showFacebookButton: showFacebookButton,
                showGoogleButton: showGoogleButton,
                showAppleButton: showAppleButton,
                enabledFacebook: enabledFacebook,
                enabledGoogle: enabledGoogle,
                enabledApple: enabledApple,
                loadingFacebook: loadingFacebook,
                loadingGoogle: loadingGoogle,
                loadingApple: loadingApple,
                onFacebookPressed: onFacebookPressed,
                onGooglePressed: onGooglePressed,
                onApplePressed: onApplePressed,
              ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: background != null ? Colors.transparent : (backgroundColor ?? Colors.white),
      appBar: AuthAppBar(onClose: onClose),
      body: background == null
          ? body
          : DecoratedBox(decoration: background!, child: body),
      bottomNavigationBar: (showRegisterPrompt && onSignUp != null)
          ? BottomAppBar(
              color: background != null
                  ? Colors.transparent
                  : (backgroundColor ?? Colors.white),
              shadowColor: Colors.transparent,
              child: Padding(
                padding: bottomBarPadding ?? const EdgeInsets.all(16),
                child: InkWell(
                  onTap: onSignUp,
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: typography.bodyMedium.copyWith(color: colors.textSecondary),
                          children: [
                            TextSpan(text: strings.noAccountPrompt),
                            TextSpan(
                              text: strings.registerNowAction,
                              style: typography.linkSecondary.copyWith(color: colors.accent),
                            ),
                            const WidgetSpan(child: SizedBox(width: 4)),
                            WidgetSpan(
                              child: Icon(Icons.arrow_forward, size: 16, color: colors.accent),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  bool get _hasSocial =>
      (showFacebookButton && onFacebookPressed != null) ||
      (showGoogleButton && onGooglePressed != null) ||
      (showAppleButton && onApplePressed != null);
}

class _SocialRow extends StatelessWidget {
  const _SocialRow({
    required this.strings,
    required this.assets,
    required this.showFacebookButton,
    required this.showGoogleButton,
    required this.showAppleButton,
    required this.enabledFacebook,
    required this.enabledGoogle,
    required this.enabledApple,
    required this.loadingFacebook,
    required this.loadingGoogle,
    required this.loadingApple,
    required this.onFacebookPressed,
    required this.onGooglePressed,
    required this.onApplePressed,
  });

  final PancakeIdLoginStrings strings;
  final AuthAssets assets;
  final bool showFacebookButton;
  final bool showGoogleButton;
  final bool showAppleButton;
  final bool enabledFacebook;
  final bool enabledGoogle;
  final bool enabledApple;
  final bool loadingFacebook;
  final bool loadingGoogle;
  final bool loadingApple;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final spacing = theme.spacing;

    final List<Widget> buttons = [
      if (showFacebookButton && onFacebookPressed != null)
        Expanded(
          child: AuthSocialIconButton(
            onPressed: onFacebookPressed,
            enabled: enabledFacebook && !loadingFacebook,
            icon: SvgPicture.asset(
              assets.facebookCompactIcon,
              package: assets.packageName,
              height: spacing.iconSize,
              width: spacing.iconSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
      if (showGoogleButton && onGooglePressed != null)
        Expanded(
          child: AuthSocialIconButton(
            onPressed: onGooglePressed,
            enabled: enabledGoogle && !loadingGoogle,
            icon: SvgPicture.asset(
              assets.googleIcon,
              package: assets.packageName,
              height: spacing.iconSize,
              width: spacing.iconSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
      if (showAppleButton && onApplePressed != null)
        Expanded(
          child: AuthSocialIconButton(
            onPressed: onApplePressed,
            enabled: enabledApple && !loadingApple,
            icon: Icon(Icons.apple, size: spacing.iconSize, color: colors.appleBackground),
          ),
        ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: colors.divider)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                strings.loginWithDivider,
                style: typography.dividerLabel.copyWith(color: colors.textTertiary),
              ),
            ),
            Expanded(child: Divider(thickness: 1, color: colors.divider)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 0; i < buttons.length; i++) ...[
              buttons[i],
              if (i < buttons.length - 1) const SizedBox(width: 16),
            ],
          ],
        ),
      ],
    );
  }
}
