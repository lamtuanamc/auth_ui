// ignore_for_file: public_member_api_docs — internal stories.

import 'package:auth_ui/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const AuthAssets _assets = AuthAssets.bundled;

Widget _scaffold(BuildContext context, Widget child) {
  return Scaffold(
    backgroundColor: AuthTheme.of(context).colors.backgroundGradientEnd,
    body: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: child)),
  );
}

// ---------------------------------------------------------------------------
// Tokens
// ---------------------------------------------------------------------------

Widget paletteSwatchStory(BuildContext context) {
  final colors = AuthTheme.of(context).colors;
  final entries = <(String, Color)>[
    ('accent', colors.accent),
    ('link', colors.link),
    ('textStrong', colors.textStrong),
    ('textSecondary', colors.textSecondary),
    ('textTertiary', colors.textTertiary),
    ('error', colors.error),
    ('stroke', colors.stroke),
    ('divider', colors.divider),
    ('facebookBackground', colors.facebookBackground),
    ('appleBackground', colors.appleBackground),
    ('socialButtonBackground', colors.socialButtonBackground),
    ('backgroundGradientStart', colors.backgroundGradientStart),
    ('backgroundGradientEnd', colors.backgroundGradientEnd),
  ];
  return _scaffold(
    context,
    GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        for (final (name, color) in entries)
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.stroke),
            ),
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Colors.white.withValues(alpha: 0.85),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(name, style: const TextStyle(fontSize: 12)),
              ),
            ),
          ),
      ],
    ),
  );
}

Widget typographyStory(BuildContext context) {
  final typo = AuthTheme.of(context).typography;
  final colors = AuthTheme.of(context).colors;
  final samples = <(String, TextStyle)>[
    ('heading', typo.heading),
    ('title', typo.title),
    ('subtitle', typo.subtitle),
    ('label', typo.label),
    ('bodyMedium', typo.bodyMedium),
    ('bodySmall', typo.bodySmall),
    ('button', typo.button),
    ('primaryButton', typo.primaryButton),
    ('linkPrimary', typo.linkPrimary),
    ('linkSecondary', typo.linkSecondary),
    ('dividerLabel', typo.dividerLabel),
    ('errorText', typo.errorText),
  ];
  return _scaffold(
    context,
    ListView.separated(
      itemCount: samples.length,
      separatorBuilder: (_, __) => Divider(color: colors.divider),
      itemBuilder: (_, i) {
        final (name, style) = samples[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(color: colors.textTertiary, fontSize: 10)),
            const SizedBox(height: 4),
            Text('Quản lý bán hàng đa kênh', style: style.copyWith(color: colors.textStrong)),
          ],
        );
      },
    ),
  );
}

// ---------------------------------------------------------------------------
// AuthPrimaryButton
// ---------------------------------------------------------------------------

Widget primaryButtonDefaultStory(BuildContext context) {
  return _scaffold(
    context,
    Center(child: AuthPrimaryButton(label: 'Đăng nhập', onPressed: () {})),
  );
}

Widget primaryButtonDisabledStory(BuildContext context) {
  return _scaffold(
    context,
    const Center(
      child: AuthPrimaryButton(label: 'Đăng nhập', onPressed: null, enabled: false),
    ),
  );
}

Widget primaryButtonLoadingStory(BuildContext context) {
  return _scaffold(
    context,
    const Center(child: AuthPrimaryButton(label: 'Đăng nhập', loading: true)),
  );
}

// ---------------------------------------------------------------------------
// AuthTextField
// ---------------------------------------------------------------------------

Widget textFieldDefaultStory(BuildContext context) {
  return _scaffold(
    context,
    AuthTextField(label: 'Tài khoản', controller: TextEditingController(text: 'demo@pancake.vn')),
  );
}

Widget textFieldErrorStory(BuildContext context) {
  return _scaffold(
    context,
    AuthTextField(
      label: 'Tài khoản',
      controller: TextEditingController(),
      errorText: 'Tài khoản không được để trống',
    ),
  );
}

Widget textFieldPasswordStory(BuildContext context) {
  return _scaffold(
    context,
    AuthTextField(
      label: 'Mật khẩu',
      controller: TextEditingController(text: 'super-secret-123'),
      obscureText: true,
      onObscureToggle: () {},
    ),
  );
}

// ---------------------------------------------------------------------------
// AuthSocialButton
// ---------------------------------------------------------------------------

Widget _fbIcon() => SvgPicture.asset(
      _assets.facebookBrandIcon,
      package: _assets.packageName,
      height: 20,
      fit: BoxFit.cover,
    );

Widget _googleIcon() => SvgPicture.asset(
      _assets.googleIcon,
      package: _assets.packageName,
      height: 20,
      fit: BoxFit.cover,
    );

Widget socialButtonFacebookStory(BuildContext context) {
  return _scaffold(
    context,
    Center(
      child: AuthSocialButton(
        style: AuthSocialButtonStyle.facebook,
        label: 'Đăng nhập với Facebook',
        icon: _fbIcon(),
        onPressed: () {},
      ),
    ),
  );
}

Widget socialButtonGoogleStory(BuildContext context) {
  return _scaffold(
    context,
    Center(
      child: AuthSocialButton(
        style: AuthSocialButtonStyle.google,
        label: 'Đăng nhập với Google',
        icon: _googleIcon(),
        onPressed: () {},
      ),
    ),
  );
}

Widget socialButtonAppleStory(BuildContext context) {
  return _scaffold(
    context,
    Center(
      child: AuthSocialButton(
        style: AuthSocialButtonStyle.apple,
        label: 'Đăng nhập với Apple',
        icon: const Icon(Icons.apple, size: 20),
        onPressed: () {},
      ),
    ),
  );
}

Widget socialIconRowStory(BuildContext context) {
  return _scaffold(
    context,
    Row(
      children: [
        Expanded(child: AuthSocialIconButton(onPressed: () {}, icon: _fbIcon())),
        const SizedBox(width: 16),
        Expanded(child: AuthSocialIconButton(onPressed: () {}, icon: _googleIcon())),
        const SizedBox(width: 16),
        Expanded(
          child: AuthSocialIconButton(
            onPressed: () {},
            icon: const Icon(Icons.apple, size: 20),
          ),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// AuthAppBar
// ---------------------------------------------------------------------------

Widget appBarCloseStory(BuildContext context) {
  return Scaffold(appBar: AuthAppBar(onClose: () {}), body: const Center(child: Text('Body')));
}

Widget appBarTitleStory(BuildContext context) {
  return Scaffold(
    appBar: AuthAppBar(title: 'Đăng ký tài khoản', onClose: () {}),
    body: const Center(child: Text('Body')),
  );
}

// ---------------------------------------------------------------------------
// PancakeIdButton
// ---------------------------------------------------------------------------

Widget _pancakeIcon() => SvgPicture.asset(
      _assets.pancakeLogoColor,
      package: _assets.packageName,
      height: 24,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );

Widget _pancakeBackground() => SvgPicture.asset(
      _assets.pancakeIdButtonBackground,
      package: _assets.packageName,
      fit: BoxFit.fill,
    );

Widget pancakeIdButtonStory(BuildContext context) {
  return _scaffold(
    context,
    Center(
      child: PancakeIdButton(
        label: 'Đăng nhập với Pancake ID',
        icon: _pancakeIcon(),
        background: _pancakeBackground(),
        onPressed: () {},
      ),
    ),
  );
}

Widget pancakeIdButtonLoadingStory(BuildContext context) {
  return _scaffold(
    context,
    Center(
      child: PancakeIdButton(
        label: 'Đăng nhập với Pancake ID',
        icon: _pancakeIcon(),
        background: _pancakeBackground(),
        loading: true,
      ),
    ),
  );
}
