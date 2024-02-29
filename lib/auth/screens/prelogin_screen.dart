import 'dart:io';

import 'package:customer_service_provider_hybrid/auth/widgets/custom_auth_template.dart';
import 'package:customer_service_provider_hybrid/auth/widgets/custom_social_button.dart';
import 'package:customer_service_provider_hybrid/content/enums/user_agreement.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../content/routing_arguments/content_routing_argument.dart';
import '../../utils/app_fonts.dart';
import '../bloc/firebase_auth_bloc.dart';

class PreLoginScreen extends StatelessWidget {
  PreLoginScreen({Key? key}) : super(key: key);

  FirebaseAuthBloc _firebaseAuthBloc = FirebaseAuthBloc();

  @override
  Widget build(BuildContext context) {
    return CustomAuthTemplate(
      title: AppStrings.SOCIAL_LOGIN,
      child: Column(
        children: [
          _loginWithEmailButton(context),
          CustomSizeBox(),
          _loginWithGoogleButton(context),
          if (Platform.isIOS) ...[
            CustomSizeBox(),
            _loginWithAppleButton(context),
          ],
          CustomSizeBox(height: 20.h),
          _termsPolicyText(context),
        ],
      ),
    );
  }

  Widget _loginWithEmailButton(context) {
    return CustomSocialLoginButton(
      onTap: () {
        AppNavigation.navigateTo(context, AppRouteName.LOGIN_SCREEN_ROUTE);
      },
      title: AppStrings.LOGIN_WITH_EMAIL,
      iconPath: AssetPath.EMAIL_ICON,
      fontColor: AppColors.THEME_COLOR_WHITE,
      backgroundColor: AppColors.THEME_COLOR_PURPLE,
      iconScale: 3,
    );
  }

  Widget _loginWithGoogleButton(context) {
    return CustomSocialLoginButton(
      onTap: () {
        _firebaseAuthBloc.signInWithGoogle(mainContext: context);
      },
      title: AppStrings.LOGIN_WITH_GOOGLE,
      iconPath: AssetPath.GOOGLE_ICON,
      fontColor: AppColors.THEME_COLOR_WHITE,
      backgroundColor: AppColors.THEME_COLOR_GOOGLE_BUTTON,
      iconScale: 4,
    );
  }

  Widget _loginWithAppleButton(context) {
    return CustomSocialLoginButton(
      onTap: () {
        _firebaseAuthBloc.signInWithApple(context: context);
      },
      title: AppStrings.LOGIN_WITH_APPLE,
      iconPath: AssetPath.APPLE_ICON,
      fontColor: AppColors.THEME_COLOR_WHITE,
      backgroundColor: AppColors.THEME_COLOR_BLACK,
      iconScale: 3,
    );
  }

  Widget _termsPolicyText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.06.sw),
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            color: AppColors.THEME_COLOR_BLACK,
            fontSize: 15.sp,
            fontFamily: AppFonts.Jost_Regular,
          ),
          text: AppStrings.AGRREMT_TEXT,
          children: [
            _termsConditionSpanText(context),
            _andTextSpan(),
            _privacyPolicySpan(context)
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  TextSpan _termsConditionSpanText(context) {
    return TextSpan(
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          AppNavigation.navigateTo(
            context,
            AppRouteName.CONTENT_SCREEN_ROUTE,
            arguments: ContentRoutingArgument(
              title: AppStrings.TERMS_CONDITION,
              contentType: NetworkStrings.TERMS_AND_CONDITION,
            ),
          );
        },
      style: _textSpanStyle(),
      text: AppStrings.TERMS_CONDITION,
    );
  }

  TextSpan _andTextSpan() {
    return TextSpan(
      text: AppStrings.AND,
      style: TextStyle(
        fontSize: 15.sp,
        fontFamily: AppFonts.Jost_Regular,
      ),
    );
  }

  TextSpan _privacyPolicySpan(context) {
    return TextSpan(
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          AppNavigation.navigateTo(
            context,
            AppRouteName.CONTENT_SCREEN_ROUTE,
            arguments: ContentRoutingArgument(
              title: AppStrings.PRIVACY_POLICY,
              contentType: NetworkStrings.PRIVACY_POLICY,
            ),
          );
        },
      style: _textSpanStyle(),
      text: AppStrings.PRIVACY_POLICY,
    );
  }

  TextStyle _textSpanStyle() {
    return TextStyle(
      decoration: TextDecoration.underline,
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.THEME_COLOR_PURPLE,
      fontFamily: AppFonts.Jost_SemiBold,
    );
  }
}
