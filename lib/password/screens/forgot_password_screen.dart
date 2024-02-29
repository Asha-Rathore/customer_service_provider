import 'package:customer_service_provider_hybrid/auth/arguments/otp_arguments.dart';
import 'package:customer_service_provider_hybrid/auth/widgets/custom_auth_template.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:customer_service_provider_hybrid/utils/field_validator.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_role_provider.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/asset_paths.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_sizebox.dart';
import '../../widgets/custom_textfield.dart';
import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _forgotPasswordFormKey = GlobalKey<FormState>();
  final ForgetPasswordBloc _forgetPasswordBloc = ForgetPasswordBloc();
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
      title: AppStrings.FORGOT_PASSWORD,
      child: _formWidget(context),
    );
  }

  Widget _formWidget(context) {
    return Form(
      key: _forgotPasswordFormKey,
      child: Column(
        children: [
          _emailTextField(),
          CustomSizeBox(),
          _continueButton(context),
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

  Widget _continueButton(context) {
    return CustomButton(
      onTap: () => _forgotPasswordValidationMethod(context),
      text: AppStrings.CONTINUE,
    );
  }

  void _forgotPasswordValidationMethod(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_forgotPasswordFormKey.currentState!.validate()) {
      _forgetPasswordMethod(context: context);
      // AppNavigation.navigateTo(
      //   context,
      //   AppRouteName.OTP_VERIFICATION_SCREEN_ROUTE,
      //   arguments: false,
      // );

      // AppNavigation.navigateTo(
      //     context, AppRouteName.OTP_VERIFICATION_SCREEN_ROUTE,
      //     arguments: OtpVerficationArguments(
      //         isProfile: false,
      //         emailAddress: _emailCtrl.text,
      //         fullName: null));
    }
  }

  void _forgetPasswordMethod({required BuildContext context}) {
    _forgetPasswordBloc.forgetPasswordBlocMethod(
        context: context,
        userEmail: _emailCtrl.text,
        role: _authRoleProvider?.role,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        });
  }
}
