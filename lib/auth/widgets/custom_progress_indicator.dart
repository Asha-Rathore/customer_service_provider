import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../utils/app_colors.dart';

class CustomProgressIndicator extends StatelessWidget {
  int count;
  CustomProgressIndicator({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.THEME_COLOR_LIGHT_PURPLE,
      ),
      child: SimpleCircularProgressBar(
        mergeMode: true,
        animationDuration: count,
        backColor: AppColors.THEME_COLOR_LIGHT_PURPLE,
        progressColors: const [AppColors.THEME_COLOR_WHITE],
        fullProgressColor: AppColors.THEME_COLOR_WHITE,
        backStrokeWidth: 2.w,
        progressStrokeWidth: 1.w,
        onGetText: (double value) {
          return Text(
            "00:${count > 9 ? count : "0$count"} ",
            style: TextStyle(
              color: AppColors.THEME_COLOR_WHITE,
              fontWeight: FontWeight.w300,
              fontSize: 17.sp,
            ),
          );
        },
      ),
    );
  }
}
