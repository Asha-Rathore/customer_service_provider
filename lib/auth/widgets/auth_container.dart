import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_fonts.dart';

class AuthContainer extends StatelessWidget {
  String? text;
  Widget child;
  int? flex;
  AuthContainer({this.text, required this.child, this.flex, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return _formContainer();
    return Flexible(
      fit: FlexFit.loose,
      flex: flex ?? 1,
      child: CustomPadding(
        child: Container(
          // constraints: BoxConstraints.,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_WHITE,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: SingleChildScrollView(
            child: CustomPadding(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSizeBox(height: 20.h),
                  _text(),
                  CustomSizeBox(height: 20.h),
                  child,
                  CustomSizeBox(height: 25.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formContainer() {
    return Flexible(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19.0),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomSizeBox(height: 30.h),
                    _text(),
                    CustomSizeBox(height: 25.h),
                    child,
                    CustomSizeBox(height: 25.h),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _text() {
    return CustomText(
      text: text?.toUpperCase() ?? "",
      fontColor: AppColors.THEME_COLOR_BLACK,
      // fontweight: FontWeight.w900,
      fontFamily: AppFonts.Jost_ExtraBold,
      fontSize: 17.sp,
    );
  }
}
