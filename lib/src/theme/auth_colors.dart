import 'package:flutter/material.dart';

/// Color palette consumed by every `auth_ui` widget.
///
/// Every visible color used by a login / register / OTP / forgot-password
/// screen has a slot here. Widgets must read colors from this class through
/// [AuthTheme.of] — never hard-code a [Color] literal inside a widget.
///
/// Brands ship their own palette by constructing an [AuthColors] value and
/// passing it into [AuthTheme]. The default Pancake POS palette is exposed
/// as [AuthColors.pancakeLight].
///
/// ## Example
///
/// ```dart
/// const myColors = AuthColors(
///   backgroundGradientStart: Color(0xFFD2ECFE),
///   backgroundGradientEnd: Color(0x33D2ECFE),
///   // ...
/// );
/// ```
@immutable
class AuthColors {
  /// Creates a palette. Every slot is required so brand authors are forced to
  /// make a conscious decision instead of inheriting unrelated defaults.
  const AuthColors({
    required this.backgroundGradientStart,
    required this.backgroundGradientEnd,
    required this.textStrong,
    required this.textSecondary,
    required this.textTertiary,
    required this.accent,
    required this.link,
    required this.error,
    required this.stroke,
    required this.divider,
    required this.shadowSubtle,
    required this.inputBackground,
    required this.socialButtonBackground,
    required this.socialButtonBorder,
    required this.socialButtonForeground,
    required this.facebookBackground,
    required this.facebookForeground,
    required this.appleBackground,
    required this.appleForeground,
    required this.pillBackground,
    required this.pillBorder,
    required this.primaryButtonForeground,
    required this.primaryButtonDisabledBackground,
    required this.primaryButtonDisabledForeground,
  });

  /// Top stop of the full-screen login background gradient.
  final Color backgroundGradientStart;

  /// Bottom stop of the full-screen login background gradient.
  final Color backgroundGradientEnd;

  /// High-contrast text — headings, primary labels, form values.
  final Color textStrong;

  /// Mid-contrast text — subtitles, helper copy, inactive labels.
  final Color textSecondary;

  /// Low-contrast text — captions, divider labels.
  final Color textTertiary;

  /// Brand action color — used on primary CTAs and "register now" links.
  final Color accent;

  /// In-line link color, e.g. "Đăng nhập tại đây" tap target.
  final Color link;

  /// Error text, error input stroke.
  final Color error;

  /// Default input stroke (1 px) when there is no error and no focus.
  final Color stroke;

  /// Thin divider between sections (e.g. the "ĐĂNG NHẬP VỚI" rule).
  final Color divider;

  /// Default elevation shadow for inputs and cards. Already includes alpha;
  /// do not multiply it again.
  final Color shadowSubtle;

  /// Background for text inputs.
  final Color inputBackground;

  /// Background for outlined social-login buttons (Google, Apple compact).
  final Color socialButtonBackground;

  /// 1 px border for outlined social-login buttons.
  final Color socialButtonBorder;

  /// Icon / label color for outlined social-login buttons.
  final Color socialButtonForeground;

  /// Facebook brand-button background.
  final Color facebookBackground;

  /// Facebook brand-button foreground (icon + label).
  final Color facebookForeground;

  /// Apple brand-button background.
  final Color appleBackground;

  /// Apple brand-button foreground (icon + label).
  final Color appleForeground;

  /// "A product of …" pill background. Typically a translucent white.
  final Color pillBackground;

  /// "A product of …" pill border.
  final Color pillBorder;

  /// Foreground color (icon + label) for the primary CTA button. The
  /// background of the primary CTA is supplied by the widget itself because
  /// it ships as a gradient image in some brands.
  final Color primaryButtonForeground;

  /// Background of the primary CTA when it is disabled (no `onPressed`).
  /// Typically a very light neutral gray.
  final Color primaryButtonDisabledBackground;

  /// Foreground (label + icon) of the primary CTA when it is disabled.
  /// Typically a mid-gray that still passes WCAG against
  /// [primaryButtonDisabledBackground].
  final Color primaryButtonDisabledForeground;

  /// Default Pancake POS palette — mirrors the colors used by `pos_mobile`
  /// today so consumers can drop the package in without restyling.
  static const AuthColors pancakeLight = AuthColors(
    backgroundGradientStart: Color(0xFFD2ECFE),
    backgroundGradientEnd: Color(0x33D2ECFE),
    textStrong: Color(0xFF171717),
    textSecondary: Color(0xFF5C5C5C),
    textTertiary: Color(0xFF7B7B7B),
    accent: Color(0xFF335CFF),
    link: Color(0xFF0050B3),
    error: Color(0xFFD92D20),
    stroke: Color(0xFFEBEBEB),
    divider: Color(0xFFDBDBDB),
    shadowSubtle: Color(0x070A0D14),
    inputBackground: Color(0xFFFFFFFF),
    socialButtonBackground: Color(0xFFFFFFFF),
    socialButtonBorder: Color(0xFFD0D5DD),
    socialButtonForeground: Color(0xFF3D3D3D),
    facebookBackground: Color(0xFF1877F2),
    facebookForeground: Color(0xFFFFFFFF),
    appleBackground: Color(0xFF000000),
    appleForeground: Color(0xFFFFFFFF),
    pillBackground: Color(0x66FFFFFF),
    pillBorder: Color(0xFFFFFFFF),
    primaryButtonForeground: Color(0xFFFFFFFF),
    primaryButtonDisabledBackground: Color(0xFFF5F5F5),
    primaryButtonDisabledForeground: Color(0xFFA3A3A3),
  );

  /// Returns a copy of this palette with the supplied fields overridden.
  /// Useful for ad-hoc one-off tweaks without redeclaring the whole palette.
  AuthColors copyWith({
    Color? backgroundGradientStart,
    Color? backgroundGradientEnd,
    Color? textStrong,
    Color? textSecondary,
    Color? textTertiary,
    Color? accent,
    Color? link,
    Color? error,
    Color? stroke,
    Color? divider,
    Color? shadowSubtle,
    Color? inputBackground,
    Color? socialButtonBackground,
    Color? socialButtonBorder,
    Color? socialButtonForeground,
    Color? facebookBackground,
    Color? facebookForeground,
    Color? appleBackground,
    Color? appleForeground,
    Color? pillBackground,
    Color? pillBorder,
    Color? primaryButtonForeground,
    Color? primaryButtonDisabledBackground,
    Color? primaryButtonDisabledForeground,
  }) {
    return AuthColors(
      backgroundGradientStart: backgroundGradientStart ?? this.backgroundGradientStart,
      backgroundGradientEnd: backgroundGradientEnd ?? this.backgroundGradientEnd,
      textStrong: textStrong ?? this.textStrong,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      accent: accent ?? this.accent,
      link: link ?? this.link,
      error: error ?? this.error,
      stroke: stroke ?? this.stroke,
      divider: divider ?? this.divider,
      shadowSubtle: shadowSubtle ?? this.shadowSubtle,
      inputBackground: inputBackground ?? this.inputBackground,
      socialButtonBackground: socialButtonBackground ?? this.socialButtonBackground,
      socialButtonBorder: socialButtonBorder ?? this.socialButtonBorder,
      socialButtonForeground: socialButtonForeground ?? this.socialButtonForeground,
      facebookBackground: facebookBackground ?? this.facebookBackground,
      facebookForeground: facebookForeground ?? this.facebookForeground,
      appleBackground: appleBackground ?? this.appleBackground,
      appleForeground: appleForeground ?? this.appleForeground,
      pillBackground: pillBackground ?? this.pillBackground,
      pillBorder: pillBorder ?? this.pillBorder,
      primaryButtonForeground: primaryButtonForeground ?? this.primaryButtonForeground,
      primaryButtonDisabledBackground:
          primaryButtonDisabledBackground ?? this.primaryButtonDisabledBackground,
      primaryButtonDisabledForeground:
          primaryButtonDisabledForeground ?? this.primaryButtonDisabledForeground,
    );
  }

  /// Linear interpolation between two palettes. Required for
  /// [AuthTheme.lerp] so theme transitions animate smoothly when the host
  /// swaps brands or toggles dark mode.
  static AuthColors lerp(AuthColors a, AuthColors b, double t) {
    return AuthColors(
      backgroundGradientStart: Color.lerp(a.backgroundGradientStart, b.backgroundGradientStart, t)!,
      backgroundGradientEnd: Color.lerp(a.backgroundGradientEnd, b.backgroundGradientEnd, t)!,
      textStrong: Color.lerp(a.textStrong, b.textStrong, t)!,
      textSecondary: Color.lerp(a.textSecondary, b.textSecondary, t)!,
      textTertiary: Color.lerp(a.textTertiary, b.textTertiary, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
      link: Color.lerp(a.link, b.link, t)!,
      error: Color.lerp(a.error, b.error, t)!,
      stroke: Color.lerp(a.stroke, b.stroke, t)!,
      divider: Color.lerp(a.divider, b.divider, t)!,
      shadowSubtle: Color.lerp(a.shadowSubtle, b.shadowSubtle, t)!,
      inputBackground: Color.lerp(a.inputBackground, b.inputBackground, t)!,
      socialButtonBackground: Color.lerp(a.socialButtonBackground, b.socialButtonBackground, t)!,
      socialButtonBorder: Color.lerp(a.socialButtonBorder, b.socialButtonBorder, t)!,
      socialButtonForeground: Color.lerp(a.socialButtonForeground, b.socialButtonForeground, t)!,
      facebookBackground: Color.lerp(a.facebookBackground, b.facebookBackground, t)!,
      facebookForeground: Color.lerp(a.facebookForeground, b.facebookForeground, t)!,
      appleBackground: Color.lerp(a.appleBackground, b.appleBackground, t)!,
      appleForeground: Color.lerp(a.appleForeground, b.appleForeground, t)!,
      pillBackground: Color.lerp(a.pillBackground, b.pillBackground, t)!,
      pillBorder: Color.lerp(a.pillBorder, b.pillBorder, t)!,
      primaryButtonForeground: Color.lerp(a.primaryButtonForeground, b.primaryButtonForeground, t)!,
      primaryButtonDisabledBackground: Color.lerp(
        a.primaryButtonDisabledBackground,
        b.primaryButtonDisabledBackground,
        t,
      )!,
      primaryButtonDisabledForeground: Color.lerp(
        a.primaryButtonDisabledForeground,
        b.primaryButtonDisabledForeground,
        t,
      )!,
    );
  }
}
