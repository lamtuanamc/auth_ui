# Changelog

All notable changes to `auth_ui` are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3]

### Added
- `OtpView.errorText` — inline error rendered under the pin boxes. When
  non-empty the pin boxes also switch to the error-tinted border so the
  rejection is visible at a glance. Widgetbook ships a new
  "Invalid code" story.

### Fixed
- `AuthAppBar` close button no longer renders as an oval — pinned to a
  guaranteed-square footprint so NavigationToolbar's leading slot stops
  stretching it.
- `AuthPrimaryButton` default height bumped from `buttonHeight` (48) to
  `primaryButtonHeight` (52) so the main CTA matches PancakeIdButton's
  visual weight.
- `OtpView`, `PancakeIdLoginView`, `RegisterView`, `ForgotPasswordView`,
  and `ResetPasswordView` swap `BottomAppBar` for
  `Material + SafeArea`. Material 3's `BottomAppBar` pinned the bar to
  80 px; OTP's countdown + resend + button stack was clipping with
  "BOTTOM OVERFLOWED BY 90 PIXELS".

## [0.1.2]

### Fixed
- Enabled web platform for the `example/` Widgetbook app (`flutter create
  . --platforms=web`); without this, `flutter run -d chrome` aborted with
  "This application is not configured to build on the web".
- Removed deprecated `DeviceFrameAddon` from the Widgetbook root — the
  addon hard-references a `Device` type that no longer compiles and is
  scheduled for removal upstream.
- Added direct `flutter_svg` dependency to `example/` (was only
  transitive via `auth_ui`, tripped the `depend_on_referenced_packages`
  lint).

## [0.1.1]

### Added
- `example/` Widgetbook app with 27 stories covering every token, atom,
  and view. Includes a custom-magenta theme story and device-frame +
  text-scale addons. Run with `cd example && flutter run`.

## [0.1.0]

Initial public release. Phase 1 + 2 + 3 of the planned rollout.

### Added
- Package skeleton: `pubspec.yaml`, `analysis_options.yaml` (strict),
  folder layout, `.gitignore`, README, CONTRIBUTING.
- Design tokens: `AuthColors` (24 fields), `AuthTypography` (12 slots),
  `AuthSpacing` (15 fields), `AuthTheme` (registered as a
  `ThemeExtension`, ships `AuthTheme.pancakeLight`).
- Localized strings split by screen: `LoginStrings`,
  `PancakeIdLoginStrings`, `OtpStrings`, `RegisterStrings`,
  `ForgotPasswordStrings`, `ResetPasswordStrings`, all aggregated in
  `AuthStrings`. Default Vietnamese values via every `.vi()` factory.
- `AuthAssets` configurable asset paths with `AuthAssets.bundled`; 11
  login SVG/PNG assets shipped under `lib/assets/login/`.
- Atom widgets: `AuthPrimaryButton`, `AuthTextField`,
  `AuthSocialButton` + `AuthSocialIconButton`
  (`AuthSocialButtonStyle.facebook|google|apple|custom`), `AuthAppBar`,
  `PancakeIdButton`. Every visual property (color, border, radius,
  padding, height, shadow, typography) is nullable and resolves
  through `AuthTheme.of` when omitted.
- Full-page views: `LoginView`, `PancakeIdLoginView`, `OtpView`,
  `RegisterView`, `ForgotPasswordView`, `ResetPasswordView`. All views
  are fully controlled — host owns controllers, state, and callbacks;
  the package never navigates, persists, or talks to a network. Every
  view exposes `logo` and `background` (Decoration) overrides plus
  granular padding / gap / style slots.
- Re-exports `ErrorAnimationType` from `pin_code_fields` so hosts can
  wire the OTP shake stream without importing the dependency directly.
