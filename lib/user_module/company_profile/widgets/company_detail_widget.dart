import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/asset_paths.dart';
import '../../../widgets/custom_circular_profile.dart';
import '../../../widgets/custom_text.dart';

class ComapnyDetailWidget extends StatelessWidget {
  String? profileImage, companyName, rating, address, phoneNumber, email;
  final VoidCallback? onPhoneTap;

  ComapnyDetailWidget(
      {this.onPhoneTap,
      this.email,
      this.phoneNumber,
      this.address,
      this.rating,
      this.companyName,
      this.profileImage});

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
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Column(
        children: [_companyInfo(), CustomSizeBox(), _companyContact(context)],
      ),
    );
  }

  Widget _companyInfo() {
    return Row(
      children: [
        _imageWidget(),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _companyNameAndRating(),
              CustomSizeBox(height: 5.h),
              _companyAddress(),
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
      placeholderImage: AssetPath.BUSINESS_PLACEHOLDER_IMAGE,
    );
  }

  Widget _companyNameAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _companyName(),
        _rating(),
      ],
    );
  }

  Widget _companyName() {
    return Expanded(
      child: CustomText(
        text: companyName ?? AppStrings.COMPANY_NAME,
        fontColor: AppColors.THEME_COLOR_PURPLE,
        // fontweight: FontWeight.bold,
        fontSize: 16.sp,
        fontFamily: AppFonts.Jost_SemiBold,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _rating() {
    return Align(
      alignment: Alignment.topRight,
      child: Row(
        children: [
          Image.asset(
            AssetPath.STAR_ICON,
            scale: 4,
          ),
          SizedBox(width: 2.w),
          _text(rating ?? "4.5"),
        ],
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
        Expanded(child: _text(address ?? AppStrings.TEMP_COMPANY_ADDRESS)),
      ],
    );
  }

  Widget _text(text) {
    return CustomText(
      text: text,
      fontColor: AppColors.THEME_COLOR_BLACK,
      fontSize: 13.sp,
      textAlign: TextAlign.left,
      // fontweight: FontWeight.w400,
      fontFamily: AppFonts.Jost_Medium,
      maxLines: 2,
    );
  }

  Widget _companyContact(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _email(),
        SizedBox(height: 5.h),
        _phoneNumber(context),
      ],
    );
  }

  Widget _phoneNumber(context) {
    return GestureDetector(
      onTap: onPhoneTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AssetPath.PHONE_ICON,
            scale: 3,
          ),
          SizedBox(width: 4.w),
          CustomText(
            text: phoneNumber ?? "+11234567890",
            fontColor: AppColors.THEME_COLOR_BLACK,
            fontSize: 13.sp,
            textAlign: TextAlign.left,
            // fontweight: FontWeight.w400,
            fontFamily: AppFonts.Jost_Medium,
            // underlined: true,
          ),
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
          scale: 3,
          color: AppColors.THEME_COLOR_PURPLE,
        ),
        SizedBox(width: 4.w),
        _text(email ?? AppStrings.TEMP_COMPANY_EMAIL),
      ],
    );
  }
}
