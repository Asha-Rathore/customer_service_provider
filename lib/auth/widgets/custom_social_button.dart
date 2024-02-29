import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_padding.dart';
import '../../utils/app_size.dart';

class CustomSocialLoginButton extends StatefulWidget {
  final Function() onTap;
  final String title, iconPath;
  final double fontSize, iconScale, horizontalPadding, width;
  final double? innerHorizontalPadding, innerVerticalPadding;
  final Color? backgroundColor, fontColor;

  const CustomSocialLoginButton(
      {required this.onTap,
      required this.title,
      this.fontSize = 16,
      this.iconScale = 3.8,
      this.width = 1,
      required this.iconPath,
      this.backgroundColor,
      this.horizontalPadding = AppPadding.DEFAULT_HORIZONTAL_PADDING,
      this.fontColor = AppColors.THEME_COLOR_WHITE,
      this.innerVerticalPadding,
      this.innerHorizontalPadding});

  @override
  State<CustomSocialLoginButton> createState() =>
      _CustomSocialLoginButtonState();
}

class _CustomSocialLoginButtonState extends State<CustomSocialLoginButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: widget.width.sw,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.innerVerticalPadding ??
                  AppPadding.BUTTON_VERTICAL_PADDING,
              horizontal: widget.innerHorizontalPadding ?? 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                widget.iconPath,
                scale: widget.iconScale,
                color: widget.fontColor,
              ),
              SizedBox(width: 10.w),
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.fontColor,
                  fontSize: widget.fontSize.sp,
                  fontFamily: AppFonts.Jost_SemiBold,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
