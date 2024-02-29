import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_padding.dart';
import '../../widgets/custom_text.dart';

class PushNotification extends StatelessWidget {
  final bool? enable;
  final Function(bool)? onChanged;
  PushNotification({super.key, this.enable = true, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.THEME_COLOR_WHITE,
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.THEME_COLOR_LIGHT_GREY.withOpacity(0.6),
            offset: Offset(0, 1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: AppPadding.DEFAULT_BUTTON_HORIZONTAL_PADDING.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _text(),
            _switch(),
          ],
        ),
      ),
    );
  }

  Widget _text() {
    return CustomText(
      text: AppStrings.PUSH_NOTIFICATIONS,
      fontColor: AppColors.THEME_COLOR_BLACK,
      fontSize: 17.sp,
      fontweight: FontWeight.w600,
      fontFamily: AppFonts.Roboto_Regular,
    );
  }

  Widget _switch() {
    return Transform.scale(
      scale: 0.7,
      child: CupertinoSwitch(
        value: enable!,
        activeColor: AppColors.THEME_COLOR_PURPLE,
        onChanged: onChanged,
        // onChanged: (bool value) {
        //   setState(() {
        //     enable = value;
        //   });
        // },
      ),
    );
  }
}
