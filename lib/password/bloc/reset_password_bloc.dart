import 'package:customer_service_provider_hybrid/auth/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../services/network/network.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/app_strings.dart';
import '../../utils/network_strings.dart';

class ResetPasswordBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  UserResponseModel? _userResponseModel;

  void resetPasswordBlocMethod({
    required BuildContext context,
    String? userNewPassword,
    int? userId,
    String? referenceCode,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();

    _formData = FormData.fromMap({
      "user_id": userId,
      "password": userNewPassword,
    });

    print({
      "user_id": userId,
      //"reference_code": referenceCode,
      "password": userNewPassword,
    });
    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.RESET_PASSWORD_ENDPOINT, context: context);

    _onSuccess = () {
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
      isHeaderRequire: false,
    );
  }

  /// Validate Response
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _changePasswordResponseMethod({required BuildContext context}) {
    try {
      AppDialogs().showSuccessDialog(
          context: context,
          successMsg: AppStrings.YOUR_PASSWORD_HAS_BEEN_CHANGED,
          onTap: () {
            AppNavigation.navigatorPop(context);
            AppNavigation.navigatorPop(context);
            AppNavigation.navigatorPop(context);
            AppNavigation.navigateReplacementNamed(
                context, AppRouteName.LOGIN_SCREEN_ROUTE);
          });
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}
