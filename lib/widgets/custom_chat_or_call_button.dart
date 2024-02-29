import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_fonts.dart';

class CustomChatOrCallButton extends StatelessWidget {
  Color? backgroundColor;
  String? icon, text;
  Function()? onTap;
  CustomChatOrCallButton(
      {Key? key, this.backgroundColor, this.icon, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.THEME_COLOR_PURPLE,
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  icon!,
                  color: AppColors.THEME_COLOR_WHITE,
                  scale: 3,
                ),
                SizedBox(width: 5.w),
                CustomText(
                  text: text,
                  fontColor: AppColors.THEME_COLOR_WHITE,
                  fontFamily: AppFonts.Roboto_Medium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
