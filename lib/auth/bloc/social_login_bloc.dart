import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:customer_service_provider_hybrid/auth/enums/auth_roles.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../main_screen/routing_arguments/main_screen_routing_arguments.dart';
import '../../profile/arguments/complete_profile_arguments.dart';
import '../../services/firebase_messaging_service.dart';
import '../../services/network/network.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/app_strings.dart';
import '../../utils/network_strings.dart';
import '../model/user_model.dart';
import '../providers/auth_role_provider.dart';
import '../providers/user_provider.dart';

class SocialLoginBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  UserResponseModel? _socialLoginResponse;
  String? deviceToken;
  UserProvider? _userProvider;
  AuthRoleProvider? _authRoleProvider;
  User? _userData;

  void socialLoginBlocMethod({
    required BuildContext context,
    String? userFirstName,
    String? userLastName,
    String? userEmail,
    String? socialType,
    String? phoneNo,
    String? countryCode,
    required String userSocialToken,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();
    deviceToken = await FirebaseMessagingService().getToken();
    _authRoleProvider = context.read<AuthRoleProvider>();
    //Form Data
    _formData = FormData.fromMap({
      "access_token": userSocialToken,
      "provider": socialType,
      "device_token": deviceToken,
      "device_type": Platform.isIOS ? 'android' : 'ios',
      "first_name": userFirstName,
      "last_name": userLastName,
      "role": _authRoleProvider?.role,
    });

    log("Social login data is " +
        {
          "access_token": userSocialToken,
          "provider": socialType,
          "device_token": deviceToken,
          "email": userEmail,
          "device_type": Platform.isIOS ? 'android' : 'ios',
          "first_name": userFirstName,
          "last_name": userLastName,
          "role": context.read<AuthRoleProvider>().role,
        }.toString());

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.SOCIAL_LOGIN_ENDPOINT, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _socialLoginResponseMethod(
          context: context,
          userFullName: "${userFirstName} ${userLastName}",
          email: userEmail);
    };
    _validateResponse();
  }

  ///---------------- Post Request
  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().postRequest(
        endPoint: endPoint,
        formData: _formData,
        context: context,
        onFailure: _onFailure,
        isHeaderRequire: false);
  }

  ///------------------ Validate Response
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
        response: _response,
        onSuccess: _onSuccess,
        onFailure: _onFailure,
      );
    }
  }

  void _socialLoginResponseMethod(
      {required BuildContext context, String? userFullName, String? email}) {
    //  try {
    _socialLoginResponse = UserResponseModel.fromJson(_response?.data);
    log("RESPONSE: ${_response}");
    _userData = _socialLoginResponse?.data;
    if (_socialLoginResponse != null) {
      _checkCompleteProfileMethod(
          context: context, userName: userFullName, email: email);
    }
    // } catch (error) {
    //   log(error.toString());
    //   AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    // }
  }

  void _checkCompleteProfileMethod(
      {required BuildContext context, String? userName, String? email}) async {
    SharedPreference().setBearerToken(token: _socialLoginResponse?.token);

    log("TOKEN: ${_socialLoginResponse?.token}");

    //assign reference to user provider
    _userProvider = Provider.of<UserProvider>(context, listen: false);

    _userProvider?.setCurrentUser(user: _userData);

    log("USER PROVIDER ON LOGIN: ${_userProvider?.getCurrentUser?.toJson()}");
    log("SOCIAL ROLE: ${_userProvider?.getCurrentUser?.role}");
    if (_userData?.role == AuthRole.user.name) {
      Logger().i("In User method");
      if (_userData?.isProfileComplete == NetworkStrings.PROFILE_INCOMPLETED) {
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE,
          arguments: CompleteProfileArguments(
              emailAddress: "", fullName: userName ?? ""),
        );
      } else if (_userData?.isProfileComplete ==
          NetworkStrings.PROFILE_COMPLETED) {
        log("LOGIN ROLE: ${_userData?.role}");
        print("IS PROFILE COMPLETE : ${_userData?.isProfileComplete}");
        SharedPreference().setUser(user: jsonEncode(_userData));
        print("USER DETAIL: " + SharedPreference().getUser().toString());
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.MAIN_SCREEN_ROUTE,
          arguments: MainScreenRoutingArgument(
            index: 1,
          ),
        );
      }
    }
    else if (_userData?.role == AuthRole.business.name) {
      Logger().i("In business method");
      if (_userData?.isProfileComplete == NetworkStrings.PROFILE_INCOMPLETED) {
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE,
          arguments: CompleteProfileArguments(
              emailAddress: "",
              fullName: userName ?? ""),
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
