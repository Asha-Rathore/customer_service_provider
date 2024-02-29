import 'dart:async';

import 'package:customer_service_provider_hybrid/business_module/subscription/model/subscription_model.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../services/network/network.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/network_strings.dart';

class SubscriptionBloc {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic subscriptionResponse;
  StreamController<SubscriptionModel?> _subscriptionList =
  StreamController<SubscriptionModel?>();
  SubscriptionModel? _subscriptionModel;

  ////////////////////////// Content //////////////////////////////////
  Future subscriptions({required BuildContext context}) async {

    _onFailure = () {
    };

    await _getRequest(
      endPoint: NetworkStrings.SUBSCRIPTIONS_ENDPOINT,
      context: context,
    );

    _onSuccess = () {
      _subscriptionResponseMethod(context: context);
    };
    _validateResponse();
  }

  ////////////////// Get Request /////////////////////////////////////////
  Future<void> _getRequest({required String endPoint, required BuildContext context}) async {
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
          response: _response, onFailure: _onFailure, onSuccess: _onSuccess, isToast: false);
    }
  }

  void _subscriptionResponseMethod({required BuildContext context}) {
    try {

      subscriptionResponse=_response!.data;
      print("this call"+subscriptionResponse.toString());

      if(subscriptionResponse!=null){
        _subscriptionModel=SubscriptionModel.fromJson(subscriptionResponse);
        _subscriptionList.add(_subscriptionModel);
      }
      else{
        print("DATA IS NULL");
        AppNavigation.navigatorPop(context);
        _setStreamNull();
      }

    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      //_setStreamNull();
    }
  }

  void _setStreamNull() {

    if (!_subscriptionList.isClosed) {
      print("NULL STREAM");
      _subscriptionList.add(null);
    }
  }

  Stream<SubscriptionModel?>? getSubscriptionList() {
    if (!_subscriptionList.isClosed) {
      return _subscriptionList.stream;
    }
  }

  void cancelStream() {
    _subscriptionList.close();
  }
}