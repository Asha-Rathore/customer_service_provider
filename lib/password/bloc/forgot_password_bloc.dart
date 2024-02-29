import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../auth/arguments/otp_arguments.dart';
import '../../auth/enums/otp_verification_type.dart';
import '../../services/network/network.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/network_strings.dart';

class ForgetPasswordBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _forgetPasswordResponse;

  void forgetPasswordBlocMethod({
    required BuildContext context,
    String? userEmail,
    String? role,
    bool isNavigate = true,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();

    //Form Data
    _formData = FormData.fromMap({"email": userEmail});
    //Form Data
    _formData = FormData.fromMap({
      "email": userEmail,
      "role": role,
    });
    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(endPoint: NetworkStrings.FORGET_PASSWORD_ENDPOINT, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _forgetPasswordResponseMethod(context: context, userEmail: userEmail, isNavigate: isNavigate);
    };
    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _postRequest({required String endPoint, required BuildContext context}) async {
    //print("post request");
    _response = await Network().postRequest(
      endPoint: endPoint,
      formData: _formData,
      context: context,
      onFailure: _onFailure,
      isHeaderRequire: false,
    );
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _forgetPasswordResponseMethod({required BuildContext context, String? userEmail, bool isNavigate = true}) {
    //  try {
    _forgetPasswordResponse = _response?.data;
    print("response is " + _forgetPasswordResponse.toString());
   int userId = _forgetPasswordResponse["data"]["user_id"];
    if (_forgetPasswordResponse != null) {
      AppNavigation.navigateReplacementNamed(
        context, AppRouteName.OTP_VERIFICATION_SCREEN_ROUTE,
        arguments: OtpVerficationArguments(
          otpVerificationType: OTPVerificationType.forgot,
          userId: userId,
          isProfile: false,
          emailAddress: userEmail,
        ));
    }
  }
}
