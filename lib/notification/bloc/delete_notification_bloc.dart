import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../services/network/network.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/network_strings.dart';

class DeleteNotificationBloc {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;

  ////////////////////////// Content //////////////////////////////////
  void deleteNotification(
      {required BuildContext context,
        required String notificationId,
        required VoidCallback setProgressBar,
        required Function() onApiSuccess}) async {
    setProgressBar();

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _getRequest(
      endPoint: NetworkStrings.DELETE_NOTIFICATION_ENDPOINT + notificationId,
      context: context,
    );

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      onApiSuccess();
    };
    _validateResponse();
  }

  ////////////////// Get Request /////////////////////////////////////////
  Future<void> _getRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().getRequest(
        context: context, endPoint: endPoint, isHeaderRequire: true);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, isToast: false);
    }
  }
}
