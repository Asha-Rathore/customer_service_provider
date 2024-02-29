import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/custom_text.dart';

class CustomPaymentCards extends StatefulWidget {
  final int? optionValue;
  final int? groupValue;
  final Function(dynamic)? onChanged;
  String? leading, title;
  final Function()? onTap;
  final bool? slidableEnable;
  CustomPaymentCards(
      {Key? key,
      this.title,
      this.slidableEnable,
      this.leading,
      this.groupValue,
      this.onChanged,
      this.onTap,
      this.optionValue})
      : super(key: key);

  @override
  State<CustomPaymentCards> createState() => _CustomPaymentCardsState();
}

class _CustomPaymentCardsState extends State<CustomPaymentCards> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.THEME_COLOR_OFF_WHITE,
        borderRadius: BorderRadius.all(
          Radius.circular(40.r),
        ),
      ),
      child: Center(
        child: Padding(
            padding: EdgeInsets.only(left: 22.w, right: 12.w),
            child: Row(
              children: [
                Image.asset(widget.leading!, scale: 3.w),
                SizedBox(width: 14.w),
                CustomText(
                  text: widget.title,
                  fontColor: AppColors.THEME_COLOR_LIGHT_GREY,
                  fontSize: 12.sp,
                  fontFamily: AppFonts.Jost_Regular,
                ),
                Spacer(),
                Radio(
                  activeColor: AppColors.THEME_COLOR_GREY,
                  value: widget.optionValue,
                  groupValue: widget.groupValue,
                  onChanged: widget.onChanged,
                ),
              ],
            )),
      ),
    );
  }
}
