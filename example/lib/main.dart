import 'package:auth_ui/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'stories/atom_stories.dart';
import 'stories/view_stories.dart';

/// Entry point for the auth_ui Widgetbook app.
///
/// Launch with `cd example && flutter run`. The app catalogs every public
/// widget and view in the package and lets you toggle theme, locale, and
/// device frames for each story.
void main() {
  runApp(const AuthUiWidgetbook());
}

/// Root Widgetbook app for `auth_ui`.
///
/// Edit [_buildStories] to add new stories — each story is a small
/// callable that returns a fully-controlled instance of the widget /
/// view under test with mock callbacks.
class AuthUiWidgetbook extends StatelessWidget {
  /// Creates the Widgetbook app.
  const AuthUiWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: _buildStories(),
      addons: <WidgetbookAddon<dynamic>>[
        ThemeAddon<ThemeData>(
          themes: <WidgetbookTheme<ThemeData>>[
            WidgetbookTheme(
              name: 'Pancake Light',
              data: ThemeData(
                useMaterial3: true,
                extensions: const <ThemeExtension<dynamic>>[AuthTheme.pancakeLight],
              ),
            ),
            WidgetbookTheme(
              name: 'Custom Magenta',
              data: ThemeData(
                useMaterial3: true,
                extensions: <ThemeExtension<dynamic>>[
                  AuthTheme.pancakeLight.copyWith(
                    colors: AuthTheme.pancakeLight.colors.copyWith(
                      accent: const Color(0xFFE91E63),
                      backgroundGradientStart: const Color(0xFFFCE4EC),
                      backgroundGradientEnd: const Color(0x33FCE4EC),
                      link: const Color(0xFFAD1457),
                    ),
                  ),
                ],
              ),
            ),
          ],
          themeBuilder: (context, theme, child) =>
              Theme(data: theme, child: child),
        ),
        DeviceFrameAddon(
          devices: <Device>[
            Devices.ios.iPhone13,
            Devices.ios.iPhoneSE,
            Devices.ios.iPadPro11Inches,
            Devices.android.samsungGalaxyS20,
          ],
        ),
        TextScaleAddon(min: 1.0, max: 1.5),
      ],
    );
  }

  List<WidgetbookNode> _buildStories() {
    return <WidgetbookNode>[
      WidgetbookCategory(
        name: 'Tokens',
        children: <WidgetbookNode>[
          WidgetbookComponent(
            name: 'AuthColors',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Pancake palette', builder: paletteSwatchStory),
            ],
          ),
          WidgetbookComponent(
            name: 'AuthTypography',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Pancake scale', builder: typographyStory),
            ],
          ),
        ],
      ),
      WidgetbookCategory(
        name: 'Atoms',
        children: <WidgetbookNode>[
          WidgetbookComponent(
            name: 'AuthPrimaryButton',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Default', builder: primaryButtonDefaultStory),
              WidgetbookUseCase(name: 'Disabled', builder: primaryButtonDisabledStory),
              WidgetbookUseCase(name: 'Loading', builder: primaryButtonLoadingStory),
            ],
          ),
          WidgetbookComponent(
            name: 'AuthTextField',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Default', builder: textFieldDefaultStory),
              WidgetbookUseCase(name: 'With error', builder: textFieldErrorStory),
              WidgetbookUseCase(name: 'Password with eye', builder: textFieldPasswordStory),
            ],
          ),
          WidgetbookComponent(
            name: 'AuthSocialButton',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Facebook', builder: socialButtonFacebookStory),
              WidgetbookUseCase(name: 'Google', builder: socialButtonGoogleStory),
              WidgetbookUseCase(name: 'Apple', builder: socialButtonAppleStory),
              WidgetbookUseCase(name: 'Icon row', builder: socialIconRowStory),
            ],
          ),
          WidgetbookComponent(
            name: 'AuthAppBar',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'With close', builder: appBarCloseStory),
              WidgetbookUseCase(name: 'With title', builder: appBarTitleStory),
            ],
          ),
          WidgetbookComponent(
            name: 'PancakeIdButton',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Default', builder: pancakeIdButtonStory),
              WidgetbookUseCase(name: 'Loading', builder: pancakeIdButtonLoadingStory),
            ],
          ),
        ],
      ),
      WidgetbookCategory(
        name: 'Views',
        children: <WidgetbookNode>[
          WidgetbookComponent(
            name: 'LoginView',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'All providers', builder: loginViewAllStory),
              WidgetbookUseCase(name: 'No Apple', builder: loginViewNoAppleStory),
              WidgetbookUseCase(
                name: 'Loading Pancake ID',
                builder: loginViewLoadingPancakeStory,
              ),
              WidgetbookUseCase(name: 'Custom logo', builder: loginViewCustomLogoStory),
              WidgetbookUseCase(name: 'Image background', builder: loginViewImageBgStory),
            ],
          ),
          WidgetbookComponent(
            name: 'PancakeIdLoginView',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Empty', builder: pancakeIdEmptyStory),
              WidgetbookUseCase(name: 'Filled', builder: pancakeIdFilledStory),
              WidgetbookUseCase(name: 'With errors', builder: pancakeIdErrorStory),
              WidgetbookUseCase(name: 'Submitting', builder: pancakeIdSubmittingStory),
            ],
          ),
          WidgetbookComponent(
            name: 'OtpView',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Counting down', builder: otpCountingStory),
              WidgetbookUseCase(name: 'Resend ready', builder: otpResendReadyStory),
            ],
          ),
          WidgetbookComponent(
            name: 'RegisterView',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Phone', builder: registerPhoneStory),
              WidgetbookUseCase(name: 'Email', builder: registerEmailStory),
              WidgetbookUseCase(name: 'Errors', builder: registerErrorsStory),
            ],
          ),
          WidgetbookComponent(
            name: 'ForgotPasswordView',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Phone', builder: forgotPhoneStory),
              WidgetbookUseCase(name: 'Email', builder: forgotEmailStory),
            ],
          ),
          WidgetbookComponent(
            name: 'ResetPasswordView',
            useCases: <WidgetbookUseCase>[
              WidgetbookUseCase(name: 'Default', builder: resetDefaultStory),
              WidgetbookUseCase(name: 'Error', builder: resetErrorStory),
            ],
          ),
        ],
      ),
    ];
  }
}
