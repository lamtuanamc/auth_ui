import 'package:flutter/material.dart';

import '../theme/auth_theme.dart';

/// Minimal app bar used at the top of auth flows. Renders an optional
/// close-style button on the leading edge and an optional centered title.
///
/// The host owns the dismiss action — pass [onClose] to receive taps. The
/// widget never calls `Navigator.pop` itself.
///
/// **Theme-first, override-everywhere.** Every visual property is
/// nullable and resolves through [AuthTheme.of] when omitted.
///
/// ## Example
///
/// ```dart
/// Scaffold(
///   appBar: AuthAppBar(
///     onClose: () => Navigator.of(context).pop(),
///   ),
///   body: ...,
/// );
/// ```
class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an auth app bar.
  const AuthAppBar({
    super.key,
    this.title,
    this.onClose,
    this.leading,
    this.actions,
    this.height = 56,
    this.padding,
    this.backgroundColor,
    this.titleStyle,
    this.titleColor,
    this.closeIcon,
    this.closeIconSize = 24,
    this.closeIconColor,
    this.closeIconBackgroundColor,
    this.closeIconBackgroundPadding,
    this.closeIconBackgroundRadius,
    this.centerTitle = true,
    this.elevation = 0,
    this.showSafeArea = true,
  });

  /// Title rendered centered (or leading, depending on [centerTitle]).
  /// Pass `null` to render without a title.
  final String? title;

  /// Tap handler for the close button. When `null` the close button is
  /// not rendered (use [leading] to supply a custom one).
  final VoidCallback? onClose;

  /// Custom leading widget. Takes precedence over the default close
  /// button. Use this for a back arrow or avatar.
  final Widget? leading;

  /// Optional trailing actions (e.g. a help / contact button).
  final List<Widget>? actions;

  /// Bar height excluding safe-area inset. Defaults to 56.
  final double height;

  /// Horizontal padding around the bar's content. Defaults to
  /// `EdgeInsets.symmetric(horizontal: 8)`.
  final EdgeInsetsGeometry? padding;

  /// Background color. Defaults to `Colors.transparent` so the bar sits
  /// flush over gradient backgrounds.
  final Color? backgroundColor;

  /// Title text style. Defaults to `theme.typography.title` shrunk to
  /// 18 / w600.
  final TextStyle? titleStyle;

  /// Override the title color without re-declaring the full text style.
  /// Defaults to `theme.colors.textStrong`.
  final Color? titleColor;

  /// Custom icon to render inside the close-button container. Defaults to
  /// `Icons.close`.
  final IconData? closeIcon;

  /// Close-icon glyph size. Defaults to 24.
  final double closeIconSize;

  /// Close-icon foreground color. Defaults to `theme.colors.textStrong`.
  final Color? closeIconColor;

  /// Background color for the round container around the close icon.
  /// Defaults to `theme.colors.stroke` (subtle neutral chip). Pass
  /// `Colors.transparent` to drop the chip.
  final Color? closeIconBackgroundColor;

  /// Padding around the close icon inside its background chip. Defaults
  /// to `EdgeInsets.all(8)`.
  final EdgeInsetsGeometry? closeIconBackgroundPadding;

  /// Border radius of the close-icon chip. Defaults to a perfect circle
  /// (`BorderRadius.circular(100)`).
  final BorderRadius? closeIconBackgroundRadius;

  /// When true, [title] is centered; when false, it sits next to the
  /// leading widget.
  final bool centerTitle;

  /// Material elevation. Defaults to 0 (flat bar).
  final double elevation;

  /// When true, the bar respects the top safe-area inset. Set false if
  /// the parent already provides safe-area padding.
  final bool showSafeArea;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final Color resolvedTitleColor = titleColor ?? colors.textStrong;
    final TextStyle resolvedTitleStyle = (titleStyle ??
            typography.title.copyWith(fontSize: 18, height: 1.5))
        .copyWith(color: resolvedTitleColor);

    final Widget? resolvedLeading = leading ??
        (onClose != null
            ? _CloseButton(
                onTap: onClose!,
                icon: closeIcon ?? Icons.close,
                iconSize: closeIconSize,
                iconColor: closeIconColor ?? colors.textStrong,
                backgroundColor: closeIconBackgroundColor ?? colors.stroke,
                padding: closeIconBackgroundPadding ?? const EdgeInsets.all(8),
                radius: closeIconBackgroundRadius ?? BorderRadius.circular(100),
              )
            : null);

    Widget bar = SizedBox(
      height: height,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
        child: NavigationToolbar(
          leading: resolvedLeading,
          middle: title == null
              ? null
              : Text(title!, style: resolvedTitleStyle, overflow: TextOverflow.ellipsis),
          trailing: actions == null
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
          centerMiddle: centerTitle,
        ),
      ),
    );

    if (showSafeArea) {
      bar = SafeArea(bottom: false, child: bar);
    }

    return Material(
      color: backgroundColor ?? Colors.transparent,
      elevation: elevation,
      child: bar,
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({
    required this.onTap,
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.backgroundColor,
    required this.padding,
    required this.radius,
  });

  final VoidCallback onTap;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    // Compute a guaranteed-square footprint so NavigationToolbar's leading
    // slot doesn't stretch the chip horizontally. The padding contributes
    // on both axes; we honor it but still pin to a square box.
    final EdgeInsets resolved = padding.resolve(Directionality.maybeOf(context));
    final double side = iconSize + resolved.horizontal;
    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: side,
          height: side,
          child: Center(child: Icon(icon, size: iconSize, color: iconColor)),
        ),
      ),
    );
  }
}
