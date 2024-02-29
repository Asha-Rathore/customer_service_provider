import 'dart:async';

import 'package:customer_service_provider_hybrid/user_module/company_profile/model/company_services_model.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../services/network/network.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/network_strings.dart';

class CompanyServicesBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic companyServicesResponse;
  StreamController<CompanyServices?> _companyServicesList =
  StreamController<CompanyServices?>();
  CompanyServices? _companyServicesModel;

  ////////////////////////// Content //////////////////////////////////
  Future<void> companyServices({required BuildContext context, int? companyId}) async {
    _queryParameters = {"company_id": companyId};

    _onFailure = () {
      print("FAILURE");
      _setStreamNull();
    };

    await _getRequest(
      endPoint: NetworkStrings.COMPANY_SERVICES,
      context: context,
    );

    _onSuccess = () {
      _companyServicesResponseMethod(context: context);
    };
    _validateResponse();
  }

  ////////////////// Get Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint, required BuildContext context}) async {
    _response = await Network().getRequest(
        context: context,
        endPoint: endPoint,
        queryParameters: _queryParameters,
        onFailure: _onFailure,
        isHeaderRequire: true,
      isToast: false,
      isErrorToast: false,);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onFailure: _onFailure, onSuccess: _onSuccess, isToast: false);
    }
  }

  void _companyServicesResponseMethod({required BuildContext context}) {
    try {

      companyServicesResponse=_response!.data;
      print("this call"+companyServicesResponse.toString());

      if(companyServicesResponse!=null){
        _companyServicesModel=CompanyServices.fromJson(companyServicesResponse);
        _companyServicesList.add(_companyServicesModel);
      }
      else{
        print("DATA IS NULL");
        // AppNavigation.navigatorPop(context);
        _setStreamNull();
      }

    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      //_setStreamNull();
    }
  }

  void _setStreamNull() {

    if (!_companyServicesList.isClosed) {
      print("NULL STREAM");
      _companyServicesList.add(null);
    }
  }

  Stream<CompanyServices?>? getCompanyServicesList() {
    if (!_companyServicesList.isClosed) {
      return _companyServicesList.stream;
    }
  }

  void cancelStream() {
    _companyServicesList.close();
  }
}