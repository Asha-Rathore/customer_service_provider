import 'package:customer_service_provider_hybrid/auth/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../services/network/network.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/network_strings.dart';

class AddToFavoriteBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic favoriteResponseData;

  void addToFavBlocMethod({
    required BuildContext context,
    required VoidCallback setProgressBar,
    Function(int)? onApiSuccess,
    int? companyId,
  }) async {
    setProgressBar();

    _formData = FormData.fromMap({
      "company_id": companyId,
    });

    print("Add To Fav Map");
    print({
      "company_id": companyId,
    });

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.ADD_TO_FAVORITE_ENDPOINT, context: context);

    _onSuccess = () {
      _addFavoriteResponseMethod(context: context, onApiSuccess: onApiSuccess);
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
    }
  }

  void _addFavoriteResponseMethod(
      {required BuildContext context, Function(int)? onApiSuccess}) {
    //try {
      favoriteResponseData = _response!.data;
      if (favoriteResponseData != null) {
        if (onApiSuccess != null) {
          onApiSuccess(favoriteResponseData["is_favorite_count"]);
        }
        AppNavigation.navigatorPop(context);
      }
/*    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }*/
  }
}
