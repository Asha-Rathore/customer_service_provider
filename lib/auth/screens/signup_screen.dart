import 'package:customer_service_provider_hybrid/auth/arguments/otp_arguments.dart';
import 'package:customer_service_provider_hybrid/auth/enums/auth_roles.dart';
import 'package:customer_service_provider_hybrid/auth/providers/auth_role_provider.dart';
import 'package:customer_service_provider_hybrid/auth/widgets/custom_auth_template.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:customer_service_provider_hybrid/utils/field_validator.dart';
import 'package:provider/provider.dart';

import '../../utils/app_dialogs.dart';
import '../../utils/constants.dart';
import '../bloc/sign_up_bloc.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _signupFormKey = GlobalKey<FormState>();
  AuthRoleProvider? _authRoleProvider;
  SignUpBloc _signUpBloc = SignUpBloc();

  @override
  Widget build(BuildContext context) {
    _authRoleProvider = Provider.of<AuthRoleProvider>(context, listen: false);
    return CustomAuthTemplate(
      title: AppStrings.SIGN_UP,
      child: _formWidget(context),
      flex: 10,
      isBottomText: true,
      firstBottomText: AppStrings.ALREADY_HAVE_AN_ACCOUNT,
      secBottomText: AppStrings.LOGIN_NOW,
      onTap: () {
        AppNavigation.navigatorPop(context);
      },
    );
  }

  Widget _formWidget(context) {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: [
          _fullNameTextField(),
          CustomSizeBox(),
          _emailTextField(),
          CustomSizeBox(),
          _passwordTextField(),
          CustomSizeBox(),
          _confirmPasswordTextField(),
          CustomSizeBox(),
          _signupButton(context),
        ],
      ),
    );
  }

  Widget _fullNameTextField() {
    return CustomTextField(
      hint: AppStrings.FULL_NAME,
      prefxicon: AssetPath.PERSON_ICON,
      controller: _fullNameCtrl,
      validator: (value) => value?.validateEmpty(AppStrings.FULL_NAME),
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.NAME_MAX_LENGTH)
      ],
    );
  }

  Widget _emailTextField() {
    return CustomTextField(
      hint: AppStrings.EMAIL_ADDRESS,
      prefxicon: AssetPath.EMAIL_ICON,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => value?.validateEmail,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.EMAIL_MAX_LENGTH)
      ],
      controller: _emailCtrl,
    );
  }

  Widget _passwordTextField() {
    return CustomTextField(
      hint: AppStrings.PASSWORD,
      prefxicon: AssetPath.LOCK_ICON,
      controller: _passwordCtrl,
      validator: (value) => value?.validatePassword(),
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
          value?.validateConfirmPassword(_passwordCtrl.text, value),
      scale: 2.5.sp,
      isSuffixIcon: true,
      isPasswordField: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.PASSWORD_MAX_LENGTH)
      ],
    );
  }

  Widget _signupButton(context) {
    return CustomButton(
      onTap: () => _signupValidationMethod(context),
      text: AppStrings.SIGN_UP,
    );
  }

  void _setCredentials(context) {
    FocusScope.of(context).unfocus();
    _fullNameCtrl.text = "test";
    _emailCtrl.text = "demouser@getnada.com";
    _passwordCtrl.text = "Abcd@1234";
    _confirmPasswordCtrl.text = "Abcd@1234";
  }

  void _signupValidationMethod(BuildContext context) {
    // _setCredentials(context);
    FocusManager.instance.primaryFocus?.unfocus();
    if (_signupFormKey.currentState!.validate()) {
      _signUpApiMethod(context);
      _emailCtrl.text = "";
      _fullNameCtrl.text = "";
      _passwordCtrl.text = "";
      _confirmPasswordCtrl.text = "";
    }
    // AppNavigation.navigateTo(
    //     context, AppRouteName.OTP_VERIFICATION_SCREEN_ROUTE,
    // arguments: OtpVerficationArguments(isProfile: true,emailAddress: _emailCtrl.text,fullName: _fullNameCtrl.text));
  }

  // ------------ SignUp Api Call Method ------------------- //
  void _signUpApiMethod(BuildContext context) {
    print(_emailCtrl.text);

    _signUpBloc.signUpBlocMethod(
        context: context,
        fullName: _fullNameCtrl.text,
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
        confirmPassword: _confirmPasswordCtrl.text,
        role: _authRoleProvider?.role,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        });

    print("ROLE : ${_authRoleProvider?.role}");
  }
}
