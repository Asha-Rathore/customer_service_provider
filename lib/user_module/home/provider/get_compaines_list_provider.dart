import 'package:customer_service_provider_hybrid/services/network/network.dart';
import 'package:customer_service_provider_hybrid/user_module/home/model/companies_list_model.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetCompaniesListProvider with ChangeNotifier {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic companiesListResponseData;

  CompaniesList? get getCurrentMyCompaniesListData => _mainCompanyListData;
  CompaniesList? _mainCompanyListData, _companyListData, _searchCompanyListData;

  bool? waitingStatus;

  Future<void> getCompaniesListProviderMethod({
    required BuildContext context,
  }) async {
    waitingStatus = true;

    _onFailure = () {
      waitingStatus = false;
      _mainCompanyListData = null;
      _companyListData = null;
      _searchCompanyListData = null;
      notifyListeners();
    };

    await _getRequest(
        endPoint: NetworkStrings.COMPANIES_ENDPOINT, context: context);

    _onSuccess = () {
      _companiesListDataResponseMethod(context: context);
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

  void _companiesListDataResponseMethod({required BuildContext context}) {
    try {
      companiesListResponseData = _response!.data;
      if (companiesListResponseData != null) {
        _companyListData = CompaniesList.fromJson(companiesListResponseData);
        _mainCompanyListData = _companyListData;
      } else {
        _mainCompanyListData = null;
      }
      waitingStatus = false;
      notifyListeners();
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    } finally {
      notifyListeners();
    }
  }

  void searchCompaniesMethod({String? searchText}) {
    try {
      if (_companyListData != null) {
        if ((searchText ?? "").isNotEmpty) {
          _searchCompanyListData =
              CompaniesList.fromJson(_companyListData?.toJson() ?? {});
          _searchCompanyListData?.data = _searchCompanyListData?.data
              ?.where((companyData) =>
                  companyData?.companyName
                      ?.toLowerCase()
                      .contains(searchText?.toLowerCase() ?? "") ??
                  false)
              .toList();

          _mainCompanyListData = _searchCompanyListData;
        } else {
          _searchCompanyListData = null;
          _mainCompanyListData = _companyListData;
        }
      }
    } catch (error) {
      //AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
    notifyListeners();
  }

  ///Add or remove fav locally
  void addOrRemoveFavorite({required int index, int? isFav, int? companyId}) {
    // print("THIS CAL********L" + isFav.toString());
    // print("INDEX" + index.toString());

    int? _mainIndex = -1, _subIndex = -1;

    try {
      _mainIndex = _mainCompanyListData?.data?.indexWhere(
              (mainCompanyData) => mainCompanyData?.id == companyId) ??
          -1;

      if (_mainIndex >= 0) {
        _mainCompanyListData?.data?[_mainIndex]?.isFavoriteCount = isFav;
      }

      _subIndex = _companyListData?.data
              ?.indexWhere((companyData) => companyData?.id == companyId) ??
          -1;

      if (_subIndex >= 0) {
        _companyListData?.data?[_subIndex]?.isFavoriteCount = isFav;
      }
    } catch (e) {}

    notifyListeners();
  }
}
