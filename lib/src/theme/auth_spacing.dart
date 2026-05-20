import 'package:flutter/material.dart';

/// Spacing, radius, and fixed-size tokens consumed by every `auth_ui`
/// widget.
///
/// Widgets must read sizes from [AuthTheme.of] — never inline magic numbers
/// like `EdgeInsets.all(24)` or `BorderRadius.circular(10)` in a widget.
/// Adding a new slot is an API change — bump `MINOR` and update the
/// changelog.
///
/// Defaults are exposed via [AuthSpacing.pancakeDefault].
@immutable
class AuthSpacing {
  /// Creates a spacing scale. All slots are required.
  const AuthSpacing({
    required this.pagePaddingHorizontal,
    required this.pagePaddingVertical,
    required this.sectionGap,
    required this.fieldGap,
    required this.fieldLabelGap,
    required this.buttonGap,
    required this.buttonHeight,
    required this.primaryButtonHeight,
    required this.socialButtonHeight,
    required this.inputRadius,
    required this.buttonRadius,
    required this.pillRadius,
    required this.iconSize,
    required this.logoHeight,
    required this.bannerHeight,
  });

  /// Left / right padding applied to the main content column of every view.
  final double pagePaddingHorizontal;

  /// Top / bottom padding applied to the main content column.
  final double pagePaddingVertical;

  /// Gap between high-level sections (e.g. header → banner → action stack).
  final double sectionGap;

  /// Gap between two stacked input fields.
  final double fieldGap;

  /// Gap between an input label and the input container immediately below.
  final double fieldLabelGap;

  /// Gap between two stacked buttons.
  final double buttonGap;

  /// Standard button height (e.g. social-row compact buttons).
  final double buttonHeight;

  /// Primary CTA height. Slightly taller than [buttonHeight] for emphasis.
  final double primaryButtonHeight;

  /// Compact social button height (Pancake ID screen's icon-only row).
  final double socialButtonHeight;

  /// Corner radius for text inputs.
  final double inputRadius;

  /// Corner radius for buttons.
  final double buttonRadius;

  /// Corner radius for pill-shaped chips ("Một sản phẩm của …").
  final double pillRadius;

  /// Standard icon size used inside buttons.
  final double iconSize;

  /// Logo height in the landing-screen header.
  final double logoHeight;

  /// Decorative banner illustration height on the landing screen.
  final double bannerHeight;

  /// Convenience: page padding as an [EdgeInsets].
  EdgeInsets get pagePadding => EdgeInsets.symmetric(
        horizontal: pagePaddingHorizontal,
        vertical: pagePaddingVertical,
      );

  /// Default Pancake POS spacing — mirrors literals used by `pos_mobile`
  /// login screens today.
  static const AuthSpacing pancakeDefault = AuthSpacing(
    pagePaddingHorizontal: 24,
    pagePaddingVertical: 16,
    sectionGap: 24,
    fieldGap: 16,
    fieldLabelGap: 4,
    buttonGap: 12,
    buttonHeight: 48,
    primaryButtonHeight: 52,
    socialButtonHeight: 40,
    inputRadius: 10,
    buttonRadius: 10,
    pillRadius: 100,
    iconSize: 20,
    logoHeight: 32,
    bannerHeight: 380,
  );

  /// Returns a copy with the supplied fields overridden.
  AuthSpacing copyWith({
    double? pagePaddingHorizontal,
    double? pagePaddingVertical,
    double? sectionGap,
    double? fieldGap,
    double? fieldLabelGap,
    double? buttonGap,
    double? buttonHeight,
    double? primaryButtonHeight,
    double? socialButtonHeight,
    double? inputRadius,
    double? buttonRadius,
    double? pillRadius,
    double? iconSize,
    double? logoHeight,
    double? bannerHeight,
  }) {
    return AuthSpacing(
      pagePaddingHorizontal: pagePaddingHorizontal ?? this.pagePaddingHorizontal,
      pagePaddingVertical: pagePaddingVertical ?? this.pagePaddingVertical,
      sectionGap: sectionGap ?? this.sectionGap,
      fieldGap: fieldGap ?? this.fieldGap,
      fieldLabelGap: fieldLabelGap ?? this.fieldLabelGap,
      buttonGap: buttonGap ?? this.buttonGap,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      primaryButtonHeight: primaryButtonHeight ?? this.primaryButtonHeight,
      socialButtonHeight: socialButtonHeight ?? this.socialButtonHeight,
      inputRadius: inputRadius ?? this.inputRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      pillRadius: pillRadius ?? this.pillRadius,
      iconSize: iconSize ?? this.iconSize,
      logoHeight: logoHeight ?? this.logoHeight,
      bannerHeight: bannerHeight ?? this.bannerHeight,
    );
  }

  /// Linear interpolation between two scales. Required by [AuthTheme.lerp].
  static AuthSpacing lerp(AuthSpacing a, AuthSpacing b, double t) {
    double l(double x, double y) => x + (y - x) * t;
    return AuthSpacing(
      pagePaddingHorizontal: l(a.pagePaddingHorizontal, b.pagePaddingHorizontal),
      pagePaddingVertical: l(a.pagePaddingVertical, b.pagePaddingVertical),
      sectionGap: l(a.sectionGap, b.sectionGap),
      fieldGap: l(a.fieldGap, b.fieldGap),
      fieldLabelGap: l(a.fieldLabelGap, b.fieldLabelGap),
      buttonGap: l(a.buttonGap, b.buttonGap),
      buttonHeight: l(a.buttonHeight, b.buttonHeight),
      primaryButtonHeight: l(a.primaryButtonHeight, b.primaryButtonHeight),
      socialButtonHeight: l(a.socialButtonHeight, b.socialButtonHeight),
      inputRadius: l(a.inputRadius, b.inputRadius),
      buttonRadius: l(a.buttonRadius, b.buttonRadius),
      pillRadius: l(a.pillRadius, b.pillRadius),
      iconSize: l(a.iconSize, b.iconSize),
      logoHeight: l(a.logoHeight, b.logoHeight),
      bannerHeight: l(a.bannerHeight, b.bannerHeight),
    );
  }
}
