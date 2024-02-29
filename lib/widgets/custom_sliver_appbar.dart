import 'package:customer_service_provider_hybrid/widgets/custom_app_bar.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/app_navigation.dart';
import '../utils/app_route_name.dart';
import '../utils/asset_paths.dart';
import 'custom_extended_image.dart';

SliverAppBar CustomSliverAppBar({
  String? title,
  bool showAction = false,
  bool showLeading = false,
  bool showTitleWidget = false,
  String? imagePath,
  double? elevation = 0,
  Color? fontColor = AppColors.THEME_COLOR_BLACK,
  Color? backGroundColor = AppColors.THEME_COLOR_WHITE,
  Function()? onTapLeading,
  String? leadingIconPath = AssetPath.BACK_ARROW_ICON,
  Widget? actionWidget,
  Widget? titleWidget,
  Color? titleColor,
  String? backgroundImagePath,
  BuildContext? context,
  ShapeBorder? shape,
  Widget? flexibleSpaceWidget,
  bool? isViewAsset = true,
}) {
  return SliverAppBar(
    // leadingWidth: 130,
    shape: shape,
    flexibleSpace: FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(bottom: 24.h),
      title: flexibleSpaceWidget,
      background: Hero(
        tag: 'image',
        child: GestureDetector(
          onTap: () {
            // AppNavigation.navigateTo(context!, AppRouteName.IMAGE_VIEW_ROUTE,
            //     arguments: ImageViewRoutingArguments(
            //       imagePath: backgroundImagePath,
            //     ));
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage(
              //     AssetPath.SLIVER_IMAGE,
              //   ),
              //   fit: BoxFit.cover,
              // ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: CustomExtendedImageWidget(
              imagePath: backgroundImagePath,
              isFile: false,
              isClipped: false,
              isViewFallBackAsset: isViewAsset,
              placeHolderImagePath: AssetPath.SERVICE_PLACEHOLDER_IMAGE,
            ),
          ),
        ),
      ),
    ),
    floating: false,
    pinned: true,
    expandedHeight: 200.h,
    leading: showLeading
        ? GestureDetector(
            onTap: onTapLeading,
            child: Image.asset(
              AssetPath.BACK_ARROW_ICON,
              scale: 3.sp,
            ),
          )
        // ? CustomAppBar(
        //     leading: leadingIconPath!,
        //     leadingIconScale: 1,
        //     onclickLead: onTapLeading != null
        //         ? onTapLeading
        //         : () {
        //             AppNavigation.navigatorPop(context!);
        //           },
        //   )
        : Container(),
    title: showTitleWidget
        ? titleWidget
        : CustomText(
            text: title ?? "",
            fontColor: fontColor!,
            fontSize: 18.sp,
            // fontweight: FontWeight.w800,
            fontFamily: AppFonts.Jost_Bold,
          ),
    actions: showAction ? [actionWidget!] : [Container()],
    centerTitle: true,
    backgroundColor: backGroundColor,
    elevation: elevation,
  );
}
