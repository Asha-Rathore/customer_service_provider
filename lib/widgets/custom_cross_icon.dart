import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_navigation.dart';
import '../utils/asset_paths.dart';

class CustomCrossIconTap extends StatelessWidget {
  const CustomCrossIconTap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigation.navigatorPop(context),
      child: Align(
        alignment: Alignment.centerRight,
        child: Center(
          child: Image.asset(
            AssetPath.CROSS_ICON,
            height: 23.h,
          ),
        ),
      ),
    );
  }
}
