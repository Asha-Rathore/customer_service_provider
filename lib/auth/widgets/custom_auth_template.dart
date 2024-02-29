import 'package:customer_service_provider_hybrid/auth/widgets/auth_container.dart';
import 'package:customer_service_provider_hybrid/auth/widgets/rich_text_widget.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_bar.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_logo.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/asset_paths.dart';

class CustomAuthTemplate extends StatelessWidget {
  String? title, firstBottomText, secBottomText;
  Widget child;
  bool? isLeading, isBottomText, isOTP, resizeToAvoidBottomInset;
  int? flex;
  Function()? onTap, onTapLogo;
  Widget? otpChild;
  Color? linkTextColor;
  CustomAuthTemplate({
    this.title,
    required this.child,
    this.isLeading = true,
    this.isBottomText = false,
    this.isOTP = false,
    this.resizeToAvoidBottomInset = true,
    this.firstBottomText,
    this.secBottomText,
    this.onTap,
    this.flex,
    this.otpChild,
    this.onTapLogo,
    this.linkTextColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetPath.APP_BACKGROUND_IMAGE),
            fit: BoxFit.cover,
          ),
        ),
        child: _scaffoldWidget(context));
  }

  Widget _scaffoldWidget(context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: AppColors.THEME_COLOR_TRANSPARENT,
      appBar: _appBar(context),
      body: Center(
        child: Column(
          children: [
            // SizedBox(height: 3.h),
            _appLogo(),
            // SizedBox(height: 8.h),
            _authContainer(),
            if (isOTP == true) ...[
              // const Spacer(),
              CustomSizeBox(height: 65.h),
              otpChild!,
              // const BottomHeightSpace(),
            ],
            if (isBottomText == true) ...[
              isOTP! ? CustomSizeBox(height: 10.h) : const Spacer(),
              _dontHaveAccount(context),
              CustomSizeBox(height: 10.h)
              // const BottomHeightSpace(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _appLogo() {
    return CustomLogo(onTap: onTapLogo,);
  }

  Widget _authContainer() {
    return AuthContainer(
      text: title,
      child: child,
      flex: flex,
    );
  }

  CustomAppBar _appBar(context) {
    return CustomAppBar(
      leading: isLeading! ? AssetPath.BACK_ARROW_ICON : null,
      onclickLead: () {
        AppNavigation.navigatorPop(context);
      },
    );
  }

  Widget _dontHaveAccount(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomAuthRichTextWidget(
        normalText: firstBottomText,
        linkText: secBottomText,
        onTap: onTap,
        linkTextColor: linkTextColor,
      ),
    );
  }
}
