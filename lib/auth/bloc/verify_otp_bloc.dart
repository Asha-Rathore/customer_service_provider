import 'package:customer_service_provider_hybrid/password/routing_arguments/reset_password_routing_arguments.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main_screen/routing_arguments/main_screen_routing_arguments.dart';
import '../../profile/arguments/complete_profile_arguments.dart';
import '../../services/network/network.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/network_strings.dart';
import '../enums/auth_roles.dart';
import '../enums/otp_verification_type.dart';
import '../model/user_model.dart';
import '../providers/auth_role_provider.dart';

class VerifyOtpBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  UserResponseModel? _verificationCodeResponse;
  String? deviceToken;
  User? _userData;
  //UserProvider? _userProvider;

  void verifyOtpBlocMethod({
    required BuildContext context,
    int? userId,
    String? userEmail,
    String? fullName,
    String? otpCode,
    required OTPVerificationType verificationType,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();
    bool isSignup = verificationType == OTPVerificationType.verification;
    //Form Data
    String? endPoint = NetworkStrings.VERIFY_OTP_ENDPOINT;
    //     (isSignup) ? NetworkStrings.VERIFY_OTP_ENDPOINT : NetworkStrings.FORGET_PASSWORD_OTP_VERIFY_ENDPOINT;

    _formData = FormData.fromMap({
      if (isSignup) "user_id": userId,
      if (!isSignup) "email": userEmail,
      "otp": otpCode,
      "type": isSignup
          ? OTPVerificationType.verification.name
          : OTPVerificationType.forgot.name
    });

    print({
      if (isSignup) "user_id": userId,
      if (!isSignup) "email": userEmail,
      "otp": otpCode,
      "type": isSignup
          ? OTPVerificationType.verification.name
          : OTPVerificationType.forgot.name
    });
    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(endPoint: endPoint, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _verifyOtpResponseMethod(
          context: context,
          verificationType: verificationType,
          userEmail: userEmail,
          otpCode: otpCode,
          userId: userId, fullName: fullName);
    };
    _validateResponse();
  }

  ///  Post Request

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

  void _verifyOtpResponseMethod({
    required BuildContext context,
    required OTPVerificationType verificationType,
    int? userId,
    String? otpCode,
    String? userEmail,
    String? fullName,
  }) {
    try {
      _verificationCodeResponse = UserResponseModel.fromJson(_response?.data);
      if (_verificationCodeResponse != null) {
        SharedPreference()
            .setBearerToken(token: _verificationCodeResponse?.token);
        if (verificationType == OTPVerificationType.verification) {
          // context
          //     .read<UserProvider>()
          //     .setCurrentUser(user: _verificationCodeResponse?.data);
          if (context.read<AuthRoleProvider>().role == AuthRole.user) {
            // context.read<AuthRoleProvider>().setContractorAuthRole();
            AppNavigation.navigateToRemovingAll(
              context,
              AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE,
              arguments: CompleteProfileArguments(
                  emailAddress: userEmail ?? "",
                  fullName: fullName ?? ""),
            );
            // AppNavigation.navigateToRemovingAll(
            //   context,
            //   AppRouteName.MAIN_SCREEN_ROUTE,
            //   arguments: MainScreenRoutingArgument(
            //     index: 1,
            //   ),
            // );
          } else {
            // context.read<AuthRoleProvider>().setContractorAuthRole();
            AppNavigation.navigateToRemovingAll(
              context,
              AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE,
              arguments: CompleteProfileArguments(
                emailAddress: userEmail ?? "",
                fullName: fullName ?? "",
                token: _verificationCodeResponse?.token,
              ),
            );
            // AppNavigation.navigateToRemovingAll(
            //   context,
            //   AppRouteName.MAIN_SCREEN_ROUTE,
            //   arguments: MainScreenRoutingArgument(
            //     index: 0,
            //   ),
            // );
          }
        } else if (verificationType == OTPVerificationType.forgot) {
          AppNavigation.navigateReplacementNamed(
            context,
            AppRouteName.RESET_PASSWORD_SCREEN_ROUTE,
            arguments: ResetPasswordRoutingArguments(userId: userId),
          );
        }
      }
    } catch (error) {
      print("OTP ERROR");
      print(error);
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}
