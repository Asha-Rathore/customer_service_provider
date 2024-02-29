import 'package:customer_service_provider_hybrid/services/network/network.dart';
import 'package:customer_service_provider_hybrid/user_module/favorites/model/favorite_list_model.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetFavoriteListProvider with ChangeNotifier {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic favoriteListResponseData;

  FavoriteList? get getFavoriteListData => _mainFavoriteListData;
  FavoriteList? _mainFavoriteListData,
      _favoriteListData,
      _searchFavoriteListData;
  bool? waitingStatus;

  Future<void> getFavoriteListProviderMethod({
    required BuildContext context,
    int? userId,
  }) async {
    _queryParameters = {"user_id": userId};
    waitingStatus = true;

    _onFailure = () {
      waitingStatus = false;
      _mainFavoriteListData = null;
      _favoriteListData = null;
      _searchFavoriteListData = null;
      notifyListeners();
    };

    await _getRequest(
        endPoint: NetworkStrings.FAVORITE_LIST_ENDPOINT, context: context);

    _onSuccess = () {
      _favoriteListDataResponseMethod(context: context);
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

  void _favoriteListDataResponseMethod({required BuildContext context}) {
    try {
      favoriteListResponseData = _response?.data;
      if (favoriteListResponseData != null) {
        _favoriteListData = FavoriteList.fromJson(favoriteListResponseData);
        _mainFavoriteListData = _favoriteListData;
      } else {
        _mainFavoriteListData = null;
      }
      waitingStatus = false;
      notifyListeners();
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    } finally {
      notifyListeners();
    }
  }

  void searchFavouriteMethod({String? searchText}) {
    try {
      if (_favoriteListData != null) {
        if ((searchText ?? "").isNotEmpty) {
          _searchFavoriteListData =
              FavoriteList.fromJson(_favoriteListData?.toJson() ?? {});
          _searchFavoriteListData?.data = _searchFavoriteListData?.data
              ?.where((favouriteData) =>
                  favouriteData?.companyName
                      ?.toLowerCase()
                      .contains(searchText?.toLowerCase() ?? "") ??
                  false)
              .toList();

          _mainFavoriteListData = _searchFavoriteListData;
        } else {
          _searchFavoriteListData = null;
          _mainFavoriteListData = _favoriteListData;
        }
      }
    } catch (error) {
      //AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
    notifyListeners();
  }

  ///Remove fav locally
  void removeFavorite({int? companyId}) {
    _mainFavoriteListData?.data
        ?.removeWhere((favouriteData) => favouriteData?.id == companyId);
    _favoriteListData?.data
        ?.removeWhere((favouriteData) => favouriteData?.id == companyId);
    notifyListeners();
  }
}
