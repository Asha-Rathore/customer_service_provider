import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/asset_paths.dart';

class CustomSearchBar extends StatefulWidget {
  String? hintText;
  TextEditingController? controller;
  TextInputType? keyboardType;
  final FocusNode? myFocusNode;
  final Function(String?)? onChange;

  CustomSearchBar({
    this.hintText,
    this.controller,
    this.myFocusNode,
    this.keyboardType,
    this.onChange,
  });
  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return textFormField();
  }

  TextFormField textFormField() {
    return TextFormField(
      focusNode: widget.myFocusNode,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      style: _textFormFieldTextStyle(),
      decoration: _inputOutlineDecorationWidget(),
      onChanged: widget.onChange,
    );
  }

  TextStyle _textFormFieldTextStyle() {
    return TextStyle(fontSize: 12.sp, color: AppColors.THEME_COLOR_BLACK);
  }

  InputDecoration _inputOutlineDecorationWidget() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 18.w),
      hintText: widget.hintText,
      fillColor: AppColors.THEME_COLOR_SEARCH_BAR,
      filled: true,
      hintStyle: TextStyle(
        color: AppColors.THEME_COLOR_LIGHT_GREY,
        fontSize: 12.sp,
        fontFamily: AppFonts.Jost_Medium,
      ),
      border: _outLineInputBorder(),
      focusedBorder: _outLineInputBorder(),
      enabledBorder: _outLineInputBorder(),
      prefixIcon: Container(
        height: 25,
        margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
        padding: EdgeInsets.only(right: 5.w),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: AppColors.THEME_COLOR_LIGHT_GREY),
          ),
        ),
        child: Image.asset(
          AssetPath.SEARCH_ICON,
          height: 20.h,
          width: 22.w,
          scale: 3.sp,
        ),
      ),
    );
  }

  OutlineInputBorder _outLineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.THEME_COLOR_OFF_WHITE,
        style: BorderStyle.none,
      ),
    );
  }
}
