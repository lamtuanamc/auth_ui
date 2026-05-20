# Changelog

All notable changes to `auth_ui` are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
