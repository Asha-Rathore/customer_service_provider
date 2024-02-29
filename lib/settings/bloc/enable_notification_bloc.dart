import 'dart:convert';

import 'package:customer_service_provider_hybrid/auth/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/network/network.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/network_strings.dart';
import '../../services/shared_preference.dart';
import '../enums/notification_type.dart';

class EnableNotificationBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic notificationResponseData;
  UserProvider? _userProvider;

  void enableNotificationBlocMethod({
    required BuildContext context,
    required VoidCallback setProgressBar,
    bool? notificationEnable,
  }) async {
    setProgressBar();

    print("Enable Notification Map");

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.ENABLE_NOTIFICATION_ENDPOINT, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _enableNotificationResponseMethod(context: context, notificationEnable: notificationEnable);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    //print("post request");
    _response = await Network().postRequest(
        endPoint: endPoint,
        context: context,
        onFailure: _onFailure,
        isHeaderRequire: true);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _enableNotificationResponseMethod(
      {required BuildContext context, bool? notificationEnable}) {
    try {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      notificationResponseData = _response!.data;
      //set notification key enable or disable
      _userProvider?.getCurrentUser?.notifications =
      notificationEnable == true
          ? NotificationType.enable.index
          : NotificationType.disable.index;


      _userProvider?.setCurrentUser(
          user: _userProvider?.getCurrentUser);

      //set user data in shared preference
      SharedPreference()
          .setUser(user: jsonEncode(_userProvider?.getCurrentUser?.toJson()));
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}
