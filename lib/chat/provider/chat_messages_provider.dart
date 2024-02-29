import 'dart:developer';

import 'package:customer_service_provider_hybrid/services/network/network.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/chat_messages_model.dart';

class ChatMessagesProvider with ChangeNotifier {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic chatMessagesResponseData;

  ChatMessagesModel? get getChatMessagesData => _mainChatData;
  ChatMessagesModel? _mainChatData, _chatData, _searchChatData;
  bool? waitingStatus;

  Future<void> getChatMessagesProviderMethod({
    required BuildContext context,
  }) async {
    waitingStatus = true;

    _onFailure = () {
      waitingStatus = false;
      _mainChatData = null;
      _chatData = null;
      _searchChatData = null;
      notifyListeners();
    };

    await _getRequest(
        endPoint: NetworkStrings.CHAT_MESSAGES_ENDPOINT, context: context);

    _onSuccess = () {
      _chatMessagesDataResponseMethod(context: context);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _getRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().getRequest(
      endPoint: endPoint,
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

  void _chatMessagesDataResponseMethod({required BuildContext context}) {
    try {
      chatMessagesResponseData = _response?.data;
      if (chatMessagesResponseData != null) {
        log("Inbox Response :${chatMessagesResponseData}");

        _chatData = ChatMessagesModel.fromJson(chatMessagesResponseData);

        _mainChatData = _chatData;
      } else {
        _mainChatData = null;
      }
      waitingStatus = false;
      notifyListeners();
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    } finally {
      notifyListeners();
    }
  }

  void searchChatMessagesMethod({String? searchText}) {
    try {
      if (_chatData != null) {
        if ((searchText ?? "").isNotEmpty) {
          _searchChatData =
              ChatMessagesModel.fromJson(_chatData?.toJson() ?? {});
          _searchChatData?.data = _searchChatData?.data
              ?.where((searchData) =>
                  (searchData?.fullName
                          ?.toLowerCase()
                          .contains(searchText?.toLowerCase() ?? "") ??
                      false) ||
                  (searchData?.lastMessage
                          ?.toLowerCase()
                          .contains(searchText?.toLowerCase() ?? "") ??
                      false))
              .toList();

          _mainChatData = _searchChatData;
        } else {
          _searchChatData = null;
          _mainChatData = _chatData;
        }
      }
    } catch (error) {
      //AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
    notifyListeners();
  }
}
