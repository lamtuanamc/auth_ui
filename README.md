# auth_ui

Pure UI components for authentication flows — login, register, OTP, forgot /
reset password. Brand-agnostic, dependency-light, designed to be embedded in
multiple products by injecting `AuthTheme`, `AuthStrings`, and `AuthAssets`.

> **Status**: shipping. v0.1.2 published — every phase below is done; the
> package is wired into `pos_mobile` in production via a git dependency.

## Design principles

1. **Pure UI, no business logic.** Widgets accept inputs and emit events. No
   `Provider`, no network calls, no router knowledge, no storage access.
2. **Fully controlled.** State lives in the host. Views take values and
   callbacks; they never call `Navigator` or mutate persistent storage.
3. **Theme injection over hard-coded colors/fonts.** Branding is supplied
   through `AuthTheme` (a `ThemeExtension`).
4. **Strings injected, never compiled in.** Localization is the host's
   responsibility; pass an `AuthStrings` instance built from your i18n layer.
5. **Asset overrides supported.** Default assets ship inside the package, but
   any host can override individual paths via `AuthAssets`.
6. **Every visual property is nullable + theme-fallback.** Color, border,
   radius, padding, height, shadow, typography — all are per-instance
   overridable; omitted values resolve through `AuthTheme.of(context)`.
7. **Lean dependencies.** `flutter`, `flutter_svg`, and `pin_code_fields`
   (used by `OtpView`). No Provider, no Dio, no Firebase, no auth SDKs.

## What ships

**Tokens**
- `AuthColors` (24 fields), `AuthTypography` (12 styles), `AuthSpacing`
  (15 dimensions), aggregated in `AuthTheme` (a `ThemeExtension`). Default
  Pancake palette exposed as `AuthTheme.pancakeLight`.

**Strings** — locale-agnostic, split by screen
- `LoginStrings`, `PancakeIdLoginStrings`, `OtpStrings`, `RegisterStrings`,
  `ForgotPasswordStrings`, `ResetPasswordStrings`. All composed in
  `AuthStrings`. Vietnamese defaults via each `.vi()` factory.

**Assets**
- `AuthAssets.bundled` ships 11 SVG/PNG assets for the default Pancake brand
  under `lib/assets/login/`. Each path is per-asset overridable; set
  `packageName: null` to read overrides from the host's bundle.

**Atom widgets**
- `AuthPrimaryButton`, `AuthTextField`, `AuthSocialButton` (Facebook /
  Google / Apple / Custom via `AuthSocialButtonStyle`), `AuthSocialIconButton`
  (compact icon-only variant), `AuthAppBar`, `PancakeIdButton`.

**Full-page views** — fully controlled
- `LoginView` — landing screen (header + banner + provider stack + footer
  link). Logo and full-screen background are slot-overridable.
- `PancakeIdLoginView` — credential screen with login + social row + sign-up
  prompt.
- `OtpView` — 4-box pin input + host-driven countdown + resend + submit.
- `RegisterView` — first/last name + identity (phone OR email) + password +
  confirm.
- `ForgotPasswordView` — identity-type switcher + account field.
- `ResetPasswordView` — password + confirm + submit.

## Installation

```yaml
# pubspec.yaml of the host app
dependencies:
  auth_ui:
    git:
      url: https://github.com/lamtuanamc/auth_ui.git
      ref: v0.1.2

# If your host also depends on a package that pins flutter_svg ^1.x, force
# the newer major — auth_ui needs ^2.0.10 and the older 1.x is API-compatible
# for the constructors that package uses.
dependency_overrides:
  flutter_svg: ^2.0.10
```

```dart
import 'package:auth_ui/auth_ui.dart';
```

## Quick start

```dart
import 'package:auth_ui/auth_ui.dart';
import 'package:flutter/material.dart';

// 1. Register the theme extension once on the host's ThemeData.
final myTheme = ThemeData(
  useMaterial3: true,
  extensions: const <ThemeExtension<dynamic>>[AuthTheme.pancakeLight],
);

// 2. Compose the strings bundle from your i18n source — or use the
//    Pancake-flavored Vietnamese defaults.
final strings = AuthStrings.vi();

// 3. Drop the view in. Every callback is yours; the view never navigates.
class HostLoginPage extends StatefulWidget {
  const HostLoginPage({super.key});
  @override
  State<HostLoginPage> createState() => _HostLoginPageState();
}

class _HostLoginPageState extends State<HostLoginPage> {
  @override
  Widget build(BuildContext context) {
    return LoginView(
      strings: strings.login,
      assets: AuthAssets.bundled,
      onPancakeIdPressed: _openPancakeIdScreen,
      onFacebookPressed: _signInWithFacebook,
      onGooglePressed: _signInWithGoogle,
      onApplePressed: _signInWithApple,
      showAppleButton: Platform.isIOS,
    );
  }

  void _openPancakeIdScreen() { /* push route, owned by host */ }
  void _signInWithFacebook() { /* call your auth SDK */ }
  void _signInWithGoogle() { /* ... */ }
  void _signInWithApple() { /* ... */ }
}
```

## Customisation

Every visual property is nullable and falls back to `AuthTheme.of(context)`
when omitted. Mix-and-match — no need to redeclare a full theme to tweak
one button.

```dart
// Local override — wider, red, taller submit button.
AuthPrimaryButton(
  label: 'Xoá tài khoản',
  onPressed: _confirmDelete,
  backgroundColor: Colors.red,
  height: 56,
  padding: const EdgeInsets.symmetric(horizontal: 32),
);

// Brand swap — replace only the accent across every widget on screen.
final brandTheme = AuthTheme.pancakeLight.copyWith(
  colors: AuthTheme.pancakeLight.colors.copyWith(
    accent: const Color(0xFFE91E63),
  ),
);

// Image background on the landing screen — `background:` decoration
// overrides the default gradient.
LoginView(
  strings: strings.login,
  assets: AuthAssets.bundled,
  onPancakeIdPressed: _openPancakeId,
  background: const BoxDecoration(
    image: DecorationImage(image: AssetImage('bg.jpg'), fit: BoxFit.cover),
  ),
  logo: const FlutterLogo(size: 48),
);
```

## Preview gallery (Widgetbook)

`example/` is a Widgetbook host that catalogs every public widget and view
across themes, devices, and text scales:

```bash
cd example
flutter run -d chrome   # or -d macos / -d ios / -d android
```

27 stories across **Tokens**, **Atoms**, and **Views**. Toggle theme
(Pancake Light ↔ Custom Magenta) and text scale from the toolbar.

## Roadmap

| Phase | Deliverable | Status |
| --- | --- | --- |
| 1 | Bootstrap package + design tokens + strings + assets | ✅ Done |
| 2 | Atom widgets (`AuthPrimaryButton`, `AuthTextField`, `AuthSocialButton`, `AuthAppBar`, `PancakeIdButton`) | ✅ Done |
| 3 | `LoginView` + `PancakeIdLoginView` (controlled) | ✅ Done |
| 4 | Remaining views (OTP, register, forgot, reset) | ✅ Done |
| 5 | Widgetbook stories under `example/` | ✅ Done |
| 6 | Full docs + integration guide | ✅ Done |
| 7 | Wire `pos_mobile` to consume this package | ✅ Done |

## Contributing

See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for naming conventions, doc-comment
rules, and the story-required policy applied from Phase 2 onward.
