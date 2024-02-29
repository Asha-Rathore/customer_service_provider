import 'dart:convert';

import 'package:customer_service_provider_hybrid/auth/providers/user_provider.dart';
import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/utils/app_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/network/network.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/app_route_name.dart';
import '../../../utils/network_strings.dart';
import '../../service/routing_arguments/service_routing_arguments.dart';

class AddSubscriptionBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic addSubscriptionResponseData;

  void addSubscriptionBlocMethod({
    bool? isFromProfile,
    required BuildContext context,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();

    print("Add Subscription Map");

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.ADD_SUBSCRIPTION_ENDPOINT, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _addSubscriptionResponseMethod(context: context, isFromProfile: isFromProfile);
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

  void _addSubscriptionResponseMethod(
      {required BuildContext context, bool? isFromProfile}) {
    try {
      if(_response?.data != null){
        if (isFromProfile != true) {
          AppNavigation.navigateToRemovingAll(
            context,
            AppRouteName.MAIN_SCREEN_ROUTE,
            arguments: MainScreenRoutingArgument(
              index: 0,
            ),
          );
          // AppNavigation.navigatorPop(context);
        } else {
          AppNavigation.navigateTo(
            context,
            AppRouteName.ADD_OR_EDIT_SERVICE_SCREEN_ROUTE,
            arguments: ServiceScreenRoutingArgument(
                isEditService: false, isFromProfile: true),
          );
        }

      }
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}
