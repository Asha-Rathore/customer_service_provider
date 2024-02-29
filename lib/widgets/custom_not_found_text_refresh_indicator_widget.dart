import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_strings.dart';
import '../utils/asset_paths.dart';
import 'custom_error_widget.dart';

Widget CustomDataNotFoundForRefreshIndicatorTextWidget(
    {String? notFoundText, double? height, bool? isSingleChildEnable}) {
  return SizedBox(
    height: 0.4.sh,
    width: 1.0.sw,
    child: Center(
      child: isSingleChildEnable == false
          ? _errorWidget(text: notFoundText)
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: _errorWidget(text: notFoundText)),
    ),
  );
}

Widget _errorWidget({String? text}) {
  return CustomErrorWidget(
    errorImagePath: AssetPath.DATA_NOT_FOUND_ICON,
    errorText: text,
    imageSize: 70.h,
    imageColor: AppColors.THEME_COLOR_BLACK,
  );
}
