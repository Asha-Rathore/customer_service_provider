

import 'package:flutter/material.dart';

import '../model/chat_data_model.dart';

class ChatProvider with ChangeNotifier {
  ChatModel? _chatModel;
  ChatModelData? _singleChatMessage;
  bool isChatWaiting = true;
  List<ChatModelData?>? _reverseChatList;

////////////////getters//////////////////

  List<ChatModelData?>? get getReverseChatList => _reverseChatList;


////////////////setters//////////////////

  void setChatData({dynamic chatDataList}) {
    if (chatDataList != null) {
      _chatModel = ChatModel.fromJson(chatDataList);
      _reverseChatList = _chatModel?.data?.reversed.toList();
      // _reverseChatList = _chatModel?.data?.toList();
    } else {
      _chatModel = null;
      _reverseChatList = null;
    }
    isChatWaiting = false;
    notifyListeners();
  }

  void appendSingleChatMessage(
      {dynamic singleChatMessage,}) {
    if (_chatModel != null) {
      _singleChatMessage =
          ChatModelData.fromJson(singleChatMessage["data"]);
      //_chatModel!.data == null ? _chatModel!.data = [] : null;

       _chatModel?.data?.add(_singleChatMessage);
      //_chatModel?.data?.insert(0,_singleChatMessage);
      // _reverseChatList = _chatModel?.data?.toList();
      _reverseChatList = _chatModel?.data?.reversed.toList();
    } else {
      _chatModel = null;
      _reverseChatList = null;
    }
    isChatWaiting = false;
    notifyListeners();
  }

  void deleteChatMessage({int? chatId}) {
    if (_chatModel != null) {
      _chatModel?.data?.removeWhere((chatData) => chatData?.id == chatId);
      _reverseChatList = _chatModel?.data?.reversed.toList();
      notifyListeners();
    }
  }

  void disposeChat() {
    _chatModel = null;
    _reverseChatList = null;
    isChatWaiting = true;
  }
}
