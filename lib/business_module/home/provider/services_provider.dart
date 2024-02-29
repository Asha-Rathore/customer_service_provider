import 'dart:developer';

import 'package:customer_service_provider_hybrid/services/network/network.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/services_model.dart';

class ServicesProvider with ChangeNotifier {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic servicesResponseData;

  ServicesList? get getServicesListData => _servicesListData;
  ServicesList? _servicesListData;
  bool? waitingStatus;

  Future<void> getServicesListProviderMethod({
    required BuildContext context,
  }) async {
    waitingStatus = true;

    _onFailure = () {
      waitingStatus = false;
      _servicesListData = null;
      notifyListeners();
    };

    await _getRequest(
        endPoint: NetworkStrings.SERVICES_ENDPOINT, context: context);

    _onSuccess = () {
      _servicesListDataResponseMethod(context: context);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _getRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().getRequest(
      endPoint: endPoint,
      context: context,
      onFailure: _onFailure,
      isHeaderRequire: true,
      isToast: false,
      isErrorToast: false,
    );
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response,
          onSuccess: _onSuccess,
          onFailure: _onFailure,
          isToast: false);
    }
  }

  void _servicesListDataResponseMethod({required BuildContext context}) {
    try {
      servicesResponseData = _response!.data;
      if (servicesResponseData != null) {
        log("Service Response Data:${servicesResponseData}");

        _servicesListData = ServicesList.fromJson(servicesResponseData);
      } else {
        _servicesListData = null;
      }
      waitingStatus = false;
      notifyListeners();
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    } finally {
      notifyListeners();
    }
  }

  void updateServiceMethodMethod(
      {int? serviceId, Map<String, dynamic>? serviceResponse}) {
    try {
      int index = -1;

      if (_servicesListData != null && serviceResponse != null) {
        //log("Service Response Data:${servicesResponseData}");

        index = _servicesListData?.data
                ?.indexWhere((serviceData) => serviceData?.id == serviceId) ??
            -1;

        if (index >= 0) {


          log("Service Response ha:${serviceResponse}");

          _servicesListData?.data?[index] =
              ServicesListData.fromJson(serviceResponse);
          notifyListeners();
        }
      }
    } catch (error) {
      // AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }


  }

  //This will delete service locally
  void deleteServiceMethod({int? serviceId}) {
    try {
      if (_servicesListData != null) {
        log("Service Response Data:${servicesResponseData}");

        _servicesListData?.data
            ?.removeWhere((serviceData) => serviceData?.id == serviceId);
      }
      notifyListeners();
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}
