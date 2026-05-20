import 'package:flutter/foundation.dart';

/// All user-visible strings needed by widgets in `auth_ui`.
///
/// The package never imports an i18n library — localization is the host's
/// responsibility. Hosts construct an [AuthStrings] from their own
/// translation source (slang, intl, hand-rolled maps) and inject it into
/// the relevant view.
///
/// Strings are grouped by screen so a host can replace or override one
/// flow without touching the others. Each sub-group has a factory that
/// returns Pancake-flavored Vietnamese defaults; the top-level
/// [AuthStrings.vi] composes them.
///
/// Adding a new visible string is an API change: bump `MINOR`, document
/// the addition in `CHANGELOG.md`, and add a default in the relevant
/// `.vi()` factory.
///
/// ## Example
///
/// ```dart
/// // All-Vietnamese default:
/// final strings = AuthStrings.vi();
///
/// // Override only the login subset (e.g. white-label brand):
/// final strings = AuthStrings.vi().copyWith(
///   login: const LoginStrings(...),
/// );
/// ```
@immutable
class AuthStrings {
  /// Composes the five per-screen string bundles.
  const AuthStrings({
    required this.login,
    required this.pancakeIdLogin,
    required this.otp,
    required this.register,
    required this.forgotPassword,
    required this.resetPassword,
  });

  /// Default Vietnamese strings for every screen.
  factory AuthStrings.vi() => AuthStrings(
        login: LoginStrings.vi(),
        pancakeIdLogin: PancakeIdLoginStrings.vi(),
        otp: OtpStrings.vi(),
        register: RegisterStrings.vi(),
        forgotPassword: ForgotPasswordStrings.vi(),
        resetPassword: ResetPasswordStrings.vi(),
      );

  /// Landing login screen.
  final LoginStrings login;

  /// Pancake ID credential screen.
  final PancakeIdLoginStrings pancakeIdLogin;

  /// OTP verification screen.
  final OtpStrings otp;

  /// Register screen.
  final RegisterStrings register;

  /// Forgot-password screen.
  final ForgotPasswordStrings forgotPassword;

  /// Reset-password screen.
  final ResetPasswordStrings resetPassword;

  /// Returns a copy with the supplied sub-bundles overridden.
  AuthStrings copyWith({
    LoginStrings? login,
    PancakeIdLoginStrings? pancakeIdLogin,
    OtpStrings? otp,
    RegisterStrings? register,
    ForgotPasswordStrings? forgotPassword,
    ResetPasswordStrings? resetPassword,
  }) {
    return AuthStrings(
      login: login ?? this.login,
      pancakeIdLogin: pancakeIdLogin ?? this.pancakeIdLogin,
      otp: otp ?? this.otp,
      register: register ?? this.register,
      forgotPassword: forgotPassword ?? this.forgotPassword,
      resetPassword: resetPassword ?? this.resetPassword,
    );
  }
}

/// Strings used by the landing login screen.
@immutable
class LoginStrings {
  /// Creates a [LoginStrings] bundle. All fields required.
  const LoginStrings({
    required this.heading,
    required this.aProductOf,
    required this.pancakeIdButton,
    required this.facebookButton,
    required this.googleButton,
    required this.appleButton,
    required this.linkPrefix,
    required this.linkAction,
  });

  /// Default Vietnamese values.
  factory LoginStrings.vi() => const LoginStrings(
        heading: 'Quản lý bán hàng đa kênh',
        aProductOf: 'Một sản phẩm của',
        pancakeIdButton: 'Đăng nhập với Pancake ID',
        facebookButton: 'Đăng nhập với Facebook',
        googleButton: 'Đăng nhập với Google',
        appleButton: 'Đăng nhập với Apple',
        linkPrefix: 'Nếu bạn đang bị lỗi đăng nhập, vui lòng ',
        linkAction: 'Ấn vào đây',
      );

  /// Main heading.
  final String heading;

  /// Prefix copy in the "a product of …" pill.
  final String aProductOf;

  /// Primary CTA button label.
  final String pancakeIdButton;

  /// Facebook button label.
  final String facebookButton;

  /// Google button label.
  final String googleButton;

  /// Apple button label.
  final String appleButton;

  /// Sentence prefix before the "tap here" link.
  final String linkPrefix;

  /// Tap-target text inside the rich-text link.
  final String linkAction;
}

/// Strings used by the Pancake ID credential screen.
@immutable
class PancakeIdLoginStrings {
  /// Creates a [PancakeIdLoginStrings] bundle. All fields required.
  const PancakeIdLoginStrings({
    required this.title,
    required this.subtitle,
    required this.accountLabel,
    required this.passwordLabel,
    required this.forgotPassword,
    required this.loginButton,
    required this.loginWithDivider,
    required this.noAccountPrompt,
    required this.registerNowAction,
    required this.accountEmptyError,
    required this.passwordEmptyError,
  });

  /// Default Vietnamese values.
  factory PancakeIdLoginStrings.vi() => const PancakeIdLoginStrings(
        title: 'Đăng nhập với Pancake ID',
        subtitle: 'Vui lòng hoàn tất thông tin dưới đây để đăng nhập',
        accountLabel: 'Tài khoản',
        passwordLabel: 'Mật khẩu',
        forgotPassword: 'Quên mật khẩu?',
        loginButton: 'Đăng nhập',
        loginWithDivider: 'HOẶC ĐĂNG NHẬP VỚI',
        noAccountPrompt: 'Bạn chưa có tài khoản? ',
        registerNowAction: 'Đăng ký ngay',
        accountEmptyError: 'Tài khoản không được để trống',
        passwordEmptyError: 'Mật khẩu không được để trống',
      );

  /// Page title.
  final String title;

  /// Supporting copy under the title.
  final String subtitle;

  /// Identity-field label.
  final String accountLabel;

  /// Password-field label.
  final String passwordLabel;

  /// "Quên mật khẩu?" tap target.
  final String forgotPassword;

  /// Submit button.
  final String loginButton;

  /// Divider label between login form and social row.
  final String loginWithDivider;

  /// Bottom-bar prefix above the register CTA.
  final String noAccountPrompt;

  /// Bottom-bar register CTA tap target.
  final String registerNowAction;

  /// Inline error when the identity field is empty.
  final String accountEmptyError;

  /// Inline error when the password field is empty.
  final String passwordEmptyError;
}

/// Strings used by the OTP verification screen.
@immutable
class OtpStrings {
  /// Creates an [OtpStrings] bundle.
  const OtpStrings({
    required this.title,
    required this.subtitleTemplate,
    required this.cantReceive,
    required this.resendAction,
    required this.continueButton,
  });

  /// Default Vietnamese values.
  factory OtpStrings.vi() => const OtpStrings(
        title: 'Xác thực mã OTP',
        subtitleTemplate: 'Mã xác thực đã được gửi tới {destination}',
        cantReceive: 'Không nhận được mã?',
        resendAction: 'Bấm để gửi lại',
        continueButton: 'Tiếp tục',
      );

  /// Page title.
  final String title;

  /// Subtitle template containing `{destination}` placeholder which the
  /// view replaces with the masked phone / email at render time.
  final String subtitleTemplate;

  /// "Không nhận được mã?" prefix.
  final String cantReceive;

  /// "Bấm để gửi lại" tap target.
  final String resendAction;

  /// Submit / continue button.
  final String continueButton;
}

/// Strings used by the register screen.
@immutable
class RegisterStrings {
  /// Creates a [RegisterStrings] bundle.
  const RegisterStrings({
    required this.title,
    required this.subtitle,
    required this.firstNameLabel,
    required this.firstNameHint,
    required this.lastNameLabel,
    required this.lastNameHint,
    required this.registerByLabel,
    required this.phoneTypeLabel,
    required this.emailTypeLabel,
    required this.accountLabel,
    required this.phoneHint,
    required this.emailHint,
    required this.passwordLabel,
    required this.passwordHint,
    required this.confirmPasswordLabel,
    required this.confirmPasswordHint,
    required this.registerButton,
    required this.requiredFieldError,
    required this.phoneRequiredError,
    required this.phoneInvalidError,
    required this.emailInvalidError,
    required this.passwordEmptyError,
    required this.passwordMismatchError,
  });

  /// Default Vietnamese values.
  factory RegisterStrings.vi() => const RegisterStrings(
        title: 'Đăng ký tài khoản',
        subtitle: 'Vui lòng hoàn tất thông tin để đăng ký',
        firstNameLabel: 'Họ',
        firstNameHint: 'Nhập họ của bạn',
        lastNameLabel: 'Tên',
        lastNameHint: 'Nhập tên của bạn',
        registerByLabel: 'Đăng ký bằng',
        phoneTypeLabel: 'Số điện thoại',
        emailTypeLabel: 'Email',
        accountLabel: 'Tài khoản',
        phoneHint: 'Nhập số điện thoại của bạn',
        emailHint: 'Nhập email của bạn',
        passwordLabel: 'Mật khẩu',
        passwordHint: 'Nhập mật khẩu',
        confirmPasswordLabel: 'Xác nhận mật khẩu',
        confirmPasswordHint: 'Nhập lại mật khẩu',
        registerButton: 'Đăng ký',
        requiredFieldError: 'Vui lòng nhập thông tin',
        phoneRequiredError: 'Số điện thoại không được để trống',
        phoneInvalidError: 'Số điện thoại không hợp lệ',
        emailInvalidError: 'Email không hợp lệ',
        passwordEmptyError: 'Mật khẩu không được để trống',
        passwordMismatchError: 'Mật khẩu xác nhận không đúng',
      );

  /// Page title.
  final String title;

  /// Subtitle.
  final String subtitle;

  /// Label above the first-name input.
  final String firstNameLabel;

  /// Hint inside the first-name input.
  final String firstNameHint;

  /// Label above the last-name input.
  final String lastNameLabel;

  /// Hint inside the last-name input.
  final String lastNameHint;

  /// Label above the phone/email switcher.
  final String registerByLabel;

  /// Switcher option for "phone number".
  final String phoneTypeLabel;

  /// Switcher option for "email".
  final String emailTypeLabel;

  /// Label above the identity input.
  final String accountLabel;

  /// Phone-number hint.
  final String phoneHint;

  /// Email hint.
  final String emailHint;

  /// Label above the password input.
  final String passwordLabel;

  /// Hint inside the password input.
  final String passwordHint;

  /// Label above the confirm-password input.
  final String confirmPasswordLabel;

  /// Hint inside the confirm-password input.
  final String confirmPasswordHint;

  /// Submit button label.
  final String registerButton;

  /// Generic "required" error shown under first/last name when empty.
  final String requiredFieldError;

  /// Error shown under the phone field when empty.
  final String phoneRequiredError;

  /// Error shown under the phone field when invalid.
  final String phoneInvalidError;

  /// Error shown under the email field when invalid.
  final String emailInvalidError;

  /// Error shown under the password field when empty.
  final String passwordEmptyError;

  /// Error shown when password ≠ confirm password.
  final String passwordMismatchError;
}

/// Strings used by the forgot-password screen.
@immutable
class ForgotPasswordStrings {
  /// Creates a [ForgotPasswordStrings] bundle.
  const ForgotPasswordStrings({
    required this.title,
    required this.byLabel,
    required this.phoneTypeLabel,
    required this.emailTypeLabel,
    required this.accountLabel,
    required this.phoneHint,
    required this.emailHint,
    required this.continueButton,
    required this.accountEmptyError,
    required this.accountInvalidError,
    required this.emailInvalidError,
  });

  /// Default Vietnamese values.
  factory ForgotPasswordStrings.vi() => const ForgotPasswordStrings(
        title: 'Quên mật khẩu',
        byLabel: 'Quên mật khẩu bằng',
        phoneTypeLabel: 'Số điện thoại',
        emailTypeLabel: 'Email',
        accountLabel: 'Tài khoản',
        phoneHint: 'Nhập số điện thoại của bạn',
        emailHint: 'Nhập email của bạn',
        continueButton: 'Tiếp tục',
        accountEmptyError: 'Tài khoản không được để trống',
        accountInvalidError: 'Tài khoản không hợp lệ',
        emailInvalidError: 'Email không hợp lệ',
      );

  /// Page title.
  final String title;

  /// Label above the type switcher.
  final String byLabel;

  /// Switcher option for "phone".
  final String phoneTypeLabel;

  /// Switcher option for "email".
  final String emailTypeLabel;

  /// Label above the identity input.
  final String accountLabel;

  /// Phone-number hint.
  final String phoneHint;

  /// Email hint.
  final String emailHint;

  /// Submit button label.
  final String continueButton;

  /// Inline error when the identity field is empty.
  final String accountEmptyError;

  /// Inline error when the identity field is not a number.
  final String accountInvalidError;

  /// Inline error when the email is not valid.
  final String emailInvalidError;
}

/// Strings used by the reset-password screen.
@immutable
class ResetPasswordStrings {
  /// Creates a [ResetPasswordStrings] bundle.
  const ResetPasswordStrings({
    required this.title,
    required this.passwordLabel,
    required this.passwordHint,
    required this.confirmPasswordLabel,
    required this.confirmPasswordHint,
    required this.submitButton,
    required this.passwordEmptyError,
    required this.passwordMismatchError,
  });

  /// Default Vietnamese values.
  factory ResetPasswordStrings.vi() => const ResetPasswordStrings(
        title: 'Đặt lại mật khẩu',
        passwordLabel: 'Mật khẩu',
        passwordHint: 'Nhập mật khẩu mới',
        confirmPasswordLabel: 'Xác nhận mật khẩu',
        confirmPasswordHint: 'Nhập lại mật khẩu mới',
        submitButton: 'Tiếp tục',
        passwordEmptyError: 'Mật khẩu không được để trống',
        passwordMismatchError: 'Mật khẩu xác nhận không đúng',
      );

  /// Page title.
  final String title;

  /// Label above the password input.
  final String passwordLabel;

  /// Hint inside the password input.
  final String passwordHint;

  /// Label above the confirm-password input.
  final String confirmPasswordLabel;

  /// Hint inside the confirm-password input.
  final String confirmPasswordHint;

  /// Submit button label.
  final String submitButton;

  /// Inline error when password is empty.
  final String passwordEmptyError;

  /// Inline error when password ≠ confirm password.
  final String passwordMismatchError;
}
