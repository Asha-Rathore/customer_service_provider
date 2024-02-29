import 'package:customer_service_provider_hybrid/auth/model/user_model.dart';
import 'package:customer_service_provider_hybrid/auth/widgets/custom_auth_template.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:customer_service_provider_hybrid/utils/field_validator.dart';

import '../../utils/asset_paths.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_sizebox.dart';
import '../../widgets/custom_textfield.dart';
import '../bloc/reset_password_bloc.dart';

class ResetPasswordScreen extends StatelessWidget {
  final int? userId;
  ResetPasswordScreen({Key? key, this.userId}) : super(key: key);

  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _resetPasswordFormKey = GlobalKey<FormState>();
  final _resetPasswordBloc = ResetPasswordBloc();

  @override
  Widget build(BuildContext context) {
    return CustomAuthTemplate(
      title: AppStrings.CREATE_NEW_PASSWORD,
      child: _formWidget(context),
    );
  }

  Widget _formWidget(context) {
    return Form(
      key: _resetPasswordFormKey,
      child: Column(
        children: [
          _passwordTextField(),
          CustomSizeBox(),
          _confirmPasswordTextField(),
          CustomSizeBox(),
          _resetPasswordButton(context),
        ],
      ),
    );
  }

  Widget _passwordTextField() {
    return CustomTextField(
      hint: AppStrings.PASSWORD,
      prefxicon: AssetPath.LOCK_ICON,
      controller: _passwordCtrl,
      validator: (value) => value?.validateNewPassword,
      scale: 2.5.sp,
      isSuffixIcon: true,
      isPasswordField: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.PASSWORD_MAX_LENGTH)
      ],
    );
  }

  Widget _confirmPasswordTextField() {
    return CustomTextField(
      hint: AppStrings.CONFIRM_PASSWORD,
      prefxicon: AssetPath.LOCK_ICON,
      controller: _confirmPasswordCtrl,
      validator: (value) =>
          value?.validateNewConfirmPassword(_passwordCtrl.text, value),
      scale: 2.5.sp,
      isSuffixIcon: true,
      isPasswordField: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.PASSWORD_MAX_LENGTH)
      ],
    );
  }

  Widget _resetPasswordButton(context) {
    return CustomButton(
      onTap: () => _changePasswordValidationMethod(context),
      text: AppStrings.RESET_PASSWORD,
    );
  }

  void _changePasswordValidationMethod(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_resetPasswordFormKey.currentState!.validate()) {
      _resetChangePasswordMethod(context);
      // AppNavigation.navigatorPop(context);
      // AppDialogs().showSuccessDialog(
      //     context: context,
      //     successMsg: AppStrings.YOUR_PASSWORD_HAS_BEEN_CHANGED,
      //     onTap: () {
      //       // AppNavigation.navigatorPop(context);
      //       // AppNavigation.navigatorPop(context);
      //       // AppNavigation.navigatorPop(context);
      //       // AppNavigation.navigateReplacementNamed(
      //       //     context, AppRouteName.LOGIN_SCREEN_ROUTE);
      //     });
    }
  }

  void _resetChangePasswordMethod(BuildContext context) {
    _resetPasswordBloc.resetPasswordBlocMethod(
        context: context,
        userId: userId,
        userNewPassword: _passwordCtrl.text,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        });
  }
}
