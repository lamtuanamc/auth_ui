# Contributing to `auth_ui`

This package is consumed by multiple products. Treat every change as a public
API change. The rules below keep that contract predictable.

## Scope

`auth_ui` ships UI only.

**Allowed**: widgets, layout, design tokens, locale-agnostic strings, asset
configuration, pure rendering logic, form-field error display.

**Not allowed** in this package:
- Network calls or HTTP clients
- `Provider`, `Riverpod`, or any global state management
- `Navigator` / routing logic
- `SharedPreferences` / `Hive` / file I/O
- Firebase, social-login SDKs, deep-link listeners
- Anything that depends on the host app's i18n system directly

If a view needs a side effect (navigate, persist, call API), expose it as a
callback parameter and let the host handle it.

## Naming conventions

| Kind | Convention | Example |
| --- | --- | --- |
| Public type | `Auth` prefix | `AuthPrimaryButton`, `AuthTheme` |
| Brand-specific helpers | Keep brand name in identifier | `PancakeIdButton` |
| Private type | Leading underscore | `_PancakeIdButton` |
| Files | `snake_case.dart` | `auth_primary_button.dart` |
| Folders | `snake_case` | `lib/src/widgets/` |
| Boolean parameter | Affirmative phrasing | `enabled: true` not `disabled: false` |
| Callback parameter | `on<Event>` | `onPressed`, `onChanged`, `onSubmit` |

## Folder layout

```
lib/
├── auth_ui.dart                  # Single barrel — only file consumers import
└── src/
    ├── theme/                    # Tokens (colors, typography, spacing, AuthTheme)
    ├── strings/                  # AuthStrings + locale factories
    ├── assets/                   # AuthAssets configuration
    ├── widgets/                  # Atom widgets (Phase 2)
    └── views/                    # Full-page views (Phase 3+)
```

Anything under `src/` is treated as private to the package. Consumers must
import from `package:auth_ui/auth_ui.dart` — do not document `src/` paths.

## Documentation

- Every public class, constructor, method, and field carries a `///` doc
  comment. Use `dart doc` syntax (`{@template}`, `{@macro}`) where it helps.
- Each public widget MUST include a `/// ## Example` block with a minimal,
  copy-pasteable usage snippet.
- Doc comments describe *contracts* (what is required, what is returned),
  not implementation details.
- Comments inside method bodies should explain *why* a non-obvious choice
  was made — never restate *what* the code does.

## State

Default to **fully controlled** widgets: parent owns the state, the widget
exposes `value` and `onChanged`. This matches `TextField` and gives hosts
maximum flexibility. Controllers are introduced only when the API would be
unergonomic without one (e.g. complex multi-field forms in Phase 3+).

## Theming

- All colors come from `AuthTheme.of(context).colors`.
- All typography comes from `AuthTheme.of(context).typography`.
- All spacing, radii, and sizes come from `AuthTheme.of(context).spacing`.
- Never hard-code a `Color(0x...)`, font family, or magic spacing constant
  inside a widget. Add a new token if the value is missing.

## Strings

- Widgets accept text via `AuthStrings` (or a smaller per-widget data class
  if only a few strings apply). Do not import any i18n library.
- Adding a new visible string is an API change: bump version (`MINOR`),
  update `CHANGELOG.md`, add a default in `AuthStrings.vi()`.

## Stories (from Phase 2)

Every widget added under `lib/src/widgets/` or `lib/src/views/` MUST land
together with a Widgetbook story in `example/lib/stories/` covering, at
minimum: default state, disabled state, loading state (if applicable), and
error state (if applicable). Pull requests without a story are rejected.

## Versioning

Semantic versioning. Anything that breaks an existing import, type signature,
required parameter, named-parameter order, or default value bumps `MAJOR`.
New tokens, strings, optional parameters bump `MINOR`. Bug fixes bump `PATCH`.

## Lint and analyzer

Run `flutter analyze` from the package root before opening a PR. The
`analysis_options.yaml` here is stricter than the host repo on purpose — do
not relax it.

## Commit messages

Same conventions as the host monorepo (see root `CLAUDE.md`):
`feat: …`, `fix: …`, `chore: …`, `refactor: …` — lowercase, English.
