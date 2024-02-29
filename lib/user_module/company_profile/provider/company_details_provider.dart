import 'dart:developer';

import 'package:customer_service_provider_hybrid/services/network/network.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/model/company_detail_model.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetCompanyDetailProvider with ChangeNotifier {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic companyDetailResponseData;

  CompanyDetail? get getCompanyDetailData => _companyDetailData;
  CompanyDetail? _companyDetailData;
  bool? waitingStatus;

  ///Add or remove fav locally
  void addOrRemoveFavoriteInDetails({int? isFav}) {
    _companyDetailData?.data?.isFavoriteCount = isFav;
    notifyListeners();
  }

  Future<void> getCompanyDetailProviderMethod({
    required BuildContext context,
    int? companyId,
  }) async {
    _queryParameters = {"company_id": companyId};

    waitingStatus = true;

    _onFailure = () {
      waitingStatus = false;
      _companyDetailData = null;
      notifyListeners();
    };

    await _getRequest(
        endPoint: NetworkStrings.COMPANY_DETAILS_ENDPOINT, context: context);

    _onSuccess = () {
      _companyDetailDataResponseMethod(context: context);
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

  void _companyDetailDataResponseMethod({required BuildContext context}) {
    try {
      companyDetailResponseData = _response?.data;
      if (companyDetailResponseData != null) {

     log("Company Details:${_response?.data}");


        _companyDetailData = CompanyDetail.fromJson(companyDetailResponseData);


      } else {
        _companyDetailData = null;
      }
      waitingStatus = false;
      notifyListeners();
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    } finally {
      notifyListeners();
    }
  }



  void updateCompanyDetailMethod({Map<String,dynamic>? companyDetailResponse}) {
    try {
      String? _averageRating;
      if (_companyDetailData != null && companyDetailResponse != null) {

        _averageRating = _companyDetailData?.data?.averageRating;




        _companyDetailData = CompanyDetail.fromJson(companyDetailResponse);

        _companyDetailData?.data?.averageRating = _averageRating;


      }

    } catch (error) {
     // AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
notifyListeners();
  }
}
