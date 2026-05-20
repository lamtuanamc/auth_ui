import 'package:flutter/foundation.dart';

/// Asset paths used by `auth_ui` widgets, plus the package they should be
/// loaded from.
///
/// The package ships a default set of brand assets under
/// `lib/assets/login/`. Hosts can use [AuthAssets.bundled] to read those
/// directly, or supply their own paths to override individual assets (e.g.
/// swap the logo for a white-label brand) by constructing [AuthAssets]
/// with custom values.
///
/// When [packageName] is non-null, every path is resolved relative to that
/// package by `flutter_svg` / `Image.asset` — set it to `'auth_ui'` (the
/// default for [AuthAssets.bundled]) to pull from this package, or `null`
/// to read from the consuming app's own assets bundle.
///
/// ## Example
///
/// ```dart
/// // Default — uses the assets shipped inside the package.
/// const assets = AuthAssets.bundled;
///
/// // Override only the brand logo, leave everything else bundled:
/// final assets = AuthAssets.bundled.copyWith(
///   logo: 'assets/branding/my_logo.svg',
///   packageName: null, // Read overrides from the host's bundle.
/// );
/// ```
@immutable
class AuthAssets {
  /// Creates an asset configuration. All paths are required so a missing
  /// override surfaces as a compile error rather than a broken image at
  /// runtime.
  const AuthAssets({
    required this.logo,
    required this.banner,
    required this.pancakeLogo,
    required this.pancakeLogoColor,
    required this.pancakeIdButtonBackground,
    required this.facebookBrandIcon,
    required this.facebookCompactIcon,
    required this.googleIcon,
    this.packageName = 'auth_ui',
  });

  /// Default configuration that reads every asset from `package:auth_ui`.
  /// Pass this to a view to get the Pancake POS look without copying any
  /// SVGs into your host app.
  static const AuthAssets bundled = AuthAssets(
    logo: 'lib/assets/login/logo.svg',
    banner: 'lib/assets/login/new_banner.svg',
    pancakeLogo: 'lib/assets/login/pancake_logo.png',
    pancakeLogoColor: 'lib/assets/login/new_pancake_logo.svg',
    pancakeIdButtonBackground: 'lib/assets/login/pancake_id_button_bg.svg',
    facebookBrandIcon: 'lib/assets/login/facebook_id.svg',
    facebookCompactIcon: 'lib/assets/login/facebook_logo.svg',
    googleIcon: 'lib/assets/login/google_logo.svg',
  );

  /// Top-level wordmark logo rendered in the screen header. SVG.
  final String logo;

  /// Decorative illustration rendered between header and action stack on
  /// the landing screen. SVG, drawn at [AuthSpacing.bannerHeight].
  final String banner;

  /// Pancake brand mark used inside the "Một sản phẩm của" pill. PNG with
  /// transparent background.
  final String pancakeLogo;

  /// Single-color Pancake mark used inside the primary Pancake ID button.
  /// Must be a single-color SVG so it can be tinted via
  /// [AuthColors.primaryButtonForeground].
  final String pancakeLogoColor;

  /// Decorative gradient background drawn behind the Pancake ID CTA. SVG
  /// stretched with `BoxFit.fill`.
  final String pancakeIdButtonBackground;

  /// Multi-color Facebook brand mark used on the full-width Facebook CTA.
  /// SVG.
  final String facebookBrandIcon;

  /// Compact Facebook icon used in the icon-only social row on the
  /// Pancake ID credential screen. SVG.
  final String facebookCompactIcon;

  /// Google "G" icon. SVG.
  final String googleIcon;

  /// Package that owns the asset files. When non-null, paths above are
  /// resolved against `package:<packageName>/…`. Set to `null` if the host
  /// app declares the same paths in its own `pubspec.yaml`.
  final String? packageName;

  /// Returns a copy with the supplied fields overridden. Use this to
  /// override a single asset (e.g. white-label logo) without redeclaring
  /// the whole bundle.
  AuthAssets copyWith({
    String? logo,
    String? banner,
    String? pancakeLogo,
    String? pancakeLogoColor,
    String? pancakeIdButtonBackground,
    String? facebookBrandIcon,
    String? facebookCompactIcon,
    String? googleIcon,
    String? packageName,
    bool clearPackageName = false,
  }) {
    return AuthAssets(
      logo: logo ?? this.logo,
      banner: banner ?? this.banner,
      pancakeLogo: pancakeLogo ?? this.pancakeLogo,
      pancakeLogoColor: pancakeLogoColor ?? this.pancakeLogoColor,
      pancakeIdButtonBackground: pancakeIdButtonBackground ?? this.pancakeIdButtonBackground,
      facebookBrandIcon: facebookBrandIcon ?? this.facebookBrandIcon,
      facebookCompactIcon: facebookCompactIcon ?? this.facebookCompactIcon,
      googleIcon: googleIcon ?? this.googleIcon,
      packageName: clearPackageName ? null : (packageName ?? this.packageName),
    );
  }
}
