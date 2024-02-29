import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../services/network/network.dart';
import '../../utils/app_navigation.dart';
import '../../utils/network_strings.dart';
import '../enums/otp_verification_type.dart';

class ResendCodeBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;

  void resendCodeBlocMethod({
    required BuildContext context,
    required OTPVerificationType otpType,
    String? userEmail,
    int? userId,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();
    bool isSignup = otpType == OTPVerificationType.verification;
    String _endPoint = NetworkStrings.RESEND_OTP_CODE_ENDPOINT;
    // isSignup
    //     ? NetworkStrings.RESEND_OTP_CODE_ENDPOINT
    //     : NetworkStrings.FORGET_PASSWORD_RESEND_OTP_CODE_ENDPOINT;
    //Form Data
    _formData = FormData.fromMap({
      if (isSignup) "user_id": userId,
      if (!isSignup) "email": userEmail,
      "type": isSignup ? OTPVerificationType.verification.name : OTPVerificationType.forgot.name
    });
    print({
      if (isSignup) "user_id": userId,
      if (!isSignup) "email": userEmail,
      "type": isSignup ? OTPVerificationType.verification.name : OTPVerificationType.forgot.name
    });
    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(endPoint: _endPoint, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
    };

    _validateResponse();
  }

  /// Post Request
  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().postRequest(
        endPoint: endPoint,
        formData: _formData,
        context: context,
        onFailure: _onFailure,
        isHeaderRequire: false);
  }

  /// Validate Response
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }
}
