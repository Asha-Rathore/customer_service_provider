import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_circular_profile.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_slidable_widget.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_fonts.dart';
import '../../utils/date_time_manager.dart';

class NotificationContainer extends StatelessWidget {
  String? title, detail, date;
  final bool? isSlideEnable;
  final Function()? onTapDelete, onTap;
  NotificationContainer({
    Key? key,
    required this.title,
    required this.detail,
    required this.date,
    this.isSlideEnable,
    this.onTapDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSlidableWidget(
      showEditIcon: false,
      isenable: isSlideEnable,
      onTapDelete: onTapDelete,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
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
        ),
      ),
    );
  }

  Widget _chatDetail() {
    return Padding(
      padding:
          EdgeInsets.only(top: 20.h, bottom: 20.h, left: 20.w, right: 10.w),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _companyName(),
                    _date(),
                  ],
                ),
                CustomSizeBox(height: 5.h),
                _detail()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _companyName() {
    return CustomText(
      text: title,
      fontColor: AppColors.THEME_COLOR_PURPLE,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_SemiBold,
    );
  }

  Widget _detail() {
    return CustomText(
      text: detail,
      fontColor: AppColors.THEME_COLOR_BLACK,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_Medium,
      fontSize: 11.sp,
      textAlign: TextAlign.left,
    );
  }

  Widget _date() {
    return Align(
      alignment: Alignment.topRight,
      child: CustomText(
        text: DateTimeManager.timeAgoMethod(
            createdDate: date ?? "2023-09-11T06:53:03.812Z",
            isUtc: true) ??
            "",
        fontColor: AppColors.THEME_COLOR_BLACK,
        // fontweight: FontWeight.bold,
        fontFamily: AppFonts.Jost_Medium,
        fontSize: 11.sp,
      ),
    );
  }
}
