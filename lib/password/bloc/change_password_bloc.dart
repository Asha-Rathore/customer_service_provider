import 'dart:developer';

import 'package:customer_service_provider_hybrid/auth/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/enums/auth_roles.dart';
import '../../auth/providers/user_provider.dart';
import '../../main_screen/routing_arguments/main_screen_routing_arguments.dart';
import '../../services/network/network.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/app_strings.dart';
import '../../utils/network_strings.dart';

class ChangePasswordBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  User? _user;
  UserProvider? _userProvider;

  void changePasswordBlocMethod({
    required BuildContext context,
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();

    _formData = FormData.fromMap({
      "old_password": oldPassword,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    });

    print({
      "old_password": oldPassword,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    });
    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.CHANGE_PASSWORD_ENDPOINT, context: context);

    _onSuccess = () {
      print("SUCCESS:");
      AppNavigation.navigatorPop(context);
      _changePasswordResponseMethod(context: context);
    };

    _validateResponse();
  }

  /// Post Request
  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    //print("post request");
    _response = await Network().postRequest(
      endPoint: endPoint,
      formData: _formData,
      context: context,
      onFailure: _onFailure,
      isHeaderRequire: true,
    );
  }

  /// Validate Response
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _changePasswordResponseMethod({required BuildContext context}) async {
    try {
      _userProvider = context.read<UserProvider>();
      if (_userProvider?.getCurrentUser != null) {
        _user = _userProvider?.getCurrentUser;
      }

      AppDialogs().showSuccessDialog(
          context: context,
          successMsg: AppStrings.YOUR_PASSWORD_HAS_BEEN_CREATED,
          onTap: () {
            AppNavigation.navigateReplacementNamed(
              context,
              AppRouteName.MAIN_SCREEN_ROUTE,
              arguments: MainScreenRoutingArgument(
                index: _user?.role == AuthRole.user.name ? 1 : 0,
              ),
            );
          });
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}
