import 'package:customer_service_provider_hybrid/widgets/custom_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/custom_confirmation_dialog.dart';
import '../widgets/custom_error_widget.dart';
import '../widgets/custom_review_dialog.dart';
import 'app_colors.dart';
import 'app_strings.dart';
import 'asset_paths.dart';

class AppDialogs {
  static void showToast({String? message}) {
    Fluttertoast.showToast(
      msg: message ?? "",
      textColor: AppColors.THEME_COLOR_WHITE,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  Future showSuccessDialog({context, successMsg, onTap}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomSuccessDialog(successMsg: successMsg, onTap: onTap);
        });
  }

  Future showRatingDialog(
      {BuildContext? context,
      int? companyId,
      bool? isEdit,
      double? rating,
        int? reviewId,
        int? reviewIndex,
      String? feedback}) {
    return showDialog(
        context: context!,
        builder: (context) {
          return RateReviewScreen(
            companyId: companyId,
            isEdit: isEdit,
            rating: rating,
            feedback: feedback,
            reviewId: reviewId,
            reviewIndex: reviewIndex,
          );
        });
  }

  Future showCustomConfirmationDialog(context,
      {String? title,
      String? description,
      String? button1Text,
      String? button2Text,
      bool? isDescriptionVisible,
      Function()? onTapYes,
      Function()? onTapNo}) {
    return showDialog(
      context: context,
      builder: (context) {
        return CustomConfirmationDialog(
          title: title,
          description: description,
          button1Text: button1Text,
          button2Text: button2Text,
          onTapYes: onTapYes,
          onTapNo: onTapNo,
          isDescriptionVisible: isDescriptionVisible,
        );
      },
    );
  }

  static void progressAlertDialog({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: AppColors.THEME_COLOR_PURPLE,
                color: AppColors.THEME_COLOR_WHITE,
              ),
            ),
          );
        });
  }

  static Widget circularProgressWidget() {
    return CircularProgressIndicator(
      color: AppColors.THEME_COLOR_PURPLE,
    );
  }
}
