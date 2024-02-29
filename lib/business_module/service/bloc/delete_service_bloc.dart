import 'dart:async';

import 'package:customer_service_provider_hybrid/business_module/home/provider/services_provider.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/network/network.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/network_strings.dart';

class DeleteServicesBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  ServicesProvider? _servicesProvider;

  ////////////////////////// Content //////////////////////////////////
  Future<void> deleteService({
    required BuildContext context,
    int? serviceId,
    required VoidCallback setProgressBar,
  }) async {
    _servicesProvider = context.read<ServicesProvider>();

    setProgressBar();

    _queryParameters = {"service_id": serviceId};

    _onFailure = () {
      AppNavigation.navigatorPop(context);
      print("FAILURE");
    };

    await _getRequest(
      endPoint: NetworkStrings.DELETE_SERVICE_ENDPOINT,
      context: context,
    );

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _deleteServicesResponseMethod(context: context, serviceId: serviceId);
    };
    _validateResponse();
  }

  ////////////////// Get Request /////////////////////////////////////////
  Future<void> _getRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().getRequest(
        context: context,
        endPoint: endPoint,
        queryParameters: _queryParameters,
        onFailure: _onFailure,
        isHeaderRequire: true);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response,
          onFailure: _onFailure,
          onSuccess: _onSuccess,
          isToast: false);
    }
  }

  void _deleteServicesResponseMethod(
      {required BuildContext context, int? serviceId}) {
    try {
      if (_response?.data != null) {
        _servicesProvider?.deleteServiceMethod(serviceId: serviceId);
        AppNavigation.navigatorPop(context);
        AppNavigation.navigatorPop(context);
      } else {
        print("DATA IS NULL");
      }
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      //_setStreamNull();
    }
  }
}
