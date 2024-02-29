import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_text.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? errorImagePath, errorText;
  final double? imageSize;
  final Color? imageColor;

  CustomErrorWidget(
      {this.errorImagePath, this.errorText, this.imageSize, this.imageColor});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorImagePath != null
                ? Image.asset(
                    errorImagePath!,
                    width: imageSize ?? 70.h,
                    color: imageColor,
                  )
                : Container(),
            SizedBox(
              height: 12.0,
            ),
            CustomText(
              text: errorText,
              fontSize: 16.sp,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              fontColor: AppColors.THEME_COLOR_BLACK,
              //fontweight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
