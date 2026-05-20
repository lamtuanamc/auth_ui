import 'package:flutter/material.dart';

import '../theme/auth_theme.dart';

/// Brand style for [AuthSocialButton]. Controls the default background,
/// foreground, and border resolution when no per-instance override is
/// passed. Hosts that need a brand outside this list should use
/// [AuthSocialButtonStyle.custom] and supply all three colors explicitly.
enum AuthSocialButtonStyle {
  /// Facebook — solid blue background, white foreground, no border.
  facebook,

  /// Google — white background, dark foreground, neutral border.
  google,

  /// Apple — solid black background, white foreground, no border.
  apple,

  /// Caller-provided colors. No defaults are read from theme; pass
  /// [AuthSocialButton.backgroundColor], [AuthSocialButton.foregroundColor],
  /// and [AuthSocialButton.borderColor] explicitly.
  custom,
}

/// Full-width branded button used on the landing login screen for social
/// providers (Facebook, Google, Apple, …).
///
/// **Theme-first, override-everywhere.** Pick a [style] for sensible
/// brand defaults; pass any override to swap colors / sizing locally
/// without touching the theme.
///
/// ## Example
///
/// ```dart
/// AuthSocialButton(
///   style: AuthSocialButtonStyle.facebook,
///   label: 'Đăng nhập với Facebook',
///   icon: SvgPicture.asset(authAssets.facebookBrandIcon,
///       package: authAssets.packageName, height: 20),
///   onPressed: _signInWithFacebook,
/// );
/// ```
class AuthSocialButton extends StatelessWidget {
  /// Creates a branded social-login button. [label] and [icon] are
  /// required; [style] defaults to [AuthSocialButtonStyle.custom] when
  /// you provide all colors yourself.
  const AuthSocialButton({
    required this.label,
    required this.icon,
    required this.style,
    this.onPressed,
    super.key,
    this.enabled = true,
    this.loading = false,
    this.height,
    this.width = double.infinity,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.shadows,
    this.labelStyle,
    this.iconLabelGap,
    this.loadingIndicator,
  });

  /// Button label.
  final String label;

  /// Leading icon. The host renders it at whatever size it wants (the
  /// button does not impose a size constraint). Typically an `SvgPicture`
  /// or `Icon` at ~20 px.
  final Widget icon;

  /// Brand preset that resolves default colors.
  final AuthSocialButtonStyle style;

  /// Tap handler.
  final VoidCallback? onPressed;

  /// Whether the button responds to taps and renders at full opacity.
  final bool enabled;

  /// When true, replaces [icon] + [label] with [loadingIndicator] and
  /// ignores taps.
  final bool loading;

  /// Total button height. Defaults to `theme.spacing.buttonHeight` (48).
  final double? height;

  /// Total button width. Defaults to `double.infinity`.
  final double width;

  /// Inner padding. Defaults to
  /// `EdgeInsets.symmetric(horizontal: 16, vertical: 10)`.
  final EdgeInsetsGeometry? padding;

  /// Corner radius. Defaults to `theme.spacing.buttonRadius` (10).
  final BorderRadius? borderRadius;

  /// Background color. Defaults are derived from [style].
  final Color? backgroundColor;

  /// Foreground (icon tint + label) color. Defaults are derived from
  /// [style].
  final Color? foregroundColor;

  /// Border color. `null` plus a [style] that doesn't draw a border (FB,
  /// Apple, custom-with-no-default) renders the button without a border.
  final Color? borderColor;

  /// Border thickness when a border is drawn. Defaults to 1.
  final double? borderWidth;

  /// Drop shadows. Defaults to an empty list (flat button).
  final List<BoxShadow>? shadows;

  /// Label text style. Defaults to `theme.typography.button` merged with
  /// the resolved foreground color.
  final TextStyle? labelStyle;

  /// Horizontal gap between [icon] and [label]. Defaults to 8.
  final double? iconLabelGap;

  /// Loading widget. Defaults to a small foreground-tinted spinner.
  final Widget? loadingIndicator;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final spacing = theme.spacing;

    final (Color defaultBg, Color defaultFg, Color? defaultBorder) = switch (style) {
      AuthSocialButtonStyle.facebook => (
        colors.facebookBackground,
        colors.facebookForeground,
        null,
      ),
      AuthSocialButtonStyle.google => (
        colors.socialButtonBackground,
        colors.socialButtonForeground,
        colors.socialButtonBorder,
      ),
      AuthSocialButtonStyle.apple => (
        colors.appleBackground,
        colors.appleForeground,
        null,
      ),
      AuthSocialButtonStyle.custom => (
        backgroundColor ?? colors.socialButtonBackground,
        foregroundColor ?? colors.socialButtonForeground,
        borderColor,
      ),
    };

    final Color bg = backgroundColor ?? defaultBg;
    final Color fg = foregroundColor ?? defaultFg;
    final Color? resolvedBorder = borderColor ?? defaultBorder;
    final double resolvedBorderWidth = borderWidth ?? 1;

    final bool interactive = enabled && !loading && onPressed != null;
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(spacing.buttonRadius);
    final EdgeInsetsGeometry resolvedPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
    final TextStyle resolvedLabelStyle =
        (labelStyle ?? theme.typography.button).copyWith(color: fg);

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: SizedBox(
        width: width,
        height: height ?? spacing.buttonHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
            border: resolvedBorder == null
                ? null
                : Border.all(width: resolvedBorderWidth, color: resolvedBorder),
            boxShadow: shadows ?? const <BoxShadow>[],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: interactive ? onPressed : null,
              borderRadius: radius,
              child: Padding(
                padding: resolvedPadding,
                child: Center(
                  child: loading
                      ? (loadingIndicator ??
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(fg),
                            ),
                          ))
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconTheme.merge(
                              data: IconThemeData(color: fg),
                              child: icon,
                            ),
                            SizedBox(width: iconLabelGap ?? 8),
                            Flexible(
                              child: Text(
                                label,
                                style: resolvedLabelStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact icon-only social button used in the divider row on the
/// credential screen.
///
/// **Theme-first, override-everywhere.** Defaults to the neutral outlined
/// style ([AuthColors.socialButtonBackground] + [AuthColors.socialButtonBorder]).
/// Override any visual property per-instance.
///
/// ## Example
///
/// ```dart
/// Row(children: [
///   Expanded(child: AuthSocialIconButton(
///     onPressed: _facebook,
///     icon: SvgPicture.asset(authAssets.facebookCompactIcon,
///         package: authAssets.packageName, height: 20),
///   )),
///   const SizedBox(width: 16),
///   Expanded(child: AuthSocialIconButton(
///     onPressed: _google,
///     icon: SvgPicture.asset(authAssets.googleIcon,
///         package: authAssets.packageName, height: 20),
///   )),
/// ]);
/// ```
class AuthSocialIconButton extends StatelessWidget {
  /// Creates a compact icon-only social button.
  const AuthSocialIconButton({
    required this.icon,
    this.onPressed,
    super.key,
    this.enabled = true,
    this.height,
    this.width,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.shadows,
  });

  /// Icon shown centered in the button.
  final Widget icon;

  /// Tap handler.
  final VoidCallback? onPressed;

  /// Whether the button responds to taps and renders at full opacity.
  final bool enabled;

  /// Button height. Defaults to `theme.spacing.socialButtonHeight` (40).
  final double? height;

  /// Optional fixed width. When `null` the button stretches to fill its
  /// parent (the row uses `Expanded`).
  final double? width;

  /// Inner padding. Defaults to `EdgeInsets.zero` (icon centered in a
  /// fixed box).
  final EdgeInsetsGeometry? padding;

  /// Corner radius. Defaults to `theme.spacing.buttonRadius` (10).
  final BorderRadius? borderRadius;

  /// Background color. Defaults to `theme.colors.socialButtonBackground`.
  final Color? backgroundColor;

  /// Border color. Defaults to `theme.colors.socialButtonBorder`. Pass
  /// `Colors.transparent` to draw a borderless button.
  final Color? borderColor;

  /// Border thickness. Defaults to 1.
  final double? borderWidth;

  /// Drop shadows. Defaults to none.
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final spacing = theme.spacing;

    final BorderRadius radius = borderRadius ?? BorderRadius.circular(spacing.buttonRadius);
    final double resolvedBorderWidth = borderWidth ?? 1;
    final bool interactive = enabled && onPressed != null;

    final Widget content = Container(
      width: width,
      height: height ?? spacing.socialButtonHeight,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.socialButtonBackground,
        border: Border.all(
          color: borderColor ?? colors.socialButtonBorder,
          width: resolvedBorderWidth,
        ),
        borderRadius: radius,
        boxShadow: shadows,
      ),
      padding: padding,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: interactive ? onPressed : null,
          borderRadius: radius,
          child: Center(child: icon),
        ),
      ),
    );

    return Opacity(opacity: enabled ? 1 : 0.5, child: content);
  }
}
