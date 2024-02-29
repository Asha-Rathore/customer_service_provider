import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/custom_text.dart';

class SliderContainer extends StatelessWidget {
  String? packageName, price, duration, description;
  SliderContainer({Key? key, this.packageName, this.duration, this.price, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.THEME_COLOR_LIGHT_PINK,
              AppColors.THEME_COLOR_PINK,
            ],
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: _subscriptions(),
      ),
    );
  }

  Widget _subscriptions() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomSizeBox(height: 25.h),
          _packagesName(),
          CustomSizeBox(),
          _packagePrice(),
          CustomSizeBox(height: 15.h),
          _divider(thickness: 2, intent: 5.w),
          CustomSizeBox(),
          _benefitsText(),
          CustomSizeBox(),
          _divider(),
          CustomSizeBox(),
          _benefitsText(),
          CustomSizeBox(),
          _divider(),
          CustomSizeBox(),
          _benefitsText(),
          CustomSizeBox(),
        ],
      ),
    );
  }

  Widget _packagesName() {
    return CustomText(
      text: packageName,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontSize: 20.sp,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Roboto_Bold,
    );
  }

  Widget _packagePrice() {
    return RichText(
      text: TextSpan(
        text: "\$ ${price}/",
        style: TextStyle(
          fontSize: 23.sp,
          color: AppColors.THEME_COLOR_WHITE,
          decorationThickness: 1.2,
          // fontWeight: FontWeight.bold,
          fontFamily: AppFonts.Roboto_Bold,
        ),
        children: [
          TextSpan(
            text: duration,
            style: TextStyle(
              fontSize: 17.sp,
              color: AppColors.THEME_COLOR_WHITE,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.Roboto_Medium,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textScaleFactor: 1.01,
    );
  }

  Widget _benefitsText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AssetPath.TICK_ICON,
            scale: 3,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomText(
              text: description ?? AppStrings.LOREM_IPSUM_MEDIUM_TEXT,
              fontColor: AppColors.THEME_COLOR_WHITE,
              fontweight: FontWeight.w300,
              fontSize: 14.sp,
              textAlign: TextAlign.left,
              fontFamily: AppFonts.Roboto_Regular,
              maxLines: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider({double? thickness, double? intent}) {
    return Divider(
      color: AppColors.THEME_COLOR_WHITE,
      thickness: thickness ?? 0.5.h,
      indent: intent ?? 10.w,
      endIndent: intent ?? 10.w,
    );
  }
}
