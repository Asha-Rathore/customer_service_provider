import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../services/network/network.dart';
import '../../utils/network_strings.dart';

class ContentBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess;
  dynamic contentTypeResponse;

  ////////////////////////// Content //////////////////////////////////
  Future content({required BuildContext context, String? contentType}) async {
    _queryParameters = {"type": contentType};

    await _getRequest(
      endPoint: NetworkStrings.CONTENT_ENDPOINT,
      context: context,
    );

    _onSuccess = () {
      contentTypeResponse = _response?.data;
    };
    _validateResponse();

    return contentTypeResponse;
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
}
