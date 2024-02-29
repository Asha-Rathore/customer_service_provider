import 'dart:async';

import 'package:customer_service_provider_hybrid/user_module/company_profile/model/company_services_model.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/model/reviews_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../services/network/network.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/network_strings.dart';

class ReviewsBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic reviewsResponse;
  StreamController<ReviewsModel?> _reviewsList =
  StreamController<ReviewsModel?>();
  ReviewsModel? _reviewsModel;

  ////////////////////////// Content //////////////////////////////////
  Future reviews({required BuildContext context, int? companyId}) async {
    _queryParameters = {"company_id": companyId};

    _onFailure = () {
      _setStreamNull();
    };

    await _getRequest(
      endPoint: NetworkStrings.REVIEWS_ENDPOINT,
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
        isHeaderRequire: true);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, isToast: false);
    }
  }

  void _companyServicesResponseMethod({required BuildContext context}) {
    try {

      reviewsResponse=_response!.data;
      print("this call"+reviewsResponse.toString());

      if(reviewsResponse!=null){
        _reviewsModel=ReviewsModel.fromJson(reviewsResponse);
        _reviewsList.add(_reviewsModel);
      }
      else{
        _setStreamNull();
      }

    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      //_setStreamNull();
    }
  }

  void _setStreamNull() {

    if (!_reviewsList.isClosed) {
      _reviewsList.add(null);
    }
  }

  Stream<ReviewsModel?>? getReviewsList() {
    if (!_reviewsList.isClosed) {
      return _reviewsList.stream;
    }
  }

  void cancelStream() {
    _reviewsList.close();
  }
}