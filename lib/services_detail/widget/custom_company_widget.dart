import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../auth/model/user_model.dart';
import '../../auth/providers/user_provider.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_circular_profile.dart';
import '../../widgets/custom_sizebox.dart';
import '../../widgets/custom_text.dart';

class CustomCompanyWidget extends StatefulWidget {
  String? companyImage, companyName, companyWebsite;
  Function()? onTap;
  CustomCompanyWidget({Key? key, this.onTap, this.companyName, this.companyWebsite, this.companyImage}) : super(key: key);

  @override
  State<CustomCompanyWidget> createState() => _CustomCompanyWidgetState();
}

class _CustomCompanyWidgetState extends State<CustomCompanyWidget> {


  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: GestureDetector(
        onTap: widget.onTap,
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
          child: _companyDetail(),
        ),
      ),
    );
  }

  Widget _companyDetail() {
    return Padding(
      padding: EdgeInsets.all(10.h),
      child: Row(
        children: [
          _imageWidget(),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _companyName(),
                CustomSizeBox(height: 5.h),
                _website(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _imageWidget() {
    return CustomCircularImageWidget(
      image: widget.companyImage ?? AssetPath.COMPANY_IMAGE,
      borderColor: AppColors.THEME_COLOR_PURPLE,
      placeholderImage: AssetPath.BUSINESS_PLACEHOLDER_IMAGE,
    );
  }

  Widget _companyName() {
    return CustomText(
      text: widget.companyName ?? AppStrings.COMPANY_NAME,
      fontColor: AppColors.THEME_COLOR_PURPLE,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_SemiBold,
    );
  }

  Widget _website() {
    return Row(
      children: [
        Image.asset(
          AssetPath.GLOBE_ICON,
          scale: 3,
        ),
        SizedBox(width: 5.w),
        CustomText(
          text: widget.companyWebsite ?? AppStrings.TEMP_COMPANY_WEBSITE,
          fontColor: AppColors.THEME_COLOR_LIGHT_GREY,
          // fontweight: FontWeight.bold,
          fontFamily: AppFonts.Jost_Medium,
          fontSize: 13.sp,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
