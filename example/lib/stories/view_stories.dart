// ignore_for_file: public_member_api_docs — internal stories.

import 'package:auth_ui/auth_ui.dart';
import 'package:flutter/material.dart';

const AuthStrings _strings = AuthStrings(
  login: LoginStrings(
    heading: 'Quản lý bán hàng đa kênh',
    aProductOf: 'Một sản phẩm của',
    pancakeIdButton: 'Đăng nhập với Pancake ID',
    facebookButton: 'Đăng nhập với Facebook',
    googleButton: 'Đăng nhập với Google',
    appleButton: 'Đăng nhập với Apple',
    linkPrefix: 'Nếu bạn đang bị lỗi đăng nhập, vui lòng ',
    linkAction: 'Ấn vào đây',
  ),
  pancakeIdLogin: PancakeIdLoginStrings(
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
  ),
  otp: OtpStrings(
    title: 'Xác thực mã OTP',
    subtitleTemplate: 'Mã xác thực đã được gửi tới {destination}',
    cantReceive: 'Không nhận được mã?',
    resendAction: 'Bấm để gửi lại',
    continueButton: 'Tiếp tục',
  ),
  register: RegisterStrings(
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
  ),
  forgotPassword: ForgotPasswordStrings(
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
  ),
  resetPassword: ResetPasswordStrings(
    title: 'Đặt lại mật khẩu',
    passwordLabel: 'Mật khẩu',
    passwordHint: 'Nhập mật khẩu mới',
    confirmPasswordLabel: 'Xác nhận mật khẩu',
    confirmPasswordHint: 'Nhập lại mật khẩu mới',
    submitButton: 'Tiếp tục',
    passwordEmptyError: 'Mật khẩu không được để trống',
    passwordMismatchError: 'Mật khẩu xác nhận không đúng',
  ),
);

const AuthAssets _assets = AuthAssets.bundled;

// ---------------------------------------------------------------------------
// LoginView
// ---------------------------------------------------------------------------

Widget loginViewAllStory(BuildContext context) {
  return LoginView(
    strings: _strings.login,
    assets: _assets,
    onPancakeIdPressed: () {},
    onFacebookPressed: () {},
    onGooglePressed: () {},
    onApplePressed: () {},
    onPancakeIdLinkPressed: () {},
  );
}

Widget loginViewNoAppleStory(BuildContext context) {
  return LoginView(
    strings: _strings.login,
    assets: _assets,
    onPancakeIdPressed: () {},
    onFacebookPressed: () {},
    onGooglePressed: () {},
    showAppleButton: false,
  );
}

Widget loginViewLoadingPancakeStory(BuildContext context) {
  return LoginView(
    strings: _strings.login,
    assets: _assets,
    onPancakeIdPressed: () {},
    loadingPancakeId: true,
    onFacebookPressed: () {},
    onGooglePressed: () {},
  );
}

Widget loginViewCustomLogoStory(BuildContext context) {
  return LoginView(
    strings: _strings.login,
    assets: _assets,
    onPancakeIdPressed: () {},
    onFacebookPressed: () {},
    onGooglePressed: () {},
    logo: const FlutterLogo(size: 48),
  );
}

Widget loginViewImageBgStory(BuildContext context) {
  return LoginView(
    strings: _strings.login,
    assets: _assets,
    onPancakeIdPressed: () {},
    onFacebookPressed: () {},
    onGooglePressed: () {},
    background: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFE0F0), Color(0xFFE0F7FF)],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// PancakeIdLoginView
// ---------------------------------------------------------------------------

PancakeIdLoginView _buildPancakeId({
  String? identity,
  String? password,
  String? identityError,
  String? passwordError,
  bool submitting = false,
}) {
  return PancakeIdLoginView(
    strings: _strings.pancakeIdLogin,
    assets: _assets,
    identityController: TextEditingController(text: identity ?? ''),
    passwordController: TextEditingController(text: password ?? ''),
    identityError: identityError,
    passwordError: passwordError,
    canSubmit: (identity?.isNotEmpty ?? false) && (password?.isNotEmpty ?? false),
    submitLoading: submitting,
    onSubmit: () {},
    onClose: () {},
    onForgotPassword: () {},
    onSignUp: () {},
    onFacebookPressed: () {},
    onGooglePressed: () {},
    onApplePressed: () {},
    onObscureToggle: () {},
  );
}

Widget pancakeIdEmptyStory(BuildContext context) => _buildPancakeId();
Widget pancakeIdFilledStory(BuildContext context) =>
    _buildPancakeId(identity: 'demo@pancake.vn', password: 'super-secret-123');
Widget pancakeIdErrorStory(BuildContext context) => _buildPancakeId(
      identity: 'demo',
      password: 'a',
      identityError: 'Tài khoản không hợp lệ',
      passwordError: 'Sai mật khẩu',
    );
Widget pancakeIdSubmittingStory(BuildContext context) =>
    _buildPancakeId(identity: 'demo@pancake.vn', password: 'secret123', submitting: true);

// ---------------------------------------------------------------------------
// OtpView
// ---------------------------------------------------------------------------

Widget otpCountingStory(BuildContext context) {
  return OtpView(
    strings: _strings.otp,
    destination: '+84 *** *** 123',
    code: '',
    remaining: const Duration(minutes: 4, seconds: 30),
    onChanged: (_) {},
    onCompleted: (_) {},
    onSubmit: () {},
    onResend: () {},
    onClose: () {},
  );
}

Widget otpResendReadyStory(BuildContext context) {
  return OtpView(
    strings: _strings.otp,
    destination: '+84 *** *** 123',
    code: '1234',
    onChanged: (_) {},
    onCompleted: (_) {},
    onSubmit: () {},
    onResend: () {},
    onClose: () {},
  );
}

// ---------------------------------------------------------------------------
// RegisterView
// ---------------------------------------------------------------------------

RegisterView _buildRegister({
  AuthIdentityType type = AuthIdentityType.phone,
  String? firstNameError,
  String? phoneError,
  String? emailError,
}) {
  return RegisterView(
    strings: _strings.register,
    firstNameController: TextEditingController(),
    lastNameController: TextEditingController(),
    phoneController: TextEditingController(),
    emailController: TextEditingController(),
    passwordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),
    identityType: type,
    onIdentityTypeChanged: (_) {},
    phonePrefix: '+84',
    onPhonePrefixTap: () {},
    firstNameError: firstNameError,
    phoneError: phoneError,
    emailError: emailError,
    onObscurePasswordToggle: () {},
    onObscureConfirmToggle: () {},
    onSubmit: () {},
    onClose: () {},
  );
}

Widget registerPhoneStory(BuildContext context) => _buildRegister();
Widget registerEmailStory(BuildContext context) => _buildRegister(type: AuthIdentityType.email);
Widget registerErrorsStory(BuildContext context) => _buildRegister(
      firstNameError: 'Vui lòng nhập thông tin',
      phoneError: 'Số điện thoại không hợp lệ',
    );

// ---------------------------------------------------------------------------
// ForgotPasswordView
// ---------------------------------------------------------------------------

Widget forgotPhoneStory(BuildContext context) {
  return ForgotPasswordView(
    strings: _strings.forgotPassword,
    phoneController: TextEditingController(),
    emailController: TextEditingController(),
    identityType: AuthIdentityType.phone,
    onIdentityTypeChanged: (_) {},
    phonePrefix: '+84',
    onPhonePrefixTap: () {},
    onSubmit: () {},
    onClose: () {},
  );
}

Widget forgotEmailStory(BuildContext context) {
  return ForgotPasswordView(
    strings: _strings.forgotPassword,
    phoneController: TextEditingController(),
    emailController: TextEditingController(),
    identityType: AuthIdentityType.email,
    onIdentityTypeChanged: (_) {},
    phonePrefix: '+84',
    onPhonePrefixTap: () {},
    onSubmit: () {},
    onClose: () {},
  );
}

// ---------------------------------------------------------------------------
// ResetPasswordView
// ---------------------------------------------------------------------------

Widget resetDefaultStory(BuildContext context) {
  return ResetPasswordView(
    strings: _strings.resetPassword,
    passwordController: TextEditingController(),
    confirmPasswordController: TextEditingController(),
    onObscurePasswordToggle: () {},
    onObscureConfirmToggle: () {},
    onSubmit: () {},
    onClose: () {},
  );
}

Widget resetErrorStory(BuildContext context) {
  return ResetPasswordView(
    strings: _strings.resetPassword,
    passwordController: TextEditingController(text: 'abc'),
    confirmPasswordController: TextEditingController(text: 'xyz'),
    passwordError: 'Mật khẩu xác nhận không đúng',
    onObscurePasswordToggle: () {},
    onObscureConfirmToggle: () {},
    onSubmit: () {},
    onClose: () {},
  );
}
