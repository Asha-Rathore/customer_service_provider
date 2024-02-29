import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/app_padding.dart';
import '../utils/app_shadows.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? fontSize, width, verticalPadding;
  final Color? textColor;
  final Color? backgroundColor;
  final double? horizontalPadding;
  String? fontFamily;
  void Function()? onTap;
  double? borderCircular;
  CustomButton(
      {required this.onTap,
      required this.text,
      this.verticalPadding,
      this.backgroundColor,
      this.width,
      this.fontSize,
      this.textColor,
        this.horizontalPadding,
      this.borderCircular,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.THEME_COLOR_PURPLE,
          borderRadius: BorderRadius.all(
            Radius.circular(borderCircular ?? 40),
          ),
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
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? AppPadding.BUTTON_VERTICAL_PADDING.h,
              horizontal: horizontalPadding ?? AppPadding.DEFAULT_BUTTON_HORIZONTAL_PADDING.w),
          child: CustomText(
            text: text,
            fontColor: textColor ?? AppColors.THEME_COLOR_WHITE,
            fontSize: fontSize ?? 17.sp,
            // fontweight: FontWeight.w600,
            fontFamily: fontFamily ?? AppFonts.Jost_SemiBold,
          ),
        ),
      ),
    );
  }
}
