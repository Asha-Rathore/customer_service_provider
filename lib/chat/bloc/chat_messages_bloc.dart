import 'dart:async';
import 'package:customer_service_provider_hybrid/chat/model/chat_messages_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../services/network/network.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/network_strings.dart';

class ChatListBloc {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic _chatListResponse;
  StreamController<ChatMessagesModel?> _chatListEvent =
      StreamController<ChatMessagesModel?>();
  ChatMessagesModel? _chatList;

  Future<void> chatListBlocMethod({
    required BuildContext context,
  }) async {
    _onFailure = () {
      _setStreamNull();
    };

    await _getRequest(
        endPoint: NetworkStrings.CHAT_MESSAGES_ENDPOINT, context: context);

    _onSuccess = () {
      _chatListResponseMethod(context: context);
    };

    _validateResponse();
  }

  ////////////////// Get Request /////////////////////////////////////////
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

  void _chatListResponseMethod({required BuildContext context}) {
    try {
      _chatListResponse = _response!.data;
      print("this call" + _chatListResponse.toString());

      if (_chatListResponse != null) {
        _chatList = ChatMessagesModel.fromJson(_chatListResponse);
        _chatListEvent.add(_chatList);
      } else {
        _setStreamNull();
      }
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
      //_setStreamNull();
    }
  }

  void _setStreamNull() {
    if (!_chatListEvent.isClosed) {
      _chatListEvent.add(null);
    }
  }

  Stream<ChatMessagesModel?>? getChatList() {
    if (!_chatListEvent.isClosed) {
      return _chatListEvent.stream;
    }
  }

  void cancelStream() {
    _chatListEvent.close();
  }
}
