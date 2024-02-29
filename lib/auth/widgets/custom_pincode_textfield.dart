import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../utils/app_colors.dart';

class CustomPinCodeTextField extends StatelessWidget {
  TextEditingController? controller;
  Function(String)? onComplete;
  CustomPinCodeTextField({this.controller, this.onComplete, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: _textStyle(),
      length: 6,
      obscureText: false,
      obscuringCharacter: '*',
      animationType: AnimationType.fade,
      pinTheme: _pinTheme(),
      cursorColor: AppColors.THEME_COLOR_PURPLE,
      animationDuration: const Duration(milliseconds: 300),
      textStyle: _textStyle(),
      enableActiveFill: true,
      controller: controller,
      keyboardType: TextInputType.number,
      onCompleted: onComplete,
      onChanged: (value) {
        print(value);
      },
      beforeTextPaste: (text) {
        print("Allowing to paste $text");
        return true;
      },
    );
  }

  PinTheme _pinTheme() {
    return PinTheme(
      shape: PinCodeFieldShape.box,
      activeColor: AppColors.THEME_COLOR_OFF_WHITE,
      activeFillColor: AppColors.THEME_COLOR_OFF_WHITE,
      inactiveFillColor: AppColors.THEME_COLOR_OFF_WHITE,
      inactiveColor: AppColors.THEME_COLOR_OFF_WHITE,
      selectedFillColor: AppColors.THEME_COLOR_OFF_WHITE,
      selectedColor: AppColors.THEME_COLOR_OFF_WHITE,
      borderRadius: BorderRadius.circular(17.r),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontSize: 16.sp,
      color: AppColors.THEME_COLOR_BLACK,
      fontFamily: AppFonts.Jost_Regular,
    );
  }
}
