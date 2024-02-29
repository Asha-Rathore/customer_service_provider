import 'dart:developer';

import 'package:customer_service_provider_hybrid/services/network/dio_interceptors/logging_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../utils/app_dialogs.dart';
import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../../utils/network_strings.dart';
import '../connectivity_manager.dart';
import '../shared_preference.dart';

class Network {
  static Dio? _dio;
  static CancelToken? _cancelRequestToken;
  static Network? _network;
  static ConnectivityManager? _connectivityManager;

  Network._createInstance();

  factory Network() {
    // factory with constructor, return some value
    if (_network == null) {
      _network = Network
          ._createInstance(); // This is executed only once, singleton object
      _dio = _getDio();
      _dio?.interceptors.add(LoggingInterceptors());
      _cancelRequestToken = _getCancelToken();
      _connectivityManager = ConnectivityManager();
    }
    return _network!;
  }

  static Dio _getDio() {
    return _dio ??= Dio();
  }

  static CancelToken _getCancelToken() {
    return _cancelRequestToken ??= CancelToken();
  }

  /// ---------------------  Set Header ---------------------
  _setHeader({required bool isHeaderRequire}) {
    if (isHeaderRequire == true) {
      String token = SharedPreference().getBearerToken() ?? "";
      print("HEADER TOKEN: ${token}");
      return {
        'Accept': NetworkStrings.ACCEPT,
        'Authorization': "Bearer $token",
      };
    } else {
      return {
        'Accept': NetworkStrings.ACCEPT,
      };
    }
  }

  /// --------------------- Validate Exception ---------------------
  void _validateException({
    required BuildContext context,
    Response? response,
    String? message,
    bool normalRequest = true,
    bool isToast = true,
    bool isErrorToast = true,
    VoidCallback? onFailure,
  }) {
    log("Response:${response.toString()}");
    if (onFailure != null) {
      onFailure();
    }
    if (response?.statusCode == NetworkStrings.BAD_REQUEST_CODE) {
      //to check normal api or stripe bad request error
      if (normalRequest == true) {
        //for normal api request error
        isToast
            ? AppDialogs.showToast(message: response?.data["message"] ?? "")
            : null;
      } else {
        //for stripe bad request error
        AppDialogs.showToast(message: response?.data["error"]["message"]);
        // != null
        //     ? response?.data["error"]["message"]
        //     : NetworkStrings.INVALID_BANK_ACCOUNT_DETAILS_ERROR);
      }
    } else if (response?.statusCode == NetworkStrings.FORBIDDEN_CODE) {
      //to check normal api or stripe bad request error
      AppDialogs.showToast(message: response?.data["message"] ?? "");
    } else {
      isErrorToast
          ? AppDialogs.showToast(
              message: response?.statusMessage ?? message.toString())
          : null;
    }
    if (response?.statusCode == NetworkStrings.UNAUTHORIZED_CODE) {
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.ROLE_SELECTION_SCREEN_ROUTE);
      SharedPreference().clear();
      // Provider.of<UserProvider>(context, listen: false).setCurrentUser(user: null);
    }
  }

  /// --------------------- Get Request ---------------------
  Future<Response?> getRequest({
    required BuildContext context,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    VoidCallback? onFailure,
    bool isToast = true,
    bool isErrorToast = true,
    int connectTimeOut = 20000,
    required bool isHeaderRequire,
  }) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = connectTimeOut;
        response = await _dio!.get(
          NetworkStrings.API_BASE_URL + endPoint,
          queryParameters: queryParameters,
          cancelToken: _cancelRequestToken,
          options: Options(
              headers: _setHeader(isHeaderRequire: isHeaderRequire),
              sendTimeout: connectTimeOut,
              receiveTimeout: connectTimeOut),
        );
      } on DioError catch (e) {
        _validateException(
            response: e.response,
            context: context,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        //print("$endPoint Dio: " + e.message!);
      }
    } else {
      _noInternetConnection(onFailure: onFailure);
    }

    return response;
  }

  /// --------------------- Post Request ---------------------
  Future<Response?> postRequest({
    required BuildContext context,
    required String endPoint,
    FormData? formData,
    VoidCallback? onFailure,
    Map<String, dynamic>? data,
    bool isToast = true,
    String? baseUrl,
    int connectTimeOut = 20000,
    bool isErrorToast = true,
    required bool isHeaderRequire,
  }) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = connectTimeOut;
        response = await _dio!.post(
            (baseUrl ?? NetworkStrings.API_BASE_URL) + endPoint,
            data: data ?? formData,
            cancelToken: _cancelRequestToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: connectTimeOut,
                receiveTimeout: connectTimeOut));
        // print(response);
      } on DioError catch (e) {
        print("Error on Network");
        print(e);
        _validateException(
            response: e.response,
            context: context,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        //print("$endPoint Dio: " + e.message!);
      }
    } else {
      _noInternetConnection(onFailure: onFailure);
    }
    return response;
  }

  /// --------------------- Put Request ---------------------
  Future<Response?> putRequest(
      {required BuildContext context,
      required String endPoint,
      Map<String, dynamic>? queryParameters,
      VoidCallback? onFailure,
      bool isToast = true,
      int connectTimeOut = 20000,
      bool isErrorToast = true,
      required bool isHeaderRequire}) async {
    Response? response;

    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = connectTimeOut;
        response = await _dio!.put(NetworkStrings.API_BASE_URL + endPoint,
            queryParameters: queryParameters,
            cancelToken: _cancelRequestToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: connectTimeOut,
                receiveTimeout: connectTimeOut));
        //print(response);
      } on DioError catch (e) {
        _validateException(
            response: e.response,
            context: context,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        //print("$endPoint Dio: " + e.message!);
      }
    } else {
      _noInternetConnection(onFailure: onFailure);
    }

    return response;
  }

  /// --------------------- Delete Request ---------------------
  Future<Response?> deleteRequest(
      {required BuildContext context,
      required String endPoint,
      Map<String, dynamic>? queryParameters,
      VoidCallback? onFailure,
      bool isToast = true,
      int connectTimeOut = 20000,
      bool isErrorToast = true,
      required bool isHeaderRequire}) async {
    Response? response;
    if (await _connectivityManager!.isInternetConnected()) {
      try {
        _dio?.options.connectTimeout = connectTimeOut;
        response = await _dio!.delete(NetworkStrings.API_BASE_URL + endPoint,
            queryParameters: queryParameters,
            cancelToken: _cancelRequestToken,
            options: Options(
                headers: _setHeader(isHeaderRequire: isHeaderRequire),
                sendTimeout: connectTimeOut,
                receiveTimeout: connectTimeOut));
        //  print(response.toString());
      } on DioError catch (e) {
        _validateException(
            response: e.response,
            context: context,
            message: e.message,
            onFailure: onFailure,
            isToast: isToast,
            isErrorToast: isErrorToast);
        //print("$endPoint Dio: " + e.message!);
      }
    } else {
      _noInternetConnection(onFailure: onFailure);
    }
    return response;
  }

  /// --------------------- Validate Response ---------------------
  void validateResponse(
      {Response? response,
      VoidCallback? onSuccess,
      VoidCallback? onFailure,
      bool isToast = true}) {
    var validateResponseData = response?.data;
    print(validateResponseData);
    if (validateResponseData != null) {
      isToast
          ? AppDialogs.showToast(message: validateResponseData['message'] ?? "")
          : null;
      if (response!.statusCode == NetworkStrings.SUCCESS_CODE) {
        if (validateResponseData['status'] ==
            NetworkStrings.API_SUCCESS_STATUS) {
          if (onSuccess != null) {
            onSuccess();
          }
        } else {
          if (onFailure != null) {
            Logger().e("API Sucess FAILURE CODE");
            onFailure();
          }
        }
      } else {
        if (onFailure != null) {
          Logger().e("API Response FAILURE CODE");
          onFailure();
        }
      }
    }
  }

  /// -----------------  Validate Response -----------------
  void validateGifResponse(
      {Response? response, VoidCallback? onSuccess, VoidCallback? onFailure}) {
    var validateResponseData = response?.data;
    if (validateResponseData != null) {
      if (response!.statusCode == NetworkStrings.SUCCESS_CODE) {
        if (onSuccess != null) {
          onSuccess();
        }
      }
    } else {
      if (onFailure != null) {
        onFailure();
      }
      //log(response!.statusCode!.toString());
    }
  }

  /// ----------------- No Internet Connection -----------------
  void _noInternetConnection({VoidCallback? onFailure}) {
    if (onFailure != null) {
      onFailure();
    }
    AppDialogs.showToast(message: NetworkStrings.NO_INTERNET_CONNECTION);
  }
}
