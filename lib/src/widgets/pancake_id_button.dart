import 'package:flutter/material.dart';

import '../theme/auth_theme.dart';

/// Featured branded CTA used to launch the Pancake ID credential flow.
///
/// The button paints a caller-supplied [background] widget (typically an
/// `SvgPicture` stretched with `BoxFit.fill`) behind a centered row of
/// [icon] + [label]. Splitting the background into a slot keeps the
/// widget brand-agnostic and lets non-Pancake hosts swap the gradient.
///
/// **Theme-first, override-everywhere.** All sizing and typography is
/// nullable and resolves through [AuthTheme.of] when omitted.
///
/// ## Example
///
/// ```dart
/// PancakeIdButton(
///   label: 'Đăng nhập với Pancake ID',
///   onPressed: _openPancakeId,
///   icon: SvgPicture.asset(
///     authAssets.pancakeLogoColor,
///     package: authAssets.packageName,
///     height: 24,
///     colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
///   ),
///   background: SvgPicture.asset(
///     authAssets.pancakeIdButtonBackground,
///     package: authAssets.packageName,
///     fit: BoxFit.fill,
///   ),
/// );
/// ```
class PancakeIdButton extends StatelessWidget {
  /// Creates the featured Pancake ID button.
  const PancakeIdButton({
    required this.label,
    required this.icon,
    required this.background,
    this.onPressed,
    super.key,
    this.enabled = true,
    this.loading = false,
    this.height,
    this.width = double.infinity,
    this.padding,
    this.borderRadius,
    this.foregroundColor,
    this.labelStyle,
    this.iconLabelGap,
    this.loadingIndicator,
  });

  /// Button label.
  final String label;

  /// Centered icon (Pancake mark). Hosts typically size it at 24 px and
  /// tint it with [foregroundColor] via `ColorFilter.mode` upstream — the
  /// button does not impose a tint.
  final Widget icon;

  /// Decorative full-bleed background (gradient SVG, gradient container,
  /// solid color, …). Stretched to fill the button bounds.
  final Widget background;

  /// Tap handler.
  final VoidCallback? onPressed;

  /// Whether the button responds to taps.
  final bool enabled;

  /// When true, swaps the icon + label for [loadingIndicator] and ignores
  /// taps.
  final bool loading;

  /// Button height. Defaults to `theme.spacing.primaryButtonHeight` (52).
  final double? height;

  /// Button width. Defaults to `double.infinity`.
  final double width;

  /// Inner padding around the icon + label row. Defaults to
  /// `EdgeInsets.symmetric(horizontal: 16)`.
  final EdgeInsetsGeometry? padding;

  /// Corner radius. Defaults to `theme.spacing.buttonRadius` (10). The
  /// [background] is clipped against this radius.
  final BorderRadius? borderRadius;

  /// Foreground color for the label (and, via [IconTheme], any
  /// material-icon [icon]). Defaults to
  /// `theme.colors.primaryButtonForeground`.
  final Color? foregroundColor;

  /// Label text style. Defaults to `theme.typography.button` merged with
  /// the resolved foreground color.
  final TextStyle? labelStyle;

  /// Horizontal gap between [icon] and [label]. Defaults to 8.
  final double? iconLabelGap;

  /// Loading widget. Defaults to a foreground-tinted spinner.
  final Widget? loadingIndicator;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final spacing = theme.spacing;

    final BorderRadius radius = borderRadius ?? BorderRadius.circular(spacing.buttonRadius);
    final double resolvedHeight = height ?? spacing.primaryButtonHeight;
    final EdgeInsetsGeometry resolvedPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 16);

    final Color fg = foregroundColor ?? colors.primaryButtonForeground;
    final TextStyle resolvedLabelStyle =
        (labelStyle ?? theme.typography.button).copyWith(color: fg);

    final bool interactive = enabled && !loading && onPressed != null;

    return SizedBox(
      width: width,
      height: resolvedHeight,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: InkWell(
            onTap: interactive ? onPressed : null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                background,
                Padding(
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
                                  textAlign: TextAlign.center,
                                  style: resolvedLabelStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
