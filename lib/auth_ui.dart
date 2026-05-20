/// Pure UI components for authentication flows — login, register, OTP,
/// forgot / reset password.
///
/// Consumers import only from this barrel:
///
/// ```dart
/// import 'package:auth_ui/auth_ui.dart';
/// ```
///
/// Everything under `src/` is package-private. See `README.md` and
/// `CONTRIBUTING.md` for usage guidelines and the phased rollout plan.
library auth_ui;

// Theme tokens.
export 'src/theme/auth_colors.dart';
export 'src/theme/auth_spacing.dart';
export 'src/theme/auth_theme.dart';
export 'src/theme/auth_typography.dart';

// Localized strings.
export 'src/strings/auth_strings.dart';

// Asset configuration.
export 'src/assets/auth_assets.dart';

// Atom widgets.
export 'src/widgets/auth_app_bar.dart';
export 'src/widgets/auth_primary_button.dart';
export 'src/widgets/auth_social_button.dart';
export 'src/widgets/auth_text_field.dart';
export 'src/widgets/pancake_id_button.dart';

// Full-page views.
export 'src/views/forgot_password_view.dart';
export 'src/views/login_view.dart';
export 'src/views/otp_view.dart';
export 'src/views/pancake_id_login_view.dart';
export 'src/views/register_view.dart';
export 'src/views/reset_password_view.dart';

// Re-export pin_code_fields' `ErrorAnimationType` so hosts don't have to
// import the dependency directly when they wire `OtpView`'s shake stream.
export 'package:pin_code_fields/pin_code_fields.dart' show ErrorAnimationType;
