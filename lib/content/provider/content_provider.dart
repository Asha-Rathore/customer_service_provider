import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../services/network/network.dart';
import '../../utils/network_strings.dart';
import '../model/content_model.dart';

class ContentProvider extends ChangeNotifier {
  ContentResponseModel? _contentData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  bool? waitingStatus = false;
  String? _link;
  Map<String, dynamic>? _queryParameters;
  String? get getLink => _link;

  getContent({
    required BuildContext context,
    required String type,
  }) async {
    print("CONTENT RESPONSE ${_response}");
    waitingStatus = true;

    _queryParameters = {"type": type};

    _onFailure = () {
      _setDataNull();
    };

    await _getRequest(endPoint: NetworkStrings.CONTENT_ENDPOINT, context: context);

    _onSuccess = () {
      _codesResponseMethod(context: context);
    };

    _validateResponse();
    // return _codesData;
  }

  /// GET Request
  Future<void> _getRequest({required String endPoint, required BuildContext context}) async {
    _response =
    await Network().getRequest(endPoint: endPoint, context: context, onFailure: _onFailure, isHeaderRequire: false, queryParameters: _queryParameters);
  }

  /// Validate Response
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(response: _response, onSuccess: _onSuccess, onFailure: _onFailure, isToast: false);
    }
  }

  void _codesResponseMethod({required BuildContext context}) {
    //  try {

    if (_response!.data != null) {
      print("response is" + _response!.data.toString());
      _contentData = ContentResponseModel.fromJson(_response!.data);
      _link = _contentData?.data?.content;
      print("Link" + (_link ?? ""));
    } else {
      _setDataNull();
    }
    waitingStatus = false;
    notifyListeners();
/*    } catch (error) {
      print("error is " + error.toString());

      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      _setDataNull();
    }*/
  }

  void _setDataNull() {
    _contentData = null;
    waitingStatus = false;
    notifyListeners();
  }
}
