import 'dart:io';

import 'package:customer_service_provider_hybrid/chat/model/chat_attachment_model.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as getImagePath;

import '../../services/network/network.dart';
import '../../services/socket_service.dart';
import '../../utils/app_navigation.dart';
import '../../utils/network_strings.dart';

class ChatAttachmentBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  ChatAttachmentModel? _chatAttachmentModel;
  String? imagePath;
  String? imageName;
  File? _userFileImage;

  void chatAttachmentBlocMethod({
    required BuildContext context,
    int? senderId,
    int? receiverId,
    String? attachment,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();
    //Form Data
    Map<String, dynamic> _formDataMap = {
      "sender_id": senderId,
      "receiver_id": receiverId,
      // "attachment": attachment
    };

    if (attachment != null) {
      _userFileImage = File(attachment);
      imagePath = _userFileImage!.path;
      imageName = getImagePath.basename(_userFileImage!.path);
      _formDataMap["attachment"] =
      await MultipartFile.fromFile(imagePath!, filename: imageName);
    }

    _formData = FormData.fromMap(_formDataMap);

    print("Chat Attachment Map");
    print({_formDataMap});
    _onFailure = () {
      AppNavigation.navigatorPop(context); // StopLoader
    };

    await _postRequest(
        endPoint: NetworkStrings.CHAT_ATTACHMENT_ENDPOINT, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _chatAttachmentResponseMethod(context: context, attachment: attachment, senderId: senderId, receiverId: receiverId);
    };
    _validateResponse();
  }

  //-------------------------- Post Request ----------------------------------

  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().postRequest(
        endPoint: endPoint,
        formData: _formData,
        context: context,
        onFailure: _onFailure,
        isHeaderRequire: true, isToast: false);
  }

  //-------------------------- Validate Response --------------------------
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
        response: _response,
        onSuccess: _onSuccess,
        onFailure: _onFailure,
      );
    }
  }

  void _chatAttachmentResponseMethod(
      {required BuildContext context, int? senderId, int? receiverId, String? attachment}) {
    //   try {
      _chatAttachmentModel = ChatAttachmentModel.fromJson(_response?.data);
      if(_chatAttachmentModel != null){
        print("CHAT ATTACHEMNT: ${_chatAttachmentModel}");
        _sendMessageEmitMethod(attachment: attachment, senderId: senderId, receiverId: receiverId);
      }
    //  } catch (error) {
    //  print(error);
    //  AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    // }
  }

  void _sendMessageEmitMethod({String? attachment, int? senderId, int? receiverId}) {
    SocketService.instance?.socketEmitMethod(
        eventName: NetworkStrings.SEND_MESSAGE_EVENT,
        eventParamaters: {
          "sender_id": senderId,
          "receiver_id": receiverId,
          "type": AppStrings.image,
          "message": attachment,
        });

    print("SEND MESSAGE" +
        {"sender_id": senderId,
          "receiver_id": receiverId,
          "type": AppStrings.image,
          "message": attachment,
        }.toString());
  }
}
