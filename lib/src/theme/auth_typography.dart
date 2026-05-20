import 'package:flutter/material.dart';

/// Typographic scale consumed by every `auth_ui` widget.
///
/// Each slot represents a semantic role (heading, subtitle, button, …) rather
/// than a raw size. Widgets read styles from [AuthTheme.of] and never declare
/// inline [TextStyle] literals. Adding a new visible text style is an API
/// change — bump `MINOR` and update the changelog.
///
/// Defaults are exposed via [AuthTypography.pancakeDefault] and reuse the
/// Google Sans Flex family bundled with the host app.
///
/// ## Example
///
/// ```dart
/// const myType = AuthTypography(
///   heading: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
///   // ...
/// );
/// ```
@immutable
class AuthTypography {
  /// Creates a typography scale. All slots are required.
  const AuthTypography({
    required this.heading,
    required this.title,
    required this.subtitle,
    required this.label,
    required this.bodyMedium,
    required this.bodySmall,
    required this.button,
    required this.primaryButton,
    required this.linkPrimary,
    required this.linkSecondary,
    required this.dividerLabel,
    required this.errorText,
  });

  /// Top-level screen heading — e.g. "Quản lý bán hàng đa kênh" on the
  /// landing login screen. Heaviest text in the package.
  final TextStyle heading;

  /// Page title — e.g. "Đăng nhập với Pancake ID" on the credential screen.
  final TextStyle title;

  /// Multi-line supporting copy under a [title].
  final TextStyle subtitle;

  /// Input-field label rendered above the field container.
  final TextStyle label;

  /// Default running-text body. Used inside cards, dialogs, and rich-text
  /// segments that are not links.
  final TextStyle bodyMedium;

  /// Smaller body — captions and pill copy ("Một sản phẩm của").
  final TextStyle bodySmall;

  /// Standard button text — used by social buttons and any non-primary CTA.
  final TextStyle button;

  /// Primary CTA button text — slightly larger and tighter tracking than
  /// [button], used by `AuthPrimaryButton` and similar emphasized actions.
  final TextStyle primaryButton;

  /// Inline link inside a sentence, e.g. the "Đăng nhập tại đây" tap target.
  /// Smaller and bolder than surrounding [bodySmall].
  final TextStyle linkPrimary;

  /// Standalone link, e.g. "Đăng ký ngay" CTA at the bottom of the page.
  /// Sized close to [bodyMedium] but in the accent color.
  final TextStyle linkSecondary;

  /// All-caps small label rendered between divider rules — e.g.
  /// "ĐĂNG NHẬP VỚI". Uses positive letter spacing for legibility.
  final TextStyle dividerLabel;

  /// Field-level validation message rendered below an input.
  final TextStyle errorText;

  /// Default Pancake POS scale — mirrors `GoogleSansFlexStyles` in
  /// `pos_mobile` today. Color is intentionally omitted so widgets can
  /// merge the right palette color at paint time.
  static const AuthTypography pancakeDefault = AuthTypography(
    heading: TextStyle(
      fontFamily: _family,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.29,
      letterSpacing: -1,
    ),
    title: TextStyle(
      fontFamily: _family,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -1,
    ),
    subtitle: TextStyle(
      fontFamily: _family,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: -0.09,
    ),
    label: TextStyle(
      fontFamily: _family,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: -0.09,
    ),
    bodyMedium: TextStyle(
      fontFamily: _family,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    bodySmall: TextStyle(
      fontFamily: _family,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1,
    ),
    button: TextStyle(
      fontFamily: _family,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
    primaryButton: TextStyle(
      fontFamily: _family,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: -0.09,
    ),
    linkPrimary: TextStyle(
      fontFamily: _family,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    linkSecondary: TextStyle(
      fontFamily: _family,
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 1.33,
      letterSpacing: -0.09,
    ),
    dividerLabel: TextStyle(
      fontFamily: _family,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1,
      letterSpacing: 0.24,
    ),
    errorText: TextStyle(
      fontFamily: _family,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
  );

  static const String _family = 'Google Sans Flex';

  /// Returns a copy with the supplied fields overridden.
  AuthTypography copyWith({
    TextStyle? heading,
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? label,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? button,
    TextStyle? primaryButton,
    TextStyle? linkPrimary,
    TextStyle? linkSecondary,
    TextStyle? dividerLabel,
    TextStyle? errorText,
  }) {
    return AuthTypography(
      heading: heading ?? this.heading,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      label: label ?? this.label,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      button: button ?? this.button,
      primaryButton: primaryButton ?? this.primaryButton,
      linkPrimary: linkPrimary ?? this.linkPrimary,
      linkSecondary: linkSecondary ?? this.linkSecondary,
      dividerLabel: dividerLabel ?? this.dividerLabel,
      errorText: errorText ?? this.errorText,
    );
  }

  /// Linear interpolation between two scales. Required by [AuthTheme.lerp].
  static AuthTypography lerp(AuthTypography a, AuthTypography b, double t) {
    return AuthTypography(
      heading: TextStyle.lerp(a.heading, b.heading, t)!,
      title: TextStyle.lerp(a.title, b.title, t)!,
      subtitle: TextStyle.lerp(a.subtitle, b.subtitle, t)!,
      label: TextStyle.lerp(a.label, b.label, t)!,
      bodyMedium: TextStyle.lerp(a.bodyMedium, b.bodyMedium, t)!,
      bodySmall: TextStyle.lerp(a.bodySmall, b.bodySmall, t)!,
      button: TextStyle.lerp(a.button, b.button, t)!,
      primaryButton: TextStyle.lerp(a.primaryButton, b.primaryButton, t)!,
      linkPrimary: TextStyle.lerp(a.linkPrimary, b.linkPrimary, t)!,
      linkSecondary: TextStyle.lerp(a.linkSecondary, b.linkSecondary, t)!,
      dividerLabel: TextStyle.lerp(a.dividerLabel, b.dividerLabel, t)!,
      errorText: TextStyle.lerp(a.errorText, b.errorText, t)!,
    );
  }
}
