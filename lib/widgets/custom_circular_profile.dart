import 'package:customer_service_provider_hybrid/utils/app_shadows.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/asset_paths.dart';
import 'custom_extended_image.dart';

class CustomCircularImageWidget extends StatelessWidget {
  final Function()? onTapImage;
  final String? image, placeholderImage;
  final double? height, width, borderWidth;
  final Color? borderColor;
  final bool? isFileImage, isViewAsset;

  CustomCircularImageWidget({
    Key? key,
    this.onTapImage,
    this.image,
    this.width,
    this.borderColor,
    this.height,
    this.borderWidth,
    this.isFileImage = false,
    this.isViewAsset = true,
    this.placeholderImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapImage,
      child: Container(
       // clipBehavior: Clip.antiAlias,
        width: width ?? 50.h,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          color: AppColors.THEME_COLOR_WHITE,
          boxShadow: AppShadow.boxShadow(),
          shape: BoxShape.circle,
          border: Border.all(
            width: borderWidth ?? 4,
            color: borderColor ?? AppColors.THEME_COLOR_WHITE,
          ),
        ),
        child: CustomExtendedImageWidget(
          imagePath: image,
          isFile: isFileImage,
          isClipped: true,
          isViewFallBackAsset: isViewAsset,
          placeHolderImagePath: placeholderImage,
          // placeHolderImagePath: placeholderImage ?? AssetPath.USER_ICON,
          // fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
