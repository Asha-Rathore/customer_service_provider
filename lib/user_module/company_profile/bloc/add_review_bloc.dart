import 'package:customer_service_provider_hybrid/user_module/company_profile/model/reviews_model.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/provider/reviews_list_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/network/network.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/network_strings.dart';
import '../../../utils/static_data.dart';

class AddReviewBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  dynamic reviewResponseData;
  ReviewsListProvider? _reviewsListProvider;

  void addReviewBlocMethod(
      {required BuildContext context,
      required VoidCallback setProgressBar,
      int? companyId,
      double? rating,
      String? feedBack,
      bool? isEdit,
      int? reviewId,
      int? reviewIndex}) async {
    _reviewsListProvider = context.read<ReviewsListProvider>();
    setProgressBar();

    print("Add Review Map:${reviewIndex}");

    _formData = FormData.fromMap({
      if (isEdit!) "review_id": reviewId,
      "company_id": companyId,
      "rating": rating,
      "feedback": feedBack,
    });

    _onFailure = () {
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.ADD_REVIEW_ENDPOINT, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _addReviewResponseMethod(
          context: context, isEdit: isEdit, reviewIndex: reviewIndex);
    };

    _validateResponse();
  }

  ////////////////// Post Request /////////////////////////////////////////
  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    //print("post request");
    _response = await Network().postRequest(
        formData: _formData,
        endPoint: endPoint,
        context: context,
        onFailure: _onFailure,
        isHeaderRequire: true);
  }

  ////////////////// Validate Response ////////////////////////////////////
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _addReviewResponseMethod(
      {required BuildContext context,
      Function(ReviewsModelData?)? onApiSuccess,
      bool? isEdit,
      int? reviewIndex}) {
    // try {
    reviewResponseData = _response!.data;
    if (reviewResponseData != null) {
      // AppNavigation.navigatorPop(context);
      AppNavigation.navigatorPop(StaticData.navigatorKey.currentContext!);
      AppDialogs().showSuccessDialog(
          context: context,
          successMsg: AppStrings.YOUR_FEEDBACK_HAS_BEEN_POSTED,
          onTap: () {
            // onApiSuccess!(
            //     ReviewsModelData.fromJson(reviewResponseData['data'][0]));

            if (isEdit == true && reviewIndex != null) {
              _reviewsListProvider?.editReview(
                 reviewIndex: reviewIndex,
                  reviews: ReviewsModelData.fromJson(reviewResponseData['data']));
            } else {
              _reviewsListProvider?.addReview(
                  reviews:
                      ReviewsModelData.fromJson(reviewResponseData['data']));
            }

            AppNavigation.navigatorPop(StaticData.navigatorKey.currentContext!);
          });
    }

    // } catch (error) {
    //   AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    // }
  }
}
