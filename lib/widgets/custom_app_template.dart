import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_bar.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_divider.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_navigation.dart';
import '../utils/asset_paths.dart';

class CustomAppTemplate extends StatelessWidget {
  final String title;
  final String? actionIcon;
  final bool? isAction, isDivider, resizeToAvoidBottomInset;
  final Function()? onClickAction,onClickLead;
  final Widget child;
  final Widget? actionWidget;
  CustomAppTemplate({
    Key? key,
    required this.title,
    this.actionWidget,
    this.actionIcon,
    this.isAction = false,
    this.onClickAction,
    this.onClickLead,
    required this.child,
    this.resizeToAvoidBottomInset = true,
    this.isDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.THEME_COLOR_WHITE,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: _appBar(context),
      body: isDivider!
          ? Column(
              children: [
                CustomSizeBox(),
                const CustomPadding(child: CustomDivider()),
                CustomSizeBox(height: 15.h),
                child,
              ],
            )
          : child,
    );
  }

  CustomAppBar _appBar(context) {
    return CustomAppBar(
      leading: AssetPath.BACK_ARROW_ICON,
      title: title,
      actionWidget: actionIcon != null ? Image.asset(actionIcon!) : actionWidget,
      showAction: isAction!,
      onclickAction: onClickAction,
      backgroundColor: AppColors.THEME_COLOR_WHITE,
      onclickLead: onClickLead ?? () {
        AppNavigation.navigatorPop(context);
      },
    );
  }
}
