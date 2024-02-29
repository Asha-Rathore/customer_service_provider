import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_circular_profile.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_slidable_widget.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

class ReviewsWidget extends StatelessWidget {
  String? image, name, review, rating;
  bool? enableSlider;
  final Function()? onTapDelete, onTapEdit;
  ReviewsWidget({
    Key? key,
    this.image,
    this.name,
    this.rating,
    this.review,
    this.enableSlider,
    this.onTapEdit,
    this.onTapDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSlidableWidget(
      isenable: enableSlider ?? true,
      onTapDelete: onTapDelete,
      onTapEdit: onTapEdit,
      child: CustomPadding(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_WHITE,
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.THEME_COLOR_LIGHT_GREY.withOpacity(0.6),
                offset: Offset(0, 1),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imageWidget(),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _nameAndRating(),
                      CustomSizeBox(),
                      _review(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return CustomCircularImageWidget(
      image: image,
      borderColor: AppColors.THEME_COLOR_PURPLE,
      height: 30.h,
      width: 30.h,
      borderWidth: 2,
    );
  }

  Widget _nameAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _name(),
        _rating(),
      ],
    );
  }

  Widget _name() {
    return CustomText(
      text: name,
      fontColor: AppColors.THEME_COLOR_PURPLE,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_SemiBold,
      fontSize: 16.sp,
    );
  }

  Widget _rating() {
    return Align(
      alignment: Alignment.topRight,
      child: Row(
        children: [
          Image.asset(
            AssetPath.STAR_ICON,
            scale: 4,
          ),
          SizedBox(width: 2.w),
          CustomText(
            text: rating,
            fontColor: AppColors.THEME_COLOR_BLACK,
            fontSize: 13.sp,
            textAlign: TextAlign.left,
            // fontweight: FontWeight.w400,
            fontFamily: AppFonts.Jost_Regular,
          ),
        ],
      ),
    );
  }

  Widget _review() {
    return CustomText(
      text: review,
      fontColor: AppColors.THEME_COLOR_LIGHT_GREY,
      fontSize: 13.sp,
      textAlign: TextAlign.left,
      // fontweight: FontWeight.w400,
      fontFamily: AppFonts.Jost_Regular,
    );
  }
}
