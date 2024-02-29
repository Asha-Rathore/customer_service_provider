import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_card_dialog.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_cross_icon.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../utils/asset_paths.dart';

class CustomSuccessDialog extends StatelessWidget {
  String successMsg;
  Function() onTap;
  CustomSuccessDialog({Key? key, required this.successMsg, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCardDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _titleAndCrossIcon(),
          CustomSizeBox(height: 23.h,),
          _successIcon(),
          CustomSizeBox(
            height: 12.h,
          ),
          _successText(),
          CustomSizeBox(height: 12.h,),
          _button(),
        ],
      ),
    );
  }

  Widget _titleAndCrossIcon() {
    return Container(
      width: 1.sw,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 5.0),
                  child: _title())),
          Align(
            alignment: Alignment.topRight,
              child: Image.asset(
                AssetPath.CROSS_ICON,
                height: 23.h,
              ),),
        ],
      ),
    );
  }

  Widget _successIcon() {
    return Container(
      width: 80.h,
      height: 80.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.THEME_COLOR_PURPLE
      ),
      child: Image.asset(
        AssetPath.TICK_ICON,
        height: 65.h,
        color: AppColors.THEME_COLOR_WHITE,
      ),
    );
  }

  Widget _title() {
    return CustomText(
      text: AppStrings.SUCCESSFUL,
      fontColor: AppColors.THEME_COLOR_BLACK,
      fontweight: FontWeight.w900,
      fontSize: 17.sp,
    );
  }

  Widget _successText() {
    return CustomText(
      text: successMsg,
      fontColor: AppColors.THEME_COLOR_BLACK,
      fontweight: FontWeight.w400,
      fontSize: 14.sp,
      // fontSize: 17.sp,
    );
  }

  Widget _button() {
    return CustomButton(onTap: onTap, text: AppStrings.CONTINUE);
  }
}
