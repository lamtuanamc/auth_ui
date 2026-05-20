import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../strings/auth_strings.dart';
import '../theme/auth_theme.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_primary_button.dart';

/// OTP verification screen: 4-box pin input, countdown timer with resend
/// affordance, and a submit button at the bottom.
///
/// **Fully controlled.** The host owns:
/// - the OTP value (`code`) and its [onChanged]/[onCompleted] events,
/// - the destination string (phone / email) injected into the subtitle,
/// - the countdown — the view does NOT run any timer internally; pass
///   [remaining] every tick and call [onResend] when the user taps. This
///   keeps the package free of `Timer` resources and makes resend
///   throttling host-controlled.
/// - the shake-error stream so the host can flash the input on a bad
///   server response.
///
/// **Theme-first, override-everywhere.** [strings] is required; every
/// visual property is nullable.
///
/// ## Example
///
/// ```dart
/// OtpView(
///   strings: authStrings.otp,
///   destination: '+84 *** *** 123',
///   code: _otp,
///   onChanged: (v) => setState(() => _otp = v),
///   onCompleted: _verify,
///   onSubmit: () => _verify(_otp),
///   onResend: _requestOtp,
///   remaining: _remaining,
///   onClose: () => Navigator.of(context).pop(),
///   errorStream: _errorStream.stream,
/// );
/// ```
class OtpView extends StatelessWidget {
  /// Creates an OTP view.
  const OtpView({
    required this.strings,
    required this.destination,
    required this.code,
    required this.onChanged,
    required this.onCompleted,
    required this.onSubmit,
    required this.onResend,
    super.key,
    this.remaining = Duration.zero,
    this.onClose,
    this.length = 4,
    this.canResend,
    this.submitLoading = false,
    this.errorStream,
    this.errorText,
    this.autofocus = true,
    // Visual overrides
    this.backgroundColor,
    this.background,
    this.titlePadding,
    this.subtitlePadding,
    this.bodyPadding,
    this.bottomBarPadding,
    this.titleStyle,
    this.subtitleStyle,
    this.timerStyle,
    this.cantReceiveStyle,
    this.resendStyle,
    this.disabledResendStyle,
    this.pinFieldHeight,
    this.pinFieldWidth,
    this.pinFieldRadius,
    this.pinFieldOuterPadding,
    this.pinFieldActiveBorder,
    this.pinFieldInactiveBorder,
    this.pinFieldFocusedBorder,
    this.logo,
  });

  /// Localized strings.
  final OtpStrings strings;

  /// Masked destination string injected into `strings.subtitleTemplate`
  /// at the `{destination}` placeholder. Hosts decide how to mask the
  /// phone / email before passing it in.
  final String destination;

  /// Current code value. The view mirrors this through `PinCodeTextField`.
  final String code;

  /// Fires on every keystroke. Use to keep [code] in sync.
  final ValueChanged<String> onChanged;

  /// Fires when the user enters all [length] digits.
  final ValueChanged<String> onCompleted;

  /// Fires when the submit button is tapped while [code] has [length]
  /// characters. Hosts typically call the same handler from
  /// [onCompleted] and this slot — the duplication lets the user submit
  /// after auto-correcting a partial paste.
  final VoidCallback onSubmit;

  /// Fires when the user taps the resend tap target. Hosts gate
  /// throttling — the view does not enforce a minimum interval.
  final VoidCallback onResend;

  /// Remaining time before the user can resend. `Duration.zero` (the
  /// default) hides the countdown and shows the resend tap target as
  /// active. Hosts decrement this once per second.
  final Duration remaining;

  /// Tap handler for the close button. When `null` the close button is
  /// hidden.
  final VoidCallback? onClose;

  /// Number of OTP digits. Defaults to 4.
  final int length;

  /// Override the resend-enabled gate. When `null` the view derives it
  /// from `remaining == Duration.zero`.
  final bool? canResend;

  /// When true, the submit button shows a spinner.
  final bool submitLoading;

  /// Stream of shake / animation triggers, forwarded to
  /// `PinCodeTextField.errorAnimationController`. Host emits an event
  /// (e.g. `ErrorAnimationType.shake`) when a verification request
  /// fails.
  final Stream<ErrorAnimationType>? errorStream;

  /// Inline error message rendered under the pin boxes. When set and
  /// non-empty, the pin boxes also switch their border to the error
  /// tint. Pass `null` or empty to hide.
  final String? errorText;

  /// Whether the input requests focus on mount.
  final bool autofocus;

  // --- Visual overrides ----------------------------------------------------

  /// Scaffold background color. Defaults to white.
  final Color? backgroundColor;

  /// Replace the entire background with a custom decoration (gradient,
  /// image, …). Takes precedence over [backgroundColor].
  final Decoration? background;

  /// Padding around the title. Defaults to `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? titlePadding;

  /// Padding around the subtitle. Defaults to `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? subtitlePadding;

  /// Outer padding around the body column. Defaults to
  /// `EdgeInsets.only(top: 32)`.
  final EdgeInsetsGeometry? bodyPadding;

  /// Padding around the bottom bar content. Defaults to
  /// `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? bottomBarPadding;

  /// Title text style.
  final TextStyle? titleStyle;

  /// Subtitle text style.
  final TextStyle? subtitleStyle;

  /// Countdown timer text style.
  final TextStyle? timerStyle;

  /// "Không nhận được mã?" prefix style.
  final TextStyle? cantReceiveStyle;

  /// "Bấm để gửi lại" style when resend is enabled.
  final TextStyle? resendStyle;

  /// "Bấm để gửi lại" style when countdown is still running.
  final TextStyle? disabledResendStyle;

  /// Pin-code single-box height.
  final double? pinFieldHeight;

  /// Pin-code single-box width.
  final double? pinFieldWidth;

  /// Pin-code box radius.
  final double? pinFieldRadius;

  /// Outer horizontal padding between pin boxes.
  final EdgeInsetsGeometry? pinFieldOuterPadding;

  /// Pin-code active border color (per-character).
  final Color? pinFieldActiveBorder;

  /// Pin-code inactive border color.
  final Color? pinFieldInactiveBorder;

  /// Pin-code focused (selected) border color.
  final Color? pinFieldFocusedBorder;

  /// Replace the default page logo. When `null` no logo is rendered.
  final Widget? logo;

  @override
  Widget build(BuildContext context) {
    final theme = AuthTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final String renderedSubtitle =
        strings.subtitleTemplate.replaceAll('{destination}', destination);
    final bool resolvedCanResend = canResend ?? (remaining == Duration.zero);
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    final Widget body = SingleChildScrollView(
      child: Padding(
        padding: bodyPadding ?? const EdgeInsets.only(top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (logo != null) Padding(padding: const EdgeInsets.all(16), child: logo),
            Padding(
              padding: titlePadding ?? const EdgeInsets.all(16),
              child: Text(
                strings.title,
                style: titleStyle ??
                    typography.title.copyWith(fontSize: 24, color: colors.textStrong),
              ),
            ),
            Padding(
              padding: subtitlePadding ?? const EdgeInsets.all(16),
              child: Text(
                renderedSubtitle,
                style:
                    subtitleStyle ?? typography.subtitle.copyWith(color: colors.textSecondary),
              ),
            ),
            const SizedBox(height: 20),
            PinCodeTextField(
              appContext: context,
              length: length,
              autoFocus: autofocus,
              autoDisposeControllers: true,
              animationType: AnimationType.fade,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              enablePinAutofill: true,
              cursorColor: colors.textStrong,
              keyboardType: TextInputType.number,
              mainAxisAlignment: MainAxisAlignment.center,
              errorAnimationController: errorStream == null
                  ? null
                  : (StreamController<ErrorAnimationType>()..addStream(errorStream!)),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                fieldHeight: pinFieldHeight ?? 64,
                fieldWidth: pinFieldWidth ?? 64,
                borderRadius: BorderRadius.circular(pinFieldRadius ?? 8),
                borderWidth: 1,
                fieldOuterPadding:
                    pinFieldOuterPadding ?? const EdgeInsets.symmetric(horizontal: 6),
                activeColor: hasError
                    ? colors.error
                    : (pinFieldActiveBorder ?? colors.stroke),
                inactiveColor: hasError
                    ? colors.error
                    : (pinFieldInactiveBorder ?? colors.stroke),
                selectedColor: hasError
                    ? colors.error
                    : (pinFieldFocusedBorder ?? colors.accent),
                activeFillColor: colors.inputBackground,
                inactiveFillColor: colors.inputBackground,
                selectedFillColor: colors.inputBackground,
              ),
              onChanged: onChanged,
              onCompleted: onCompleted,
              beforeTextPaste: (_) => true,
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                child: Center(
                  child: Text(
                    errorText!,
                    style: typography.errorText.copyWith(color: colors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: background != null ? Colors.transparent : (backgroundColor ?? Colors.white),
      appBar: AuthAppBar(onClose: onClose),
      body: background == null ? body : DecoratedBox(decoration: background!, child: body),
      bottomNavigationBar: Material(
        color: background != null ? Colors.transparent : (backgroundColor ?? Colors.white),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: bottomBarPadding ?? const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (remaining > Duration.zero)
                  Text(
                    _formatRemaining(remaining),
                    style: timerStyle ??
                        typography.title.copyWith(
                          fontSize: 18,
                          color: colors.textStrong,
                          height: 1.56,
                        ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      strings.cantReceive,
                      style: cantReceiveStyle ??
                          typography.subtitle.copyWith(color: colors.textSecondary),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: resolvedCanResend ? onResend : null,
                      child: Text(
                        strings.resendAction,
                        style: resolvedCanResend
                            ? (resendStyle ??
                                typography.linkSecondary.copyWith(color: colors.accent))
                            : (disabledResendStyle ??
                                typography.linkSecondary.copyWith(color: colors.textTertiary)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AuthPrimaryButton(
                  label: strings.continueButton,
                  onPressed: code.length == length ? onSubmit : null,
                  enabled: code.length == length,
                  loading: submitLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatRemaining(Duration value) {
    final int minutes = value.inMinutes;
    final int seconds = value.inSeconds % 60;
    final String mm = minutes < 10 ? '0$minutes' : '$minutes';
    final String ss = seconds < 10 ? '0$seconds' : '$seconds';
    return '$mm:$ss';
  }
}
