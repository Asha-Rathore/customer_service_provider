import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_shadows.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_shimmer_widget.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_fonts.dart';
import 'custom_extended_image.dart';


class CustomHomeContainer extends StatelessWidget {
  final String image, mainText, description, placeHolderImage;
  final String? subText, subTextImage;
  final bool? showHeartIcon, isFilled, isViewAsset, shimmerEnable;
  final VoidCallback? onHeartTap;

  CustomHomeContainer({Key? key,
    required this.image,
    required this.mainText,
    this.subText,
    this.subTextImage,
    required this.description,
    this.showHeartIcon = false,
    this.isFilled = false,
    this.isViewAsset = true,
    this.shimmerEnable = false,
    required this.placeHolderImage,
    this.onHeartTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.THEME_COLOR_LIGHT_GREY.withOpacity(0.6),
            offset: Offset(0, 1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
        color: AppColors.THEME_COLOR_WHITE,
      ),
      child: shimmerEnable == false ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [_imageWidget(), _companyDetail()],
      ) : CustomShimmerWidget(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_imageWidget(), _companyDetail()],
      )),
    );
  }

  Widget _imageWidget() {
    return Expanded(
        child: SizedBox(
          width: 1.0.sw,
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r)),
              child: CustomExtendedImageWidget(
                imagePath: image,
                isFile: false,
                isClipped: false,
                isViewFallBackAsset: isViewAsset,
                placeHolderImagePath: placeHolderImage,
                // placeHolderImagePath: AssetPath.USER_ICON,
              ),),
        ));
  }

  Widget _companyDetail() {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Container(
        color: AppColors.THEME_COLOR_WHITE,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            showHeartIcon!
                ? SizedBox(
              height: 20.h,
                  child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Expanded(child: _title()), _heartIcon()],
            ),
                )
                : _title(),
            _companyName(),
            CustomSizeBox(height: 5.h),
            _description(),
            // CustomSizeBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  Widget _title(){
    return CustomText(
      textAlign: TextAlign.left,
      text: mainText,
      fontColor: AppColors.THEME_COLOR_BLACK,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_Bold,
      fontSize: 13.sp,
      maxLines: 1,
    );
  }

  Widget _companyName() {
    return subText != null ?
    SizedBox(
      height: 20.h,
      child: Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: Image.asset(
                subTextImage ?? AssetPath.BUILDING_ICON,
                height: 10.h,
                color: AppColors.THEME_COLOR_PURPLE,
              ),
            ),
            SizedBox(width: 5.w),
            CustomText(
              text: subText,
              fontColor: AppColors.THEME_COLOR_PURPLE,
              fontSize: 12.sp,
              // fontweight: FontWeight.w600,
              fontFamily: AppFonts.Jost_Medium,
            ),
          ],
        ),
      ),
    ):Container();
  }

  Widget _description() {
    return SizedBox(
      height: 20.h,
      child: CustomText(
        text: description,
        fontColor: AppColors.THEME_COLOR_MEDIUM_GREY,
        fontSize: 12.sp,
        textAlign: TextAlign.left,
        fontFamily: AppFonts.Jost_Medium,
        maxLines: 2,

      ),
    );
  }

  Widget _heartIcon() {
    return GestureDetector(
      onTap: onHeartTap,
      child: Icon(
        isFilled! ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: AppColors.THEME_COLOR_RED,
        size: 22.sp,
      ),
    );
  }
}



