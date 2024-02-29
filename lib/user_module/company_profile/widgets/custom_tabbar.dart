import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/custom_text.dart';

class CustomTabBar extends StatefulWidget {
  final TabController tabController;
  final String firstTabText, secTabText;
  const CustomTabBar({
    Key? key,
    required this.tabController,
    required this.firstTabText,
    required this.secTabText,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  Color _firstTextcolor = AppColors.THEME_COLOR_PURPLE;
  Color _secTextcolor = AppColors.THEME_COLOR_LIGHT_GREY;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (data) {
        if (data == 0) {
          setState(() {
            _firstTextcolor = AppColors.THEME_COLOR_PURPLE;
            _secTextcolor = AppColors.THEME_COLOR_LIGHT_GREY;
          });
        } else if (data == 1) {
          setState(() {
            _firstTextcolor = AppColors.THEME_COLOR_LIGHT_GREY;
            _secTextcolor = AppColors.THEME_COLOR_PURPLE;
          });
        }
      },
      controller: widget.tabController,
      labelColor: AppColors.THEME_COLOR_PURPLE,
      unselectedLabelColor: AppColors.THEME_COLOR_GREY,
      indicatorColor: AppColors.THEME_COLOR_TRANSPARENT,
      labelPadding: EdgeInsets.zero,
      tabs: [
        Tab(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                    color: AppColors.THEME_COLOR_LIGHT_GREY,
                    width: 1,
                    style: BorderStyle.solid),
              ),
            ),
            child: Row(
              children: [
                SizedBox(),
                Spacer(),
                _customTabs(
                  text: widget.firstTabText,
                  textAlign: TextAlign.right,
                  color: _firstTextcolor,
                ),
                SizedBox(width: 6.w),
              ],
            ),
          ),
        ),
        Tab(
          child: Row(
            children: [
              SizedBox(width: 6.w),
              _customTabs(
                text: widget.secTabText,
                textAlign: TextAlign.left,
                color: _secTextcolor,
              ),
              Spacer(),
              SizedBox(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _customTabs({text, textAlign, color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: text,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          fontSize: 14.sp,
          fontweight: FontWeight.bold,
          fontColor: color,
          fontFamily: AppFonts.Roboto_Bold,
        ),
      ],
    );
  }
}
