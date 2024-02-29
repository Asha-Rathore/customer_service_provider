import 'package:customer_service_provider_hybrid/auth/providers/auth_role_provider.dart';
import 'package:customer_service_provider_hybrid/auth/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/network/network.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/network_strings.dart';

class logoutBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;

  UserProvider? _userProvider;

  void logoutBlocMethod({
    required BuildContext context,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    // String? token = SharedPreference().getBearerToken();
    int? userId = _userProvider?.getCurrentUser?.id;
    print("user_id : $userId}");
    print("user token : ${SharedPreference().getBearerToken()}");

    _formData = FormData.fromMap({
      "user_id": userId,
    });

    print("Logout Map");
    print({
      "user_id": userId,
    });

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.LOGOUT_ENDPOINT, context: context);

    _onSuccess = () {
      _logoutResponseMethod(context: context);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    //print("post request");
    _response = await Network().postRequest(
        endPoint: endPoint,
        formData: _formData,
        context: context,
        onFailure: _onFailure,
        isHeaderRequire: true);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
      print("data is _signOutResponseMethod" + _response.toString());
      print(
          "data is _signOutResponseMethod" + _response!.statusCode.toString());
    }
  }

  void _logoutResponseMethod({required BuildContext context}) {
    try {
      String? token = SharedPreference().getBearerToken();
      print("TOKEN : ${token}");
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.ROLE_SELECTION_SCREEN_ROUTE);
      // AppDialogs.showToast(message: "Logout Successfully");
      SharedPreference().clear();
      // context.read<RequestsProvider>().disposeRequestValues();
      context.read<UserProvider>().disposeCurrentUser();
      // context.read<RequestsProvider>().disposeRequestValues();
      // context.read<ClientRequestDetailProvider>().disposeRequestValues();
      print("data is _signOutResponseMethod");
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}
