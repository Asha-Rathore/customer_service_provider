import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class CustomAuthRichTextWidget extends StatelessWidget {
  final String? normalText, linkText;
  final VoidCallback? onTap;
  final Color? linkTextColor;

  const CustomAuthRichTextWidget(
      {this.normalText, this.linkText, this.onTap, this.linkTextColor});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: normalText,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.THEME_COLOR_WHITE,
            decorationThickness: 1.2,
            // fontWeight: FontWeight.w600,
            fontFamily: AppFonts.Jost_SemiBold,
            decorationColor: AppColors.THEME_COLOR_WHITE,
          ),
          children: [
            TextSpan(
              text: linkText,
              style: TextStyle(
                fontSize: 14.sp,
                color: linkTextColor,
                decoration: TextDecoration.underline,
                decorationColor: linkTextColor,
                // fontWeight: FontWeight.w600,
                fontFamily: AppFonts.Jost_SemiBold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
        textAlign: TextAlign.center,
        textScaleFactor: 1.01,
      ),
    );
  }
}
