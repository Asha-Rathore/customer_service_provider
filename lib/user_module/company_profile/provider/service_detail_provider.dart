import 'package:customer_service_provider_hybrid/business_module/service/model/add_service_model.dart';
import 'package:customer_service_provider_hybrid/services/network/network.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/service_detail_model.dart';

class ServiceDetailProvider with ChangeNotifier {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic serviceDetailResponseData;

  ServiceDetailsModel? get getServiceDetailData => _serviceDetailData;
  ServiceDetailsModel? _serviceDetailData;
  bool? waitingStatus;

  Future<void> getServiceDetailProviderMethod({
    required BuildContext context,
    int? serviceId,
  }) async {
    _queryParameters = {"service_id": serviceId};

    waitingStatus = true;

    _onFailure = () {
      waitingStatus = false;
      _serviceDetailData = null;
      notifyListeners();
    };

    await _getRequest(
        endPoint: NetworkStrings.SERVICE_DETAILS_ENDPOINT, context: context);

    _onSuccess = () {
      _serviceDetailDataResponseMethod(context: context);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _getRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().getRequest(
      endPoint: endPoint,
      queryParameters: _queryParameters,
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

  void _serviceDetailDataResponseMethod({required BuildContext context}) {
    try {
      serviceDetailResponseData = _response!.data;
      if (serviceDetailResponseData != null) {
        _serviceDetailData =
            ServiceDetailsModel.fromJson(serviceDetailResponseData);
      } else {
        _serviceDetailData = null;
      }
      waitingStatus = false;
      notifyListeners();
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    } finally {
      notifyListeners();
    }
  }

  void updateServiceDetailMethod(
      {required BuildContext context,
      ServiceResponseModel? serviceResponseModel}) {
    try {
      if (_serviceDetailData != null) {
        _serviceDetailData?.data?.name = serviceResponseModel?.data?.name;
        _serviceDetailData?.data?.description =
            serviceResponseModel?.data?.description;
        _serviceDetailData?.data?.location =
            serviceResponseModel?.data?.location;
        _serviceDetailData?.data?.serviceImage =
            serviceResponseModel?.data?.serviceImage;
      }
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }

    notifyListeners();
  }
}
