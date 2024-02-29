import 'package:customer_service_provider_hybrid/password/bloc/change_password_bloc.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:flutter/material.dart';
import 'package:customer_service_provider_hybrid/utils/field_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../auth/enums/auth_roles.dart';
import '../../auth/providers/auth_role_provider.dart';
import '../../main_screen/routing_arguments/main_screen_routing_arguments.dart';
import '../../utils/app_navigation.dart';
import '../../widgets/custom_sizebox.dart';
import '../../widgets/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmNewPasswordCtrl = TextEditingController();
  final _changePasswordFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();

  AuthRoleProvider? _authRoleProvider;
  ChangePasswordBloc _changePasswordBloc = ChangePasswordBloc();

  @override
  void initState() {
    super.initState();
    _authRoleProvider = context.read<AuthRoleProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _authRoleProvider = context.watch<AuthRoleProvider>();
    return CustomAppTemplate(
      title: AppStrings.CHANGE_PASSWORD,
      isDivider: true,
      child: _formWidget(context),
    );
  }

  Widget _formWidget(context) {
    return CustomPadding(
      child: Form(
        key: _changePasswordFormKey,
        child: Column(
          children: [
            _oldPasswordTextField(),
            CustomSizeBox(),
            _newPasswordTextField(),
            CustomSizeBox(),
            _confirmNewPasswordTextField(),
            CustomSizeBox(),
            _button(context),
          ],
        ),
      ),
    );
  }

  Widget _oldPasswordTextField() {
    return CustomTextField(
      hint: AppStrings.OLD_PASSWORD,
      controller: _oldPasswordCtrl,
      validator: (value) => value?.validateOldPassword,
      isSuffixIcon: true,
      obscureText: true,
      scale: 2.5.sp,
      isPasswordField: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.PASSWORD_MAX_LENGTH)
      ],
    );
  }

  Widget _newPasswordTextField() {
    return CustomTextField(
      hint: AppStrings.NEW_PASSWORD,
      controller: _newPasswordCtrl,
      validator: (value) =>
          value?.validateChangeNewPassword(_oldPasswordCtrl.text, value),
      isSuffixIcon: true,
      obscureText: true,
      scale: 2.5.sp,
      isPasswordField: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.PASSWORD_MAX_LENGTH)
      ],
    );
  }

  Widget _confirmNewPasswordTextField() {
    return CustomTextField(
      hint: AppStrings.CONFIRM_NEW_PASSWORD,
      controller: _confirmNewPasswordCtrl,
      validator: (value) =>
          value?.validateNewConfirmPassword(_newPasswordCtrl.text, value),
      isSuffixIcon: true,
      obscureText: true,
      scale: 2.5.sp,
      isPasswordField: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(Constants.PASSWORD_MAX_LENGTH)
      ],
    );
  }

  Widget _button(context) {
    return CustomButton(
      onTap: () => _changePasswordValidationMethod(context),
      text: AppStrings.CHANGE_PASSWORD,
    );
  }

  void _changePasswordValidationMethod(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_changePasswordFormKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      _changePasswordBloc.changePasswordBlocMethod(
        context: context,
        oldPassword: _oldPasswordCtrl.text,
        newPassword: _newPasswordCtrl.text,
        confirmPassword: _confirmNewPasswordCtrl.text,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        },
      );
      // AppNavigation.navigatorPop(context);
    }
  }
}
