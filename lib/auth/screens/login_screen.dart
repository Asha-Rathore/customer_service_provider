import 'package:customer_service_provider_hybrid/auth/widgets/custom_auth_template.dart';
import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:customer_service_provider_hybrid/utils/field_validator.dart';
import 'package:provider/provider.dart';

import '../../utils/app_fonts.dart';
import '../../utils/constants.dart';
import '../bloc/login_bloc.dart';
import '../enums/auth_roles.dart';
import '../providers/auth_role_provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  LoginBloc _loginBloc = LoginBloc();

  AuthRoleProvider? _authRoleProvider;

  @override
  void initState() {
    super.initState();
    _authRoleProvider = context.read<AuthRoleProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _authRoleProvider = context.watch<AuthRoleProvider>();
    return CustomAuthTemplate(
      onTapLogo: () => _setCredentials(context),
      title: AppStrings.LOGIN,
      flex: 9,
      child: _formWidget(context),
      isBottomText: true,
      firstBottomText: AppStrings.DONT_HAVE_AN_ACCOUNT,
      secBottomText: AppStrings.SIGNUP_NOW,
      onTap: () {
        FocusScope.of(context).unfocus();
        _emailCtrl.clear();
        _passwordCtrl.clear();
        AppNavigation.navigateTo(context, AppRouteName.SIGNUP_SCREEN_ROUTE);
      },
    );
  }

  Widget _formWidget(context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          _emailTextField(),
          CustomSizeBox(),
          _passwordTextField(),
          CustomSizeBox(),
          _forgotPasswordText(context),
          CustomSizeBox(height: 20.h),
          _loginButton(context),
        ],
      ),
    );
  }

  Widget _emailTextField() {
    return CustomTextField(
      hint: AppStrings.EMAIL_ADDRESS,
      prefxicon: AssetPath.EMAIL_ICON,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => value?.validateEmail,
      controller: _emailCtrl,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.EMAIL_MAX_LENGTH)
      ],
    );
  }

  Widget _passwordTextField() {
    return CustomTextField(
      hint: AppStrings.PASSWORD,
      prefxicon: AssetPath.LOCK_ICON,
      controller: _passwordCtrl,
      validator: (value) => value?.validatePassword(isPatternCheck: false),
      isSuffixIcon: true,
      obscureText: true,
      scale: 2.5.sp,
      isPasswordField: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.PASSWORD_MAX_LENGTH)
      ],
    );
  }

  Widget _forgotPasswordText(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          AppNavigation.navigateTo(
              context, AppRouteName.FORGET_PASSWORD_SCREEN_ROUTE);
        },
        child: const CustomText(
          text: AppStrings.FORGOT_PASSWORD_BUTTON,
          underlined: true,
          fontColor: AppColors.THEME_COLOR_PURPLE,
          // fontweight: FontWeight.w800,
          textAlign: TextAlign.right,
          fontFamily: AppFonts.Jost_SemiBold,
        ),
      ),
    );
  }

  Widget _loginButton(context) {
    return CustomButton(
      onTap: () => _loginValidationMethod(context),
      text: AppStrings.LOG_IN,
    );
  }

  void _loginValidationMethod(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_loginFormKey.currentState!.validate()) {
      _loginApiMethod(context);
      // AppDialogs.showToast(message: AppStrings.LOGIN_SUCESSFULLY);
      // AppNavigation.navigateToRemovingAll(
      //   context,
      //   AppRouteName.MAIN_SCREEN_ROUTE,
      //   arguments: MainScreenRoutingArgument(
      //     index: _authRoleProvider?.role == AuthRole.user.name ? 1 : 0,
      //   ),
      // );
    }
  }

  /// ------------ Login Api Call Method -------------------
  void _loginApiMethod(BuildContext context) {
    _loginBloc.loginBlocMethod(
        context: context,
        userEmail: _emailCtrl.text,
        userPassword: _passwordCtrl.text,
        role: _authRoleProvider?.role,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        });
  }

  void _setCredentials(context) {
    FocusScope.of(context).unfocus();
    _emailCtrl.text = "demouser@getnada.com";
    _passwordCtrl.text = "Abcd@1234";
  }
}
