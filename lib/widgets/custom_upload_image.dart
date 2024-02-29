import 'dart:io';

import 'package:customer_service_provider_hybrid/widgets/custom_circular_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/asset_paths.dart';
import '../utils/image_gallery_class.dart';
import '../utils/network_strings.dart';
import 'custom_extended_image.dart';

class CustomUploadImage extends StatefulWidget {
  Color? borderColor;
  String? imagePath;
  Function()? onTap;
  bool? isFileImage, isViewAsset;
  CustomUploadImage(
      {Key? key,
      this.borderColor,
      this.imagePath,
      this.onTap,
      this.isFileImage = false,
      this.isViewAsset = true})
      : super(key: key);

  @override
  State<CustomUploadImage> createState() => _CustomUploadImageState();
}

class _CustomUploadImageState extends State<CustomUploadImage> {
  // String? imagePath = null;
  // bool isFile = false;
  @override
  Widget build(BuildContext context) {
    return _imageWidget();
  }

  Widget _userProfileImageWidget() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 140.h,
        width: 140.w,
        decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_PURPLE,
            shape: BoxShape.circle,
            border: Border.all(
                color: widget.borderColor ?? AppColors.THEME_COLOR_PURPLE)),
        child: CustomExtendedImageWidget(
          imagePath: widget.imagePath,
          isFile: widget.isFileImage,
          isClipped: true,
          isViewFallBackAsset: true,
          placeHolderImagePath: AssetPath.CAMERA_ICON,
        ),
      ),
    );
  }

  Widget _imageWidget() {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 140.w,
        width: 140.w,
        decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_PURPLE,
            shape: BoxShape.circle,
            border: Border.all(
                color: widget.borderColor ?? AppColors.THEME_COLOR_PURPLE)),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CustomExtendedImageWidget(
            imagePath: widget.imagePath,
            isFile: widget.isFileImage,
            isClipped: true,
            isViewFallBackAsset: widget.isViewAsset,
            // placeHolderImagePath: AssetPath.CAMERA_ICON,
          ),
          // child: imagePath != null
          //     ? Container(
          //         decoration: BoxDecoration(
          //           color: AppColors.THEME_COLOR_PURPLE.withOpacity(0.6),
          //           shape: BoxShape.circle,
          //         ),
          //         child: Center(
          //           child: GestureDetector(
          //             onTap: () {
          //               ImageGalleryClass().imageGalleryBottomSheet(
          //                 context: context,
          //                 onMediaChanged: (value) {
          //                   setState(() {
          //                     imagePath = value!;
          //                   });
          //                 },
          //               );
          //             },
          //             child: Image.asset(AssetPath.CAMERA_ICON, scale: 2.5),
          //           ),
          //         ),
          //       )
          //     : null,
        ),
      ),
    );
  }
}
