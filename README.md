# auth_ui

Pure UI components for authentication flows — login, register, OTP, forgot /
reset password. Brand-agnostic, dependency-light, designed to be embedded in
multiple products by injecting `AuthTheme`, `AuthStrings`, and `AuthAssets`.

> **Status**: Phase 1 (bootstrap). Only design tokens, strings, and asset
> configuration are exposed. Widgets and views land in subsequent phases.

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
6. **Lean dependencies.** `flutter` and `flutter_svg` only — no Provider, no
   Dio, no Firebase, no auth SDKs.

## Installation

```yaml
# pubspec.yaml of the host app
dependencies:
  auth_ui:
    path: ../auth_ui
```

```dart
import 'package:auth_ui/auth_ui.dart';
```

## Quick start (Phase 1 surface)

```dart
import 'package:auth_ui/auth_ui.dart';
import 'package:flutter/material.dart';

final myTheme = ThemeData(
  extensions: const [
    // Brand defaults that match Pancake POS today.
    AuthTheme.pancakeLight,
    // Or compose your own:
    // AuthTheme(colors: ..., typography: ..., spacing: ...),
  ],
);

final myStrings = AuthStrings.vi(); // or AuthStrings(...) with overrides
final myAssets = AuthAssets.bundled; // assets shipped inside this package
```

## Phased roadmap

| Phase | Deliverable | Status |
| --- | --- | --- |
| 1 | Bootstrap package + design tokens + strings + assets | **In progress** |
| 2 | Atom widgets (`AuthPrimaryButton`, `AuthTextField`, `AuthSocialButton`, `AuthAppBar`, `PancakeIdButton`) | Pending |
| 3 | `LoginView` + `PancakeIdLoginView` (controlled) | Pending |
| 4 | Remaining views (OTP, register, forgot, reset) | Pending |
| 5 | Widgetbook stories under `example/` | Pending |
| 6 | Full docs + integration guide | Pending |
| 7 | Wire `pos_mobile` to consume this package | Pending |

See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for naming conventions, doc-comment
rules, and the story-required policy applied from Phase 2 onward.
