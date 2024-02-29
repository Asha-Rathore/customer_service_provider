import 'dart:developer';
import 'dart:io';

import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/date_time_manager.dart';
import '../../widgets/custom_circular_profile.dart';
import '../../widgets/custom_text.dart';

class CustomChatWidget extends StatelessWidget {
  final String? messageType,
      receiverProfileImage,
      senderProfileImage,
      messageText,
      userType,
      name,
      time;
  final bool? isFileImage;

  const CustomChatWidget(
      {Key? key,
      this.messageType,
      this.name,
      this.receiverProfileImage,
      this.messageText,
      this.userType,
      this.isFileImage = false,
      this.time,
      this.senderProfileImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userType == AppStrings.receiver
        ? Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 55.h,
                  child: Column(
                    children: [
                      _customCircularProfileImageWidget(
                          imagePath: receiverProfileImage),
                      // SizedBox(height: 5.h),
                      // //_name(name),
                    ],
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: _customMessageBoxContainer(context: context),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 40.0, bottom: 10.0, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _customMessageBoxContainer(context: context),
                ),
                SizedBox(width: 6.w),
                Container(
                  width: 55.h,
                  child: Column(
                    children: [
                      _customCircularProfileImageWidget(
                          imagePath: senderProfileImage),
                      // SizedBox(height: 5.h),
                      // _name(name),

                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Widget _customMessageBoxContainer({BuildContext? context}) {
    return Align(
      alignment: (userType == AppStrings.receiver
          ? Alignment.topLeft
          : Alignment.topRight),
      child: _msgContainer(),
    );
  }

  Widget _msgContainer() {
    return Column(
      crossAxisAlignment: userType == AppStrings.receiver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        _name(),
        Container(
          padding: EdgeInsets.all(15.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5.r),
            ),
            color: AppColors.THEME_COLOR_SEARCH_BAR,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.e,
            crossAxisAlignment: messageType == AppStrings.receiver
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              messageType == AppStrings.text
                  ? CustomText(
                      text: messageText ?? " ",
                      fontColor: AppColors.THEME_COLOR_MEDIUM_GREY,
                      fontSize: 12.sp,
                      textAlign: TextAlign.start,
                      fontFamily: AppFonts.Jost_Regular,
                    )
                  : imageMessagWidget(imagePath: messageText),
              CustomSizeBox(),
              CustomText(
                text: DateTimeManager.timeAgoMethod(
                        createdDate: time ?? "2023-09-11T06:53:03.812Z",
                        isUtc: true) ??
                    "",
                fontColor: AppColors.THEME_COLOR_LIGHTEST_GREY,
                fontSize: 11.sp,
                textAlign: TextAlign.start,
                fontFamily: AppFonts.Jost_Light,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget imageMessagWidget({String? imagePath}) {
    return Align(
      alignment: Alignment.topRight,
      child: FadeInImage(
        height: 220.h,
        width: 220.w,
        // placeholder: const AssetImage(AssetPaths.loadingIcon,),
        image: FileImage(File(imagePath!)),
        fit: BoxFit.cover,
        placeholder: AssetImage(
          AssetPath.loadingIcon,
        ),
      ),
    );
  }

  Widget _name([text]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: CustomText(
        text: name ?? "",
        fontColor: AppColors.THEME_COLOR_PURPLE,
        fontSize: 12.sp,
        // fontweight: FontWeight.w500,
        fontFamily: AppFonts.Jost_SemiBold,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _customCircularProfileImageWidget({String? imagePath}) {
    return CustomCircularImageWidget(
      width: 40.h,
      height: 40.h,
      image: imagePath,
      borderColor: AppColors.THEME_COLOR_PURPLE,
      borderWidth: 2,
    );
  }
}
