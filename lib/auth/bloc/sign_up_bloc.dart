import 'dart:io';

import 'package:customer_service_provider_hybrid/auth/arguments/otp_arguments.dart';
import 'package:customer_service_provider_hybrid/auth/enums/otp_verification_type.dart';
import 'package:customer_service_provider_hybrid/services/firebase_messaging_service.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../services/network/network.dart';
import '../../utils/app_route_name.dart';
import '../model/user_model.dart';

class SignUpBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _signUpResponse;
  String? deviceToken;

  void signUpBlocMethod({
    required BuildContext context,
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
    String? role,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();
    deviceToken = await FirebaseMessagingService().getToken();
    print("Sign up device token:${deviceToken}");
    //FORM DATA
    _formData = FormData.fromMap({
      "full_name": fullName,
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
      "role": role,
      "device_token": deviceToken ?? '123',
      "device_type": Platform.isAndroid ? 'android' : 'ios',
    });

    _onFailure = () {
      Logger().e("On error");
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.SIGNUP_ENDPOINT, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _signUpResponseMethod(
          context: context, userEmail: email, fullName: fullName);
    };
    _validateResponse();
  }

  //----------------------------------- Post Request -----------------------------------
  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().postRequest(
        endPoint: endPoint,
        formData: _formData,
        context: context,
        onFailure: _onFailure,
        isHeaderRequire: false);
  }

  //----------------------------------- Validate Response -----------------------------------
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _signUpResponseMethod(
      {required BuildContext context, String? userEmail, String? fullName}) {
    //  try {
    Logger().i("Signup response method");
    _signUpResponse = _response?.data;

    AppNavigation.navigatorPop(context);
    AppNavigation.navigatorPop(context);
    AppNavigation.navigateTo(
        context, AppRouteName.OTP_VERIFICATION_SCREEN_ROUTE,
        arguments: OtpVerficationArguments(
          otpVerificationType: OTPVerificationType.verification,
          userId: _signUpResponse['data']['user_id'],
          isProfile: true,
          emailAddress: userEmail,
          fullName: fullName,
        ));
   
    //   }
    // catch (error) {
    //   AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    // }
  }
}
