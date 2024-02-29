import 'dart:developer';

// import 'package:country_picker/country_picker.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneNumberTextField extends StatelessWidget {
  const PhoneNumberTextField({
    Key? key,
    this.controller,
    this.isSuffixIcon,
    this.showDropDown,
    this.showFlag,
    this.cursorColor,
    this.validator,
    this.backgroundColor,
    this.hintColor,
    this.borderColor,
    this.isBorder,
    this.isReadOnly = false,
    this.textColor = AppColors.THEME_COLOR_WHITE,
    this.onchange,
    this.countryCode,
    this.suffixIcon,
    this.isEnabled,
    this.showDialogue,
    this.onTapSuffixIcon,

    // this.onChangeCountry
  }) : super(key: key);
  final Color? backgroundColor;
  final bool? isEnabled;
  final Color? hintColor;
  final bool? showDialogue;
  final IconData? suffixIcon;

  final String? countryCode;
  final Color? borderColor;
  final Color? textColor;
  final bool? showFlag;
  final bool? showDropDown;
  final bool? isBorder, isReadOnly;
  final TextEditingController? controller;
  final Function()? onTapSuffixIcon;
  final Color? cursorColor;
  final Future<String?> Function(PhoneNumber?)? validator;
  final Future<String?> Function(PhoneNumber?)? onchange;
  final bool? isSuffixIcon;

  // final Function(Country)? onChangeCountry;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
        onTapSuffixIcon: onTapSuffixIcon,
        isSuffixIcon: isSuffixIcon,
        suffixIconColor: AppColors.THEME_COLOR_DARK_PURPLE,
        suffixIcon: suffixIcon,
        showDialogue: showDialogue ?? false,
        showCountryFlag: showFlag ?? false,
        showDropdownIcon: showDropDown ?? false,
        cursorColor: cursorColor,
        initialCountryCode: countryCode == "" || countryCode == null
            ? AppStrings.defaultCountryCode
            : countryCode,
        invalidNumberMessage: "Please enter valid phone number",
        validator: validator,
        autovalidateMode: AutovalidateMode.disabled,
        controller: controller,
        flagsButtonPadding: const EdgeInsets.only(left: 10),
        readOnly: isReadOnly ?? false,
        emptyNumberMessage: "Phone number can't be empty",
        enabled: isEnabled ?? false,
        dropdownTextStyle: TextStyle(
          fontSize: 14.sp,
          color: AppColors.THEME_COLOR_BLACK,
          fontFamily: AppFonts.Jost_Medium,
        ),
        dropdownIcon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.THEME_COLOR_BLACK,
        ),
        // keyboardType: TextInputType.none,
        decoration: InputDecoration(
          prefixIconColor: AppColors.THEME_COLOR_WHITE,
          iconColor: AppColors.THEME_COLOR_WHITE,
          hintText: AppStrings.PHONE_NUMBER,
          counter: const SizedBox.shrink(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: BorderSide(
              // width: 0,
              color: borderColor ?? AppColors.THEME_COLOR_OFF_WHITE,
              style: isBorder == true ? BorderStyle.solid : BorderStyle.none,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: BorderSide(
              // width: 1,
              color: borderColor ?? AppColors.THEME_COLOR_OFF_WHITE,
              style: isBorder == true ? BorderStyle.solid : BorderStyle.none,
            ),
          ),
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.THEME_COLOR_LIGHT_GREY,
            fontFamily: AppFonts.Jost_Medium,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: BorderSide(
              // width: 1,
              color: borderColor ?? AppColors.THEME_COLOR_OFF_WHITE,
              style: isBorder == true ? BorderStyle.solid : BorderStyle.none,
            ),
          ),
          fillColor: backgroundColor ?? AppColors.THEME_COLOR_OFF_WHITE,
          filled: true,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          errorMaxLines: 2,
          errorStyle: const TextStyle(
              color: AppColors.THEME_COLOR_RED,
              height: 1,
              fontFamily: AppFonts.Jost_Regular,
              fontSize: 12),
        ),
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.THEME_COLOR_BLACK,
          fontFamily: AppFonts.Jost_Medium,
        )
        // onChanged: onchange,
        // onCountryChanged:onChangeCountry
        );
  }
}
