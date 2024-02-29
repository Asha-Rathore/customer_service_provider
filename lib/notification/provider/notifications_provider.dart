import 'package:customer_service_provider_hybrid/notification/model/notification_model.dart';
import 'package:customer_service_provider_hybrid/services/network/network.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NotificationsListProvider with ChangeNotifier {
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic notificationsListResponseData;

  NotificationsModel? get getNotificationsList => _notificationsList;
  NotificationsModel? _notificationsList;
  bool? waitingStatus;

  ///Delete Notification locally
  void removeNotification({required int index}) {
    _notificationsList?.data?.removeAt(index);
    notifyListeners();
  }

  Future<void> getNotificationsListProviderMethod({
    required BuildContext context,
  }) async {
    waitingStatus = true;

    _onFailure = () {
      print("REVIEWS FAILURE");
      waitingStatus = false;
      _notificationsList = null;
      notifyListeners();
    };

    await _getRequest(
        endPoint: NetworkStrings.NOTIFICATIONS_ENDPOINT, context: context);

    _onSuccess = () {
      _reviewsListResponseMethod(context: context);
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

  void _reviewsListResponseMethod({required BuildContext context}) {
    try {
      notificationsListResponseData = _response!.data;
      print("NOTIFICATIONS ${notificationsListResponseData}");
      if (notificationsListResponseData != null) {
        _notificationsList =
            NotificationsModel.fromJson(notificationsListResponseData);
      } else {
        _notificationsList = null;
      }
      waitingStatus = false;
      notifyListeners();
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    } finally {
      notifyListeners();
    }
  }
}
