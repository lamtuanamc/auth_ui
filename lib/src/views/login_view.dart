import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../assets/auth_assets.dart';
import '../strings/auth_strings.dart';
import '../theme/auth_theme.dart';
import '../widgets/auth_social_button.dart';
import '../widgets/pancake_id_button.dart';

/// Landing screen of an auth flow: brand gradient background, header with
/// logo + heading + "a product of" pill, decorative banner, then a stack of
/// auth-provider buttons followed by a fine-print rich-text link.
///
/// **Fully controlled.** The view neither navigates, nor talks to a network,
/// nor reads/writes storage. Every action is exposed as a callback; every
/// disabled/loading flag is owned by the host.
///
/// **Theme-first, override-everywhere.** [strings] and [assets] are
/// required; every visual property is nullable and falls back to
/// [AuthTheme.of] when omitted.
///
/// ## Example
///
/// ```dart
/// LoginView(
///   strings: AuthStrings.vi(),
///   assets: AuthAssets.bundled,
///   onPancakeIdPressed: _openPancakeIdScreen,
///   onFacebookPressed: _facebookLogin,
///   onGooglePressed: _googleLogin,
///   onApplePressed: _appleLogin,
///   showAppleButton: Platform.isIOS,
///   onPancakeIdLinkPressed: _retryPancakeId,
/// );
/// ```
class LoginView extends StatelessWidget {
  /// Creates a landing login view.
  const LoginView({
    required this.strings,
    required this.assets,
    required this.onPancakeIdPressed,
    super.key,
    this.onFacebookPressed,
    this.onGooglePressed,
    this.onApplePressed,
    this.onPancakeIdLinkPressed,
    // Per-button enabled / loading flags
    this.enabledPancakeId = true,
    this.enabledFacebook = true,
    this.enabledGoogle = true,
    this.enabledApple = true,
    this.loadingPancakeId = false,
    this.loadingFacebook = false,
    this.loadingGoogle = false,
    this.loadingApple = false,
    // Visibility
    this.showFacebookButton = true,
    this.showGoogleButton = true,
    this.showAppleButton = true,
    this.showPancakeIdLink = true,
    // Visual overrides
    this.backgroundGradient,
    this.systemUiOverlayStyle,
    this.headerPadding,
    this.actionStackPadding,
    this.bannerHeight,
    this.bannerHorizontalPadding,
    this.buttonGap,
    this.linkTopGap,
    this.bottomPadding,
    this.headerOverride,
    this.bannerOverride,
    this.linkOverride,
    this.logo,
    this.background,
  });

  // -------------------------------------------------------------------
  // Required inputs
  // -------------------------------------------------------------------

  /// Per-screen localized strings (the [LoginStrings] subset of
  /// [AuthStrings]). Use `authStrings.login` to forward the bundle from
  /// the top-level [AuthStrings].
  final LoginStrings strings;

  /// Asset paths and owning package.
  final AuthAssets assets;

  /// Tap handler for the primary Pancake ID CTA.
  final VoidCallback onPancakeIdPressed;

  // -------------------------------------------------------------------
  // Optional callbacks
  // -------------------------------------------------------------------

  /// Tap handler for the Facebook button. Pass `null` and set
  /// [showFacebookButton] to `false` to hide it entirely.
  final VoidCallback? onFacebookPressed;

  /// Tap handler for the Google button.
  final VoidCallback? onGooglePressed;

  /// Tap handler for the Apple button.
  final VoidCallback? onApplePressed;

  /// Tap handler for the inline "Ấn vào đây" rich-text link at the bottom
  /// of the screen.
  final VoidCallback? onPancakeIdLinkPressed;

  // -------------------------------------------------------------------
  // Per-button state
  // -------------------------------------------------------------------

  /// Whether the Pancake ID button accepts taps.
  final bool enabledPancakeId;

  /// Whether the Facebook button accepts taps.
  final bool enabledFacebook;

  /// Whether the Google button accepts taps.
  final bool enabledGoogle;

  /// Whether the Apple button accepts taps.
  final bool enabledApple;

  /// When true, the Pancake ID button shows a spinner instead of label.
  final bool loadingPancakeId;

  /// When true, the Facebook button shows a spinner instead of label.
  final bool loadingFacebook;

  /// When true, the Google button shows a spinner instead of label.
  final bool loadingGoogle;

  /// When true, the Apple button shows a spinner instead of label.
  final bool loadingApple;

  // -------------------------------------------------------------------
  // Visibility
  // -------------------------------------------------------------------

  /// Renders the Facebook button when true.
  final bool showFacebookButton;

  /// Renders the Google button when true.
  final bool showGoogleButton;

  /// Renders the Apple button when true. Hosts typically wire this to
  /// `Platform.isIOS` so the button only appears on iOS.
  final bool showAppleButton;

  /// Renders the "Nếu bạn đang bị lỗi đăng nhập …" link.
  final bool showPancakeIdLink;

  // -------------------------------------------------------------------
  // Visual overrides
  // -------------------------------------------------------------------

  /// Replace the default top-to-bottom background gradient. Defaults to
  /// `theme.colors.backgroundGradientStart` →
  /// `theme.colors.backgroundGradientEnd`.
  final Gradient? backgroundGradient;

  /// Override the system overlay (status bar / nav bar icon brightness).
  /// Defaults to [SystemUiOverlayStyle.dark].
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  /// Padding around the header (logo + heading + pill). Defaults to
  /// `theme.spacing.pagePadding`.
  final EdgeInsetsGeometry? headerPadding;

  /// Padding around the button stack. Defaults to horizontal
  /// `theme.spacing.pagePaddingHorizontal`.
  final EdgeInsetsGeometry? actionStackPadding;

  /// Height of the decorative banner. Defaults to `theme.spacing.bannerHeight`.
  final double? bannerHeight;

  /// Horizontal padding around the banner. Defaults to
  /// `theme.spacing.pagePaddingHorizontal`.
  final double? bannerHorizontalPadding;

  /// Gap between two stacked buttons in the action stack. Defaults to
  /// `theme.spacing.buttonGap` (12).
  final double? buttonGap;

  /// Vertical gap above the bottom rich-text link. Defaults to 16.
  final double? linkTopGap;

  /// Bottom padding of the scroll content. Defaults to
  /// `theme.spacing.pagePaddingVertical`.
  final double? bottomPadding;

  /// Replace the default header (logo + heading + pill) entirely.
  final Widget? headerOverride;

  /// Replace the default banner illustration entirely.
  final Widget? bannerOverride;

  /// Replace the default bottom rich-text link entirely.
  final Widget? linkOverride;

  /// Replace only the brand logo widget rendered inside the default
  /// header. Has no effect when [headerOverride] is provided (the entire
  /// header is replaced).
  final Widget? logo;

  /// Replace the entire screen background. When set, takes precedence
  /// over [backgroundGradient]. Use for image backgrounds, multi-stop
  /// gradients, or solid colors:
  ///
  /// ```dart
  /// background: BoxDecoration(
  ///   image: DecorationImage(image: AssetImage('bg.png'), fit: BoxFit.cover),
  /// ),
  /// ```
  final Decoration? background;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final spacing = theme.spacing;
    final typography = theme.typography;

    final Decoration resolvedBackground = background ??
        BoxDecoration(
          gradient: backgroundGradient ??
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colors.backgroundGradientStart, colors.backgroundGradientEnd],
              ),
        );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: resolvedBackground,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: systemUiOverlayStyle ?? SystemUiOverlayStyle.dark,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (innerContext, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomPadding ?? spacing.pagePaddingVertical),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          headerOverride ?? _Header(strings: strings, assets: assets, logo: logo),
                          if (bannerOverride != null)
                            bannerOverride!
                          else
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: bannerHorizontalPadding ?? spacing.pagePaddingHorizontal,
                              ),
                              child: SvgPicture.asset(
                                assets.banner,
                                package: assets.packageName,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: bannerHeight ?? spacing.bannerHeight,
                              ),
                            ),
                          Padding(
                            padding: actionStackPadding ??
                                EdgeInsets.symmetric(
                                  horizontal: spacing.pagePaddingHorizontal,
                                ),
                            child: _ActionStack(
                              strings: strings,
                              assets: assets,
                              gap: buttonGap ?? spacing.buttonGap,
                              showFacebookButton: showFacebookButton,
                              showGoogleButton: showGoogleButton,
                              showAppleButton: showAppleButton,
                              enabledPancakeId: enabledPancakeId,
                              enabledFacebook: enabledFacebook,
                              enabledGoogle: enabledGoogle,
                              enabledApple: enabledApple,
                              loadingPancakeId: loadingPancakeId,
                              loadingFacebook: loadingFacebook,
                              loadingGoogle: loadingGoogle,
                              loadingApple: loadingApple,
                              onPancakeIdPressed: onPancakeIdPressed,
                              onFacebookPressed: onFacebookPressed,
                              onGooglePressed: onGooglePressed,
                              onApplePressed: onApplePressed,
                            ),
                          ),
                          if (showPancakeIdLink)
                            Padding(
                              padding: EdgeInsets.only(top: linkTopGap ?? 16),
                              child: linkOverride ??
                                  Center(
                                    child: _PancakeIdLink(
                                      strings: strings,
                                      prefixStyle: typography.bodyMedium
                                          .copyWith(color: colors.textSecondary),
                                      linkStyle: typography.linkPrimary.copyWith(color: colors.link),
                                      onTap: onPancakeIdLinkPressed,
                                    ),
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.strings, required this.assets, this.logo});

  final LoginStrings strings;
  final AuthAssets assets;
  final Widget? logo;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final spacing = theme.spacing;

    return Padding(
      padding: spacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          logo ??
              SvgPicture.asset(
                assets.logo,
                package: assets.packageName,
                height: spacing.logoHeight,
                fit: BoxFit.cover,
              ),
          const SizedBox(height: 12),
          Text(strings.heading, style: typography.heading.copyWith(color: colors.textStrong)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: ShapeDecoration(
              color: colors.pillBackground,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: colors.pillBorder),
                borderRadius: BorderRadius.circular(spacing.pillRadius),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  strings.aProductOf,
                  style: typography.bodySmall.copyWith(color: colors.textSecondary, height: 1),
                ),
                const SizedBox(width: 6),
                Image.asset(
                  assets.pancakeLogo,
                  package: assets.packageName,
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionStack extends StatelessWidget {
  const _ActionStack({
    required this.strings,
    required this.assets,
    required this.gap,
    required this.showFacebookButton,
    required this.showGoogleButton,
    required this.showAppleButton,
    required this.enabledPancakeId,
    required this.enabledFacebook,
    required this.enabledGoogle,
    required this.enabledApple,
    required this.loadingPancakeId,
    required this.loadingFacebook,
    required this.loadingGoogle,
    required this.loadingApple,
    required this.onPancakeIdPressed,
    required this.onFacebookPressed,
    required this.onGooglePressed,
    required this.onApplePressed,
  });

  final LoginStrings strings;
  final AuthAssets assets;
  final double gap;
  final bool showFacebookButton;
  final bool showGoogleButton;
  final bool showAppleButton;
  final bool enabledPancakeId;
  final bool enabledFacebook;
  final bool enabledGoogle;
  final bool enabledApple;
  final bool loadingPancakeId;
  final bool loadingFacebook;
  final bool loadingGoogle;
  final bool loadingApple;
  final VoidCallback onPancakeIdPressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final spacing = theme.spacing;

    return Column(
      children: [
        PancakeIdButton(
          label: strings.pancakeIdButton,
          onPressed: onPancakeIdPressed,
          enabled: enabledPancakeId,
          loading: loadingPancakeId,
          icon: SvgPicture.asset(
            assets.pancakeLogoColor,
            package: assets.packageName,
            height: 24,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(colors.primaryButtonForeground, BlendMode.srcIn),
          ),
          background: SvgPicture.asset(
            assets.pancakeIdButtonBackground,
            package: assets.packageName,
            fit: BoxFit.fill,
          ),
        ),
        if (showFacebookButton) ...[
          SizedBox(height: gap),
          AuthSocialButton(
            style: AuthSocialButtonStyle.facebook,
            label: strings.facebookButton,
            onPressed: onFacebookPressed,
            enabled: enabledFacebook,
            loading: loadingFacebook,
            icon: SvgPicture.asset(
              assets.facebookBrandIcon,
              package: assets.packageName,
              height: spacing.iconSize,
              fit: BoxFit.cover,
            ),
          ),
        ],
        if (showGoogleButton) ...[
          SizedBox(height: gap),
          AuthSocialButton(
            style: AuthSocialButtonStyle.google,
            label: strings.googleButton,
            onPressed: onGooglePressed,
            enabled: enabledGoogle,
            loading: loadingGoogle,
            icon: SvgPicture.asset(
              assets.googleIcon,
              package: assets.packageName,
              height: spacing.iconSize,
              fit: BoxFit.cover,
            ),
          ),
        ],
        if (showAppleButton) ...[
          SizedBox(height: gap),
          AuthSocialButton(
            style: AuthSocialButtonStyle.apple,
            label: strings.appleButton,
            onPressed: onApplePressed,
            enabled: enabledApple,
            loading: loadingApple,
            icon: Icon(
              Icons.apple,
              size: spacing.iconSize,
              color: colors.appleForeground,
            ),
          ),
        ],
      ],
    );
  }
}

class _PancakeIdLink extends StatelessWidget {
  const _PancakeIdLink({
    required this.strings,
    required this.prefixStyle,
    required this.linkStyle,
    required this.onTap,
  });

  final LoginStrings strings;
  final TextStyle prefixStyle;
  final TextStyle linkStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: strings.linkPrefix, style: prefixStyle),
          TextSpan(
            text: strings.linkAction,
            style: linkStyle,
            recognizer: _LinkTapRecognizer.create(onTap),
          ),
        ],
      ),
    );
  }
}

/// Encapsulates the [GestureRecognizer] used by the inline link so the
/// rest of the file doesn't import `package:flutter/gestures.dart`
/// directly.
class _LinkTapRecognizer {
  static GestureRecognizer? create(VoidCallback? onTap) {
    if (onTap == null) {
      return null;
    }
    return TapGestureRecognizer()..onTap = onTap;
  }
}
