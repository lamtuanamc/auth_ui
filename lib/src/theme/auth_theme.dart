import 'package:flutter/material.dart';

import 'auth_colors.dart';
import 'auth_spacing.dart';
import 'auth_typography.dart';

/// Aggregates the three token families ([AuthColors], [AuthTypography],
/// [AuthSpacing]) into a single [ThemeExtension] that hosts register on
/// their root [ThemeData]. Widgets in this package read tokens through
/// [AuthTheme.of].
///
/// Hosts integrate the theme like this:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: const [AuthTheme.pancakeLight],
///   ),
///   home: const LoginView(...), // arrives in Phase 3
/// );
/// ```
///
/// To customize a single token without re-declaring the whole tree:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       AuthTheme.pancakeLight.copyWith(
///         colors: AuthTheme.pancakeLight.colors.copyWith(
///           accent: const Color(0xFFE91E63),
///         ),
///       ),
///     ],
///   ),
/// );
/// ```
@immutable
class AuthTheme extends ThemeExtension<AuthTheme> {
  /// Creates an [AuthTheme] from three token families.
  const AuthTheme({
    required this.colors,
    required this.typography,
    required this.spacing,
  });

  /// Color palette.
  final AuthColors colors;

  /// Typographic scale.
  final AuthTypography typography;

  /// Spacing / sizing tokens.
  final AuthSpacing spacing;

  /// Pancake POS default. Composed from the three `pancake*` defaults.
  static const AuthTheme pancakeLight = AuthTheme(
    colors: AuthColors.pancakeLight,
    typography: AuthTypography.pancakeDefault,
    spacing: AuthSpacing.pancakeDefault,
  );

  /// Convenience accessor used by every widget in the package.
  ///
  /// Falls back to [AuthTheme.pancakeLight] if the host did not register an
  /// `AuthTheme` extension. This keeps widgets renderable in isolation
  /// (e.g. unit tests and Widgetbook stories) without forcing every host to
  /// wire `ThemeData.extensions` immediately.
  static AuthTheme of(BuildContext context) {
    return Theme.of(context).extension<AuthTheme>() ?? pancakeLight;
  }

  @override
  AuthTheme copyWith({
    AuthColors? colors,
    AuthTypography? typography,
    AuthSpacing? spacing,
  }) {
    return AuthTheme(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  AuthTheme lerp(ThemeExtension<AuthTheme>? other, double t) {
    if (other is! AuthTheme) {
      return this;
    }
    return AuthTheme(
      colors: AuthColors.lerp(colors, other.colors, t),
      typography: AuthTypography.lerp(typography, other.typography, t),
      spacing: AuthSpacing.lerp(spacing, other.spacing, t),
    );
  }
}
