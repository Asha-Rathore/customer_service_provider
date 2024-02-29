import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:customer_service_provider_hybrid/auth/arguments/otp_arguments.dart';
import 'package:customer_service_provider_hybrid/auth/enums/auth_roles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../main_screen/routing_arguments/main_screen_routing_arguments.dart';
import '../../profile/arguments/complete_profile_arguments.dart';
import '../../services/firebase_messaging_service.dart';
import '../../services/network/network.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/app_strings.dart';
import '../../utils/network_strings.dart';
import '../enums/otp_verification_type.dart';
import '../model/user_model.dart';
import '../providers/user_provider.dart';

class LoginBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  UserResponseModel? _loginResponse;
  User? _userData;
  String? deviceToken;
  UserProvider? _userProvider;

  void loginBlocMethod({
    required BuildContext context,
    String? userEmail,
    String? userPassword,
    String? role,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();
    deviceToken = await FirebaseMessagingService().getToken();
    //Form Data
    _formData = FormData.fromMap({
      "email": userEmail,
      "password": userPassword,
      "device_type": Platform.isAndroid ? 'android' : 'ios',
      "device_token": deviceToken ?? '123',
      "role": role,
    });

    print("Login Map");
    print({
      "email": userEmail,
      "password": userPassword,
      "device_type": Platform.isIOS ? 'android' : 'ios',
      "device_token": deviceToken ?? '123',
      "role": role,
    });
    _onFailure = () {
      AppNavigation.navigatorPop(context); // StopLoader
    };

    await _postRequest(
        endPoint: NetworkStrings.LOGIN_ENDPOINT, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _loginResponseMethod(context: context, userEmail: userEmail);
    };
    _validateResponse();
  }

  //-------------------------- Post Request ----------------------------------

  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().postRequest(
        endPoint: endPoint,
        formData: _formData,
        context: context,
        onFailure: _onFailure,
        isHeaderRequire: false);
  }

  //-------------------------- Validate Response --------------------------
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
        response: _response,
        onSuccess: _onSuccess,
        onFailure: _onFailure,
      );
    }
  }

  void _loginResponseMethod(
      {required BuildContext context, String? userEmail}) {
    //   try {
    _loginResponse = UserResponseModel.fromJson(_response?.data);
    _userData = _loginResponse?.data;
    if (_loginResponse != null) {
      _checkUserVerification(context: context, userEmail: userEmail);
    }
    //  } catch (error) {
    //  print(error);
    //  AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    // }
  }

  //to check user verified or not
  void _checkUserVerification(
      {required BuildContext context, String? userEmail}) {
    Logger().i('In Check Verification method');
    //IF NOT VERIFIED GO TO OTP
    if (_userData?.accountVerified == NetworkStrings.ACCOUNT_UNVERIFIED) {
      print('In email unverified method');
      AppNavigation.navigateTo(
          context, AppRouteName.OTP_VERIFICATION_SCREEN_ROUTE,
          arguments: OtpVerficationArguments(
            otpVerificationType: OTPVerificationType.verification,
            userId: _loginResponse?.data?.id,
            isProfile: true,
            emailAddress: _userData?.email,
            fullName: _userData?.fullName,
          ));
    } else if (_userData?.accountVerified == NetworkStrings.ACCOUNT_VERIFIED) {
      _completeProfileMethod(context: context, userEmail: userEmail);
    } else {
      Logger().i('In Else method 1');
    }
  }

  void _completeProfileMethod(
      {required BuildContext context, String? userEmail}) async {
    SharedPreference().setBearerToken(token: _loginResponse?.token);

    //assign reference to user provider
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    //set login response to user provider method
    _userProvider?.setCurrentUser(user: _userData);

    log("USER PROVIDER ON LOGIN: ${_userProvider?.getCurrentUser?.toJson()}");

    if (_userData?.role == AuthRole.user.name) {
      Logger().i("In User method");
      if (_userData?.isProfileComplete == NetworkStrings.PROFILE_INCOMPLETED) {
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE,
          arguments: CompleteProfileArguments(
              emailAddress: userEmail ?? "",
              fullName: _userData?.fullName ?? ""),
        );
      } else if (_userData?.isProfileComplete ==
          NetworkStrings.PROFILE_COMPLETED) {
        SharedPreference().setUser(user: jsonEncode(_userData));
        //print("USER DETAIL: " + SharedPreference().getUser().toString());
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.MAIN_SCREEN_ROUTE,
          arguments: MainScreenRoutingArgument(
            index: 1,
          ),
        );
      }
    } else if (_userData?.role == AuthRole.business.name) {
      Logger().i("In business method");
      if (_userData?.isProfileComplete == NetworkStrings.PROFILE_INCOMPLETED) {
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE,
          arguments: CompleteProfileArguments(
              emailAddress: userEmail ?? "",
              fullName: _userData?.fullName ?? ""),
        );
      } else if (_userData?.isProfileComplete ==
          NetworkStrings.PROFILE_COMPLETED) {
        SharedPreference().setUser(user: jsonEncode(_userData));
        print("USER DETAIL: " + SharedPreference().getUser().toString());
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.MAIN_SCREEN_ROUTE,
          arguments: MainScreenRoutingArgument(
            index: 0,
          ),
        );
      }
    } else {
      Logger().i("In  Else method");
    }
  }
}
