import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_shadows.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_circular_profile.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_fonts.dart';
import '../../utils/asset_paths.dart';

class ChatContainer extends StatelessWidget {
  String? image, companyName, detail, time;
  ChatContainer({
    Key? key,
    required this.image,
    required this.companyName,
    required this.detail,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, left: 20.w, right: 20.w, top: 9.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: AppColors.THEME_COLOR_WHITE,
          boxShadow: [
            BoxShadow(
              color: AppColors.THEME_COLOR_LIGHT_GREY.withOpacity(0.6),
              offset: Offset(0, 1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: _chatDetail(),
      ),
    );
  }

  Widget _chatDetail() {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Row(
        children: [
          _imageWidget(),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _companyName(),
                    _time(),
                  ],
                ),
                CustomSizeBox(height: 5.h),
                detail == "Photo" ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _cameraIcon(),
                    SizedBox(width: 5.w),
                    _detail()
                  ],
                ) : _detail()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return CustomCircularImageWidget(
      image: image,
      borderColor: AppColors.THEME_COLOR_PURPLE,
    );
  }

  Widget _companyName() {
    return CustomText(
      text: companyName,
      fontColor: AppColors.THEME_COLOR_PURPLE,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_SemiBold,
    );
  }

  Widget _cameraIcon(){
    return Image.asset(
      AssetPath.CAMERA_ICON,
      color: AppColors.THEME_COLOR_BLACK,
      scale: 5,
    );
  }

  Widget _detail() {
    return CustomText(
      text: detail,
      fontColor: AppColors.THEME_COLOR_BLACK,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_SemiBold,
      fontSize: 11.sp,
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _time() {
    return Align(
      alignment: Alignment.topRight,
      child: CustomText(
        text: time,
        fontColor: AppColors.THEME_COLOR_BLACK,
        // fontweight: FontWeight.bold,
        fontFamily: AppFonts.Jost_SemiBold,
        fontSize: 11.sp,
      ),
    );
  }
}
