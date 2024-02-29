import 'package:customer_service_provider_hybrid/user_module/custom_service_provider/routing_arguments/customer_service_provider_arguments.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/asset_paths.dart';
import '../../../widgets/custom_circular_profile.dart';
import '../../../widgets/custom_text.dart';

class CompanyDetailWidget extends StatelessWidget {
  String? profileImage,
      companyName,
      rating,
      address,
      phoneNumber,
      email,
      website;
  int? companyId;
  Function()? onTapRating, onTap, onWebsiteTap;

  CompanyDetailWidget(
      {Key? key,
      this.profileImage,
      this.companyName,
      this.rating,
      this.address,
      this.phoneNumber,
      this.email,
      this.website,
      this.companyId,
      this.onTapRating,
      this.onTap,
      this.onWebsiteTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.THEME_COLOR_WHITE,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.THEME_COLOR_LIGHT_GREY.withOpacity(0.6),
              offset: Offset(0, 1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: _companyDetail(context),
      ),
    );
  }

  Widget _companyDetail(context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.h),
      child: Column(
        children: [
          _companyInfo(context),
          CustomSizeBox(),
          _companyContact(context)
        ],
      ),
    );
  }

  Widget _companyInfo(context) {
    return Row(
      children: [
        _imageWidget(),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _editIcon(context),
              _companyName(),
              CustomSizeBox(height: 5.h),
              _rating(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageWidget() {
    return CustomCircularImageWidget(
      image: profileImage ?? AssetPath.COMPANY_IMAGE,
      borderColor: AppColors.THEME_COLOR_PURPLE,
      height: 60.h,
      width: 60.h,
    );
  }

  Widget _companyName() {
    return CustomText(
      text: companyName ?? AppStrings.COMPANY_NAME,
      fontColor: AppColors.THEME_COLOR_PURPLE,
      // fontweight: FontWeight.bold,
      fontSize: 16.sp,
      fontFamily: AppFonts.Jost_SemiBold,
    );
  }

  Widget customServiceProviderWidget(context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AssetPath.phoneBookIcon,
            scale: 28,
            color: AppColors.THEME_COLOR_DARK_PURPLE,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 3.h),
              child: CustomText(
                text: AppStrings.customerServiceProvider,
                fontColor: AppColors.THEME_COLOR_BLUE,
                fontSize: 14.sp,
                textAlign: TextAlign.left,
                fontFamily: AppFonts.Jost_Regular,
                underlined: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rating() {
    return GestureDetector(
      onTap: onTapRating,
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
          children: [
            _starIcon(),
            SizedBox(width: 4.w),
            _text(text: rating ?? "4.5"),
          ],
        ),
      ),
    );
  }

  Widget _starIcon() {
    return Image.asset(
      AssetPath.STAR_ICON,
      scale: 3,
    );
  }

  Widget _editIcon(context) {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
            context, AppRouteName.EDIT_PROFILE_SCREEN_ROUTE);
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Image.asset(
          AssetPath.EDIT_ICON,
          scale: 3,
        ),
      ),
    );
  }

  Widget _companyAddress() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          AssetPath.LOCATION_ICON,
          scale: 3,
        ),
        SizedBox(width: 4.w),
        Expanded(
            child: _text(text: address ?? AppStrings.TEMP_COMPANY_ADDRESS)),
      ],
    );
  }

  Widget _text({String? text, bool? isUnderline = false}) {
    return CustomText(
      text: text,
      fontColor: AppColors.THEME_COLOR_BLACK,
      fontSize: 13.sp,
      textAlign: TextAlign.left,
      underlined: isUnderline == true ? true : false,
      // fontweight: FontWeight.w400,
      fontFamily: AppFonts.Jost_Regular,
    );
  }

  Widget _companyContact(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _companyAddress(),
        CustomSizeBox(),
        _phoneNumber(),
        CustomSizeBox(),
        _email(),
        CustomSizeBox(),
        _website(),
        CustomSizeBox(),
        customServiceProviderWidget(context),
      ],
    );
  }

  Widget _website() {
    return GestureDetector(
      onTap: onWebsiteTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AssetPath.GLOBE_ICON,
            scale: 3,
          ),
          SizedBox(width: 4.w),
          CustomText(
            text: website ?? AppStrings.TEMP_COMPANY_WEBSITE,
            fontColor: AppColors.THEME_COLOR_BLUE,
            fontSize: 14.sp,
            textAlign: TextAlign.left,
            // fontweight: FontWeight.w400,
            fontFamily: AppFonts.Jost_Regular,
          ),
        ],
      ),
    );
  }

  callOnPhoneNumberMethod() {
    // launchUrl(Uri.parse("tel://${AppStrings.TEMP_COMPANY_NUMBER}"));
    Constants.callOnPhoneNumberMethod(
        phoneNumber: phoneNumber ?? AppStrings.TEMP_COMPANY_NUMBER);
  }

  Widget _phoneNumber() {
    return InkWell(
      onTap: () {
        callOnPhoneNumberMethod();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AssetPath.PHONE_ICON,
            scale: 3,
          ),
          SizedBox(width: 4.w),
          _text(
              text: phoneNumber ?? AppStrings.TEMP_COMPANY_NUMBER,
              isUnderline: true),
        ],
      ),
    );
  }

  Widget _email() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          AssetPath.EMAIL_ICON,
          color: AppColors.THEME_COLOR_DARK_PURPLE,
          scale: 3.5,
        ),
        SizedBox(width: 4.w),
        _text(text: email ?? AppStrings.TEMP_COMPANY_EMAIL),
      ],
    );
  }
}
