import 'package:customer_service_provider_hybrid/services/network/network.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/model/reviews_model.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReviewsListProvider with ChangeNotifier {
  Map<String, dynamic>? _queryParameters;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic reviewsListResponseData;

  ReviewsModel? get getReviewsList => _reviewsList;
  ReviewsModel? _reviewsList;
  bool? waitingStatus;

  ///Delete review locally
  void removeReview({required int index}) {
    _reviewsList?.data?.removeAt(index);
    notifyListeners();
  }

  ///Add review locally
  void addReview({ReviewsModelData? reviews}) {
    if (_reviewsList?.data != null || _reviewsList?.data?.isEmpty == true) {
      _reviewsList?.data?.insert(0, reviews);
    } else {
      Map<String, dynamic> data = {
        "status": 1,
        "message": "Successfully added review",
        "data": []
      };
      _reviewsList = ReviewsModel.fromJson(data);
      _reviewsList?.data?.add(reviews);
    }

    notifyListeners();
  }

  ///Edit review locally
  void editReview({int? reviewIndex, ReviewsModelData? reviews}) {
    _reviewsList?.data?[reviewIndex ?? 0] = reviews;

    notifyListeners();
  }

  Future<void> getReviewsListProviderMethod({
    required BuildContext context,
    int? companyId,
  }) async {
    _queryParameters = {"company_id": companyId};

    waitingStatus = true;

    _onFailure = () {
      print("REVIEWS FAILURE");
      waitingStatus = false;
      _reviewsList = null;
      notifyListeners();
    };

    await _getRequest(
        endPoint: NetworkStrings.REVIEWS_ENDPOINT, context: context);

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

  void _reviewsListResponseMethod({required BuildContext context}) {
    try {
      reviewsListResponseData = _response!.data;
      print("REVIEWS ${reviewsListResponseData}");
      if (reviewsListResponseData != null) {
        _reviewsList = ReviewsModel.fromJson(reviewsListResponseData);
      } else {
        _reviewsList = null;
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
