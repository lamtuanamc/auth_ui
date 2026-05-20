import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/auth_theme.dart';

/// Single-line text input with the auth-flow visual treatment: label above,
/// white rounded container with subtle shadow, optional error line below,
/// optional eye toggle for passwords.
///
/// **Controlled by the host.** The widget takes a [TextEditingController]
/// (standard Flutter idiom) and emits change / submit callbacks. It does
/// not manage validation state internally — pass [errorText] when the host
/// decides the field is invalid.
///
/// **Theme-first, override-everywhere.** Every visual property is nullable
/// and resolves through [AuthTheme.of] when omitted.
///
/// ## Example
///
/// ```dart
/// AuthTextField(
///   label: 'Tài khoản',
///   controller: _identityController,
///   errorText: _identityError,
///   textInputAction: TextInputAction.next,
///   autofocus: true,
///   onChanged: (v) => setState(() => _identityError = ''),
/// );
///
/// AuthTextField(
///   label: 'Mật khẩu',
///   controller: _passwordController,
///   obscureText: _hidden,
///   onObscureToggle: () => setState(() => _hidden = !_hidden),
///   onSubmitted: (_) => _submit(),
/// );
/// ```
class AuthTextField extends StatelessWidget {
  /// Creates an input. [controller] is required so the host owns the
  /// text state. [label] is required so the field always has an
  /// accessible name; pass an empty string only if a label is rendered by
  /// an enclosing widget.
  const AuthTextField({
    required this.label,
    required this.controller,
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.onObscureToggle,
    this.enabled = true,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.maxLength,
    // Visual overrides ---------------------------------------------------
    this.height,
    this.contentPadding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.errorBorderColor,
    this.focusedBorderColor,
    this.shadows,
    this.labelStyle,
    this.inputStyle,
    this.hintStyle,
    this.errorStyle,
    this.labelGap,
    this.errorGap,
    this.suffix,
    this.prefix,
  });

  /// Label rendered above the input container. Pass an empty string to
  /// suppress.
  final String label;

  /// Text controller owned by the host.
  final TextEditingController controller;

  /// Optional placeholder text rendered inside the empty input.
  final String? hintText;

  /// Optional error rendered below the input; also drives the border
  /// color via [errorBorderColor]. Pass `null` or empty to clear.
  final String? errorText;

  /// When true, characters are masked. Use together with [onObscureToggle]
  /// to render an eye-toggle suffix.
  final bool obscureText;

  /// Invoked when the eye-toggle suffix is tapped. Pass `null` to hide
  /// the suffix even when [obscureText] is true (e.g. for OTP fields).
  final VoidCallback? onObscureToggle;

  /// When false, the field cannot be focused, ignores input, and renders
  /// at reduced opacity.
  final bool enabled;

  /// Whether the field should request focus on mount.
  final bool autofocus;

  /// Soft keyboard type. Defaults to the platform default.
  final TextInputType? keyboardType;

  /// Submit-key affinity. Use [TextInputAction.next] to advance through a
  /// multi-field form.
  final TextInputAction? textInputAction;

  /// Optional formatters (e.g. digits-only for OTP). Applied in order.
  final List<TextInputFormatter>? inputFormatters;

  /// Fires on every keystroke.
  final ValueChanged<String>? onChanged;

  /// Fires when the user presses the [textInputAction] key.
  final ValueChanged<String>? onSubmitted;

  /// External focus node when the host needs to programmatically focus.
  final FocusNode? focusNode;

  /// Hard cap on input length. The counter is hidden — set this only when
  /// the host has a separate counter UI.
  final int? maxLength;

  // ---------------------------------------------------------------------
  // Visual overrides
  // ---------------------------------------------------------------------

  /// Fixed input container height. Defaults to intrinsic sizing driven by
  /// [contentPadding].
  final double? height;

  /// Padding inside the input container. Defaults to
  /// `EdgeInsets.only(top: 10, left: 12, right: 10, bottom: 10)`.
  final EdgeInsetsGeometry? contentPadding;

  /// Corner radius. Defaults to `theme.spacing.inputRadius` (10).
  final BorderRadius? borderRadius;

  /// Container background. Defaults to `theme.colors.inputBackground`.
  final Color? backgroundColor;

  /// Resting border color (no focus, no error). Defaults to
  /// `theme.colors.stroke`.
  final Color? borderColor;

  /// Border thickness in every state. Defaults to 1.
  final double? borderWidth;

  /// Border color when [errorText] is set. Defaults to
  /// `theme.colors.error`.
  final Color? errorBorderColor;

  /// Border color when the field has focus and no error. Defaults to
  /// [borderColor] (no focus highlight) for parity with the existing
  /// design.
  final Color? focusedBorderColor;

  /// Drop-shadow stack. Defaults to a single soft shadow tinted with
  /// `theme.colors.shadowSubtle`.
  final List<BoxShadow>? shadows;

  /// Style applied to [label]. Defaults to `theme.typography.label`
  /// tinted with `theme.colors.textStrong`.
  final TextStyle? labelStyle;

  /// Style applied to the input text. Defaults to `theme.typography.label`
  /// tinted with `theme.colors.textStrong`.
  final TextStyle? inputStyle;

  /// Style applied to [hintText]. Defaults to [inputStyle] tinted with
  /// `theme.colors.textTertiary`.
  final TextStyle? hintStyle;

  /// Style applied to [errorText]. Defaults to `theme.typography.errorText`
  /// tinted with `theme.colors.error`.
  final TextStyle? errorStyle;

  /// Vertical gap between the label and the input container. Defaults to
  /// `theme.spacing.fieldLabelGap` (4).
  final double? labelGap;

  /// Vertical gap between the input container and the error line. Defaults
  /// to `theme.spacing.fieldLabelGap` (4).
  final double? errorGap;

  /// Trailing widget inside the input. When `null`, the default behavior
  /// is to render the eye-toggle when [obscureText] is in use and
  /// [onObscureToggle] is non-null.
  final Widget? suffix;

  /// Leading widget inside the input (e.g. a country-code chip).
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final spacing = theme.spacing;

    final bool hasError = errorText != null && errorText!.isNotEmpty;
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(spacing.inputRadius);
    final double resolvedBorderWidth = borderWidth ?? 1;
    final Color resolvedBorderColor = hasError
        ? (errorBorderColor ?? colors.error)
        : (borderColor ?? colors.stroke);
    final EdgeInsetsGeometry resolvedPadding = contentPadding ??
        const EdgeInsets.only(top: 10, left: 12, right: 10, bottom: 10);

    final TextStyle resolvedLabelStyle =
        (labelStyle ?? typography.label).copyWith(color: colors.textStrong);
    final TextStyle resolvedInputStyle =
        (inputStyle ?? typography.label).copyWith(color: colors.textStrong);
    final TextStyle resolvedHintStyle =
        (hintStyle ?? resolvedInputStyle).copyWith(color: colors.textTertiary);
    final TextStyle resolvedErrorStyle =
        (errorStyle ?? typography.errorText).copyWith(color: colors.error);

    final List<BoxShadow> resolvedShadows = shadows ??
        <BoxShadow>[
          BoxShadow(
            color: colors.shadowSubtle,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ];

    final VoidCallback? obscureToggle = onObscureToggle;
    final Widget? trailing = suffix ??
        (obscureToggle != null
            ? _ObscureToggle(
                obscured: obscureText,
                onTap: obscureToggle,
                color: colors.textTertiary,
              )
            : null);

    final Widget field = TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      style: resolvedInputStyle,
      cursorColor: colors.accent,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: resolvedHintStyle,
        counterText: '',
      ),
    );

    final Widget container = Container(
      height: height,
      decoration: ShapeDecoration(
        color: backgroundColor ?? colors.inputBackground,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: resolvedBorderWidth, color: resolvedBorderColor),
          borderRadius: radius,
        ),
        shadows: resolvedShadows,
      ),
      child: Padding(
        padding: resolvedPadding,
        child: Row(
          children: [
            if (prefix != null) ...[
              prefix!,
              const SizedBox(width: 8),
            ],
            Expanded(child: field),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ],
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: resolvedLabelStyle),
          SizedBox(height: labelGap ?? spacing.fieldLabelGap),
        ],
        if (focusedBorderColor != null)
          Focus(
            child: Builder(
              builder: (innerContext) {
                final bool hasFocus = Focus.of(innerContext).hasFocus;
                if (!hasFocus || hasError) {
                  return container;
                }
                return Container(
                  height: height,
                  decoration: ShapeDecoration(
                    color: backgroundColor ?? colors.inputBackground,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: resolvedBorderWidth, color: focusedBorderColor!),
                      borderRadius: radius,
                    ),
                    shadows: resolvedShadows,
                  ),
                  child: Padding(
                    padding: resolvedPadding,
                    child: Row(
                      children: [
                        if (prefix != null) ...[
                          prefix!,
                          const SizedBox(width: 8),
                        ],
                        Expanded(child: field),
                        if (trailing != null) ...[
                          const SizedBox(width: 8),
                          trailing,
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        else
          container,
        if (hasError) ...[
          SizedBox(height: errorGap ?? spacing.fieldLabelGap),
          Text(errorText!, style: resolvedErrorStyle),
        ],
      ],
    );
  }
}

class _ObscureToggle extends StatelessWidget {
  const _ObscureToggle({required this.obscured, required this.onTap, required this.color});

  final bool obscured;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Icon(
        obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 20,
        color: color,
      ),
    );
  }
}
