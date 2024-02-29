import 'dart:developer';

import 'package:provider/provider.dart';

import '../auth/providers/user_provider.dart';
import '../chat/provider/chat_provider.dart';
import '../utils/network_strings.dart';
import '../utils/static_data.dart';

class SocketNavigationClass {
  static SocketNavigationClass? _instance;

  SocketNavigationClass._();

  static SocketNavigationClass? get instance {
    if (_instance == null) {
      _instance = SocketNavigationClass._();
    }
    return _instance;
  }

  void socketResponseMethod({dynamic responseData}) {
    String? userId=Provider.of<UserProvider>(StaticData.navigatorKey.currentContext!,listen: false).getCurrentUser?.id.toString();
    log("responseData is "+responseData.toString());

    if (responseData != null) {
        if (responseData["object_type"] == NetworkStrings.GET_MESSAGES_KEY) {
          Provider.of<ChatProvider>(StaticData.navigatorKey.currentContext!,
              listen: false)
              .setChatData(chatDataList: responseData);
          // onSuccess!(responseData["object_type"] );
        }
        else if (responseData["object_type"] ==
            NetworkStrings.GET_MESSAGE_KEY) {
          Provider.of<ChatProvider>(StaticData.navigatorKey.currentContext!,
              listen: false)
              .appendSingleChatMessage(singleChatMessage: responseData);
          // onSuccess!(responseData["object_type"] );
        }
      }
  }

  void socketErrorMethod({dynamic errorResponseData}) {
    if (errorResponseData != null) {
      if (errorResponseData["object_type"] == NetworkStrings.GET_MESSAGES_KEY) {
    /*    Provider.of<ChatProvider>(StaticData.navigatorKey.currentContext!,
            listen: false)
            .setChatData(chatDataList: null);*/
      }
    }
  }
}