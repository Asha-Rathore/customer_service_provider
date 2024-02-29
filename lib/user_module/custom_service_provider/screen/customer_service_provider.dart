import 'dart:developer';

import 'package:customer_service_provider_hybrid/user_module/company_profile/model/company_detail_model.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/app_dialogs.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/custom_not_found_text_refresh_indicator_widget.dart';
import '../../../widgets/custom_refresh_indicator_widget.dart';
import '../../../widgets/custom_sizebox.dart';
import '../../company_profile/provider/company_details_provider.dart';

class CustomerServiceProviderScreen extends StatefulWidget {
  List<CompanyDetailDataLanguages?>? companyLanguages;

  CustomerServiceProviderScreen({super.key, this.companyLanguages});

  @override
  State<CustomerServiceProviderScreen> createState() =>
      _CustomerServiceProviderScreenState();
}

class _CustomerServiceProviderScreenState
    extends State<CustomerServiceProviderScreen> {
  // GetCompanyDetailProvider? _getCompanyDetailProvider;

  @override
  void initState() {
    super.initState();
    // _getCompanyDetail();


    log("Company Langugaes:${widget.companyLanguages}");

  }

  // Future<void> _getCompanyDetail() async {
  //   _getCompanyDetailProvider = context.read<GetCompanyDetailProvider>();
  //   await _getCompanyDetailProvider?.getCompanyDetailProviderMethod(
  //       context: context, companyId: widget.companyid);
  // }
  //
  // void _initializeProvider() {
  //   _getCompanyDetailProvider = context.watch<GetCompanyDetailProvider>();
  // }



  @override
  Widget build(BuildContext context) {
    // _initializeProvider();
    return CustomAppTemplate(
      title: AppStrings.customerServiceProvider,
      child: _customColumn(),
      // child: CustomRefreshIndicatorWidget(
      //   onRefresh: _getCompanyDetail,
      //   child: _getCompanyDetailProvider?.waitingStatus == true
      //       ? Center(child: AppDialogs.circularProgressWidget())
      //       : _buildData(),
      // ),
    );
  }

  // Widget _buildData() {
  //   return _getCompanyDetailProvider?.waitingStatus == true
  //       ? AppDialogs.circularProgressWidget()
  //       : _getCompanyDetailProvider?.getCompanyDetailData != null
  //           ? _customColumn()
  //           : CustomDataNotFoundForRefreshIndicatorTextWidget();
  // }

  Widget _customColumn() {
    return CustomPadding(
      child: Column(
        children: [
          CustomSizeBox(),
          CustomDivider(),
          listView(),
        ],
      ),
    );
  }

  Widget listView() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: ListView.separated(
          separatorBuilder: (context,index){
            return CustomDivider();
          },
          itemCount: widget.companyLanguages?.length ?? 0,
          // shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 20.h),
          itemBuilder: ((context, index) {
            return serviceAndNumberWidget(
              index: index,
              language: widget.companyLanguages?[index]?.languageName,
              // phoneNumber:index==1?"": data[index]
              //     ['number'],
              phoneList: widget.companyLanguages?[index]?.numbers,
            );
          }),
        ),
      ),
    );
  }

  Widget serviceAndNumberWidget(
      {int? index,
      String? language,
      String? phoneNumber,
      List<CompanyDetailDataLanguagesNumbers?>? phoneList}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: language ?? "",
            fontColor: AppColors.THEME_COLOR_PURPLE,
            fontFamily: AppFonts.Jost_Medium,
            fontSize: 17,
          ),
          CustomSizeBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: phoneList?.length,
                  itemBuilder: ((context, index) {
                    return Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text:
                                "Line # ${index + 1 > 9 ? (index + 1) : "0${(index + 1)}"}",
                            fontColor: AppColors.THEME_COLOR_LIGHT_GREY,
                            fontFamily: AppFonts.Jost_Medium,
                            fontSize: 14,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                AssetPath.PHONE_ICON,
                                scale: 2.5,
                              ),
                              CustomText(
                                text:
                                    "${phoneList?[index]?.phoneCode} ${phoneList?[index]?.phoneNumber}" ??
                                        "",
                                fontColor: AppColors.THEME_COLOR_BLACK,
                                fontSize: 17,
                                fontFamily: AppFonts.Jost_Medium,
                              ),
                              Spacer(),
                              _callButton(
                                onTap: () {
                                  callOnPhoneNumberMethod(
                                      phoneNumber:
                                          "${phoneList?[index]?.phoneCode} ${phoneList?[index]?.phoneNumber}" ??
                                              "");
                                },
                              ),
                            ],
                          ),
                          CustomSizeBox(),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          // SizedBox(height: 5.h,),
        ],
      ),
    );
  }

  callOnPhoneNumberMethod({String? phoneNumber}) {
    // launchUrl(Uri.parse("tel://${phoneNumber}"));
    Constants.callOnPhoneNumberMethod(phoneNumber: phoneNumber);
  }

  Widget _callButton({Function()? onTap}) {
    return CustomButton(
      width: 110.w,
      verticalPadding: 10.h,
      fontSize: 15.sp,
      onTap: onTap,
      text: "Call Now",
    );
  }
}
