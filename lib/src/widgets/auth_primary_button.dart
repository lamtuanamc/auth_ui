import 'package:flutter/material.dart';

import '../theme/auth_theme.dart';

/// Primary CTA button used by login / register / reset flows.
///
/// **Three orthogonal states** ([enabled], [loading], [onPressed] presence)
/// combine to a single boolean: the button is interactive iff
/// `enabled && !loading && onPressed != null`.
///
/// **Theme-first, override-everywhere.** Every visual property is nullable
/// and falls back to [AuthTheme.of] when omitted. Pass any one of them to
/// override locally without redeclaring a whole theme.
///
/// ## Example
///
/// ```dart
/// AuthPrimaryButton(
///   label: 'Đăng nhập',
///   onPressed: _onSubmit,
///   enabled: _formValid,
///   loading: _submitting,
/// );
///
/// // Local override — a wider, taller, red button:
/// AuthPrimaryButton(
///   label: 'Xoá tài khoản',
///   onPressed: _confirmDelete,
///   backgroundColor: Colors.red,
///   height: 56,
///   padding: const EdgeInsets.symmetric(horizontal: 32),
/// );
/// ```
class AuthPrimaryButton extends StatelessWidget {
  /// Creates a primary CTA. [label] is required; everything else is
  /// optional and resolved through [AuthTheme] when null.
  const AuthPrimaryButton({
    required this.label,
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
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.border,
    this.shadows,
    this.labelStyle,
    this.loadingIndicator,
  });

  /// Text rendered when [loading] is false.
  final String label;

  /// Invoked on tap when the button is interactive. When `null` the button
  /// renders in its disabled visual state.
  final VoidCallback? onPressed;

  /// When false, button renders disabled even if [onPressed] is non-null.
  /// Use for form-completion gating ("submit only when fields are valid").
  final bool enabled;

  /// When true, swaps the label for [loadingIndicator] and ignores taps.
  /// Visual state stays "enabled" — only the label changes.
  final bool loading;

  /// Total button height. Defaults to `theme.spacing.buttonHeight` (48).
  final double? height;

  /// Total button width. Defaults to `double.infinity` (full-bleed).
  final double width;

  /// Inner padding around the label. Defaults to `EdgeInsets.zero`
  /// because the label is centered in a fixed-height box.
  final EdgeInsetsGeometry? padding;

  /// Corner radius. Defaults to `theme.spacing.buttonRadius` (10).
  final BorderRadius? borderRadius;

  /// Background color in the enabled state. Defaults to
  /// `theme.colors.accent`.
  final Color? backgroundColor;

  /// Foreground (label) color in the enabled state. Defaults to
  /// `theme.colors.primaryButtonForeground`.
  final Color? foregroundColor;

  /// Background color in the disabled state. Defaults to
  /// `theme.colors.primaryButtonDisabledBackground`.
  final Color? disabledBackgroundColor;

  /// Foreground color in the disabled state. Defaults to
  /// `theme.colors.primaryButtonDisabledForeground`.
  final Color? disabledForegroundColor;

  /// Optional border drawn around the button in the enabled state. The
  /// default brand renders a 1 px translucent-white inner border to soften
  /// the edge against the gradient. Pass `BorderSide.none` to remove it.
  final BorderSide? border;

  /// Drop-shadow stack in the enabled state. The default renders a soft
  /// accent-colored glow; pass an empty list to flatten the button.
  final List<BoxShadow>? shadows;

  /// Label text style. Defaults to `theme.typography.primaryButton`
  /// merged with the resolved foreground color.
  final TextStyle? labelStyle;

  /// Widget shown in place of [label] while [loading] is true. Defaults to
  /// a small white [CircularProgressIndicator].
  final Widget? loadingIndicator;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final spacing = theme.spacing;

    final bool interactive = enabled && !loading && onPressed != null;
    final bool visuallyActive = enabled && !loading;

    final Color bg = visuallyActive
        ? (backgroundColor ?? colors.accent)
        : (disabledBackgroundColor ?? colors.primaryButtonDisabledBackground);
    final Color fg = visuallyActive
        ? (foregroundColor ?? colors.primaryButtonForeground)
        : (disabledForegroundColor ?? colors.primaryButtonDisabledForeground);

    final BorderRadius radius = borderRadius ?? BorderRadius.circular(spacing.buttonRadius);
    final double resolvedHeight = height ?? spacing.buttonHeight;
    final EdgeInsetsGeometry resolvedPadding = padding ?? EdgeInsets.zero;

    final BorderSide resolvedBorder = border ??
        (visuallyActive ? const BorderSide(width: 1, color: Color(0x1FFFFFFF)) : BorderSide.none);

    final List<BoxShadow> resolvedShadows = shadows ??
        (visuallyActive
            ? <BoxShadow>[
                BoxShadow(color: colors.accent, spreadRadius: 1),
                BoxShadow(
                  color: colors.accent.withValues(alpha: 0.48),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : const <BoxShadow>[]);

    final TextStyle resolvedLabelStyle =
        (labelStyle ?? theme.typography.primaryButton).copyWith(color: fg);

    return SizedBox(
      width: width,
      height: resolvedHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: resolvedBorder == BorderSide.none ? null : Border.fromBorderSide(resolvedBorder),
          boxShadow: resolvedShadows,
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
                    : Text(label, style: resolvedLabelStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
