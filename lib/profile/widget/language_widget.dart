import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageWidget extends StatefulWidget {
  String? text;
  Function()? onTapAdd;
  Function()? onTapDelete;
  Widget? child;
  LanguageWidget({
    super.key,
    this.text,
    this.onTapAdd,
    this.onTapDelete,
    this.child,
  });

  @override
  State<LanguageWidget> createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        children: [_langauge(), 
        SizedBox(height: 8.h,),
        widget.child!],
      ),
    );
  }

  Widget _langauge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _text(),
        // Spacer(),
        Row(
          children: [
            _icon(Icons.add_circle_rounded, widget.onTapAdd),
            SizedBox(width: 5.w),
            _icon(Icons.remove_circle_rounded, widget.onTapDelete),
          ],
        ),
      ],
    );
  }

  Widget _text() {
    return CustomText(
      text: widget.text,
      fontColor: AppColors.THEME_COLOR_LIGHT_GREY,
      fontFamily: AppFonts.Jost_Medium,
      underlined: true,
      fontSize: 14.sp,
    );
  }

  Widget _icon(icon, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: AppColors.THEME_COLOR_PURPLE,
        size: 30,
      ),
    );
  }
}