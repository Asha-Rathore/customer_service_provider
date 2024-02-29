import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../services/network/network.dart';
import '../../utils/app_navigation.dart';
import '../../utils/network_strings.dart';
import '../../utils/static_data.dart';

class DeleteAccountBloc {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;

  /// ------------- Delete Account Bloc Method -------------- ///
  void deleteAccountBlocMethod({
    required BuildContext context,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();


    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _getRequest(context: context, endPoint: NetworkStrings.DELETE_ACCOUNT_ENDPOINT);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      StaticData.clearAllAppData(context: context);
    };

    _validateResponse();
  }

  ////////////////// Get Request /////////////////////////////////////////
  Future<void> _getRequest({required BuildContext context, required String endPoint}) async {
    //print("post request");
    _response = await Network().getRequest(
      context: context,
        endPoint: endPoint,
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
}
