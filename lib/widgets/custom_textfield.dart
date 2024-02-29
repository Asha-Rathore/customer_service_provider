import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class CustomTextField extends StatefulWidget {
  void Function()? onPrefixTap;
  void Function()? onTap, onTapSuffix;
  String? prefxicon;
  bool? isSuffixIcon;
  TextInputType? keyboardType;
  double? prefixRIghtPadding, sufixRIghtPadding, scale, borderRadius, suffixScale;
  bool? isDataFill;
  int? lines;
  bool readOnly, divider, label;
  bool isPasswordField;
  Color? color, eyeColor;
  String? suffixIcon;
  EdgeInsetsGeometry? contentPadding;
  final String hint;
  final double? fontsize, width;
  final bool? obscureText;
  final Color? prefixIconColor;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  TextEditingController? controller;
  String? Function(String?)? validator;
  void Function(String)? onchange;
  final void Function()? onclick;
  List<TextInputFormatter>? inputFormatters;
  CustomTextField({
    Key? key,
    this.onPrefixTap,
    this.prefxicon,
    this.prefixRIghtPadding,
    this.sufixRIghtPadding,
    this.isSuffixIcon,
    this.lines,
    this.obscureText = false,
    this.isPasswordField = false,
    required this.hint,
    this.fontsize,
    this.isDataFill = false,
    this.width,
    this.suffixIcon,
    this.prefixIconColor,
    this.contentPadding,
    this.onclick,
    this.controller,
    this.validator,
    this.scale,
    this.onchange,
    this.onTap,
    this.keyboardType,
    this.readOnly = false,
    this.divider = true,
    this.label = true,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.borderRadius,
    this.onTapSuffix,
    this.suffixScale,
  }) : super(key: key);
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool textVisible = true;
  bool isVisible = true;

  @override
  void initState() {
    textVisible = widget.isPasswordField;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // focusNode: _focusNode,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      textInputAction: TextInputAction.done,
      keyboardType: widget.keyboardType,
      onChanged: widget.onchange,
      validator: widget.validator,
      obscureText: textVisible,
      cursorColor: AppColors.THEME_COLOR_PURPLE,
      controller: widget.controller,
      maxLines: widget.lines ?? 1,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofocus: false,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: widget.inputFormatters,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      style: _textStyle(),
      decoration: InputDecoration(
        fillColor: AppColors.THEME_COLOR_OFF_WHITE,
        filled: true,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        // contentPadding: widget.prefxicon == null
        //     ? EdgeInsets.symmetric(vertical: 6.sp, horizontal: 18.sp)
        //     : widget.contentPadding ?? null,
        hintText: widget.hint,
        hintStyle: _hintStyle(),
        // border: InputBorder.none,
        border: _outLineInputBorder(),
        focusedBorder: _outLineInputBorder(),
        enabledBorder: _outLineInputBorder(),
        errorBorder: _outLineInputBorder(),
        focusedErrorBorder: _outLineInputBorder(),
        disabledBorder: _outLineInputBorder(),
        isDense: true,
        errorStyle: const TextStyle(overflow: TextOverflow.visible,color: AppColors.THEME_COLOR_RED,fontSize: 12,fontFamily: AppFonts.Jost_Regular),
        errorMaxLines: 3,
        prefixIcon: widget.prefxicon != null
            ? Padding(
                padding: EdgeInsets.only(
                    left: widget.prefixRIghtPadding ?? 15.w, right: 5.w),
                child: Image.asset(
                  widget.prefxicon!,
                  // height: 20.h,
                  width: 22.w,
                  color: AppColors.THEME_COLOR_PURPLE,
                  scale: widget.scale ?? 3.sp,
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(),
        suffixIcon: widget.isPasswordField
            ? _passwordSuffixIconWidget()
            : widget.isSuffixIcon == true
                ? _suffixIconWidget()
                : null,
      ),
    );
  }

  OutlineInputBorder _outLineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 40),
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.THEME_COLOR_OFF_WHITE,
        style: BorderStyle.none,
      ),
    );
  }

  TextStyle _hintStyle() {
    return TextStyle(
      fontSize: widget.fontsize ?? 14.sp,
      color: AppColors.THEME_COLOR_LIGHT_GREY,
      fontFamily: AppFonts.Jost_Medium,
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontSize: widget.fontsize ?? 14.sp,
      color: AppColors.THEME_COLOR_BLACK,
      fontFamily: AppFonts.Jost_Medium,
    );
  }

  Widget _suffixIconWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: widget.onTapSuffix,
        child: Image.asset(
          widget.suffixIcon!,
          scale: widget.suffixScale ?? 2.7.sp,
        ),
      ),
    );
  }

  GestureDetector _passwordSuffixIconWidget() {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: Icon(
          isVisible ? Icons.visibility_off : Icons.visibility,
          color: AppColors.THEME_COLOR_SUFFIX_GREY,
          size: 22.sp,
        ),
      ),
      onTap: () {
        setState(() {
          isVisible = !isVisible;
          textVisible = !textVisible;
        });
      },
    );
  }
}
