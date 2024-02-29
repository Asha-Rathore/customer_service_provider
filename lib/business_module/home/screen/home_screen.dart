import 'package:customer_service_provider_hybrid/business_module/Reviews/routing_arguments/business_reviews_arguments.dart';
import 'package:customer_service_provider_hybrid/business_module/home/model/services_model.dart';
import 'package:customer_service_provider_hybrid/business_module/home/provider/services_provider.dart';
import 'package:customer_service_provider_hybrid/business_module/home/widgets/company_detail_widget.dart';
import 'package:customer_service_provider_hybrid/user_module/custom_service_provider/routing_arguments/customer_service_provider_arguments.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../auth/providers/user_provider.dart';
import '../../../services_detail/routing_arguments/service_detail_routing_arguments.dart';
import '../../../user_module/company_profile/model/company_detail_model.dart';
import '../../../user_module/company_profile/provider/company_details_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/app_route_name.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/asset_paths.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/custom_error_widget.dart';
import '../../../widgets/custom_home_container.dart';
import '../../../widgets/custom_not_found_text_refresh_indicator_widget.dart';
import '../../../widgets/custom_padding.dart';
import '../../../widgets/custom_refresh_indicator_widget.dart';
import '../../../widgets/custom_sizebox.dart';
import '../../../widgets/custom_text.dart';

class BusinessHomeScreen extends StatefulWidget {
  const BusinessHomeScreen({Key? key}) : super(key: key);

  @override
  State<BusinessHomeScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  GetCompanyDetailProvider? _getCompanyDetailProvider;
  ServicesProvider? _servicesProvider;
  UserProvider? _userProvider;
  int? companyId;

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();
    if (_userProvider?.getCurrentUser != null) {
      companyId = _userProvider?.getCurrentUser?.id;
    }
    super.initState();
    _getCompanyDetail();
    _getServicesList();
  }

  Future<void> _getCompanyDetail() async {
    _getCompanyDetailProvider = context.read<GetCompanyDetailProvider>();
    await _getCompanyDetailProvider?.getCompanyDetailProviderMethod(
        context: context, companyId: companyId);
  }

  Future<void> _getServicesList() async {
    _servicesProvider = context.read<ServicesProvider>();
    await _servicesProvider?.getServicesListProviderMethod(context: context);
  }

  void _initializeProvider() {
    _getCompanyDetailProvider = context.watch<GetCompanyDetailProvider>();
    _servicesProvider = context.watch<ServicesProvider>();
    _userProvider = context.watch<UserProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _initializeProvider();
    return CustomRefreshIndicatorWidget(
      onRefresh: _getCompanyDetail,
      child: _getCompanyDetailProvider?.waitingStatus == true
          ? Center(child: AppDialogs.circularProgressWidget())
          : _buildData(),
    );
  }

  Widget _buildData() {
    return _getCompanyDetailProvider?.waitingStatus == true
        ? AppDialogs.circularProgressWidget()
        : _getCompanyDetailProvider?.getCompanyDetailData != null
            ? _customColumn()
            : CustomDataNotFoundForRefreshIndicatorTextWidget(
                notFoundText: AppStrings.COMPANY_PROFILE_NOT_FOUND_ERROR);
  }

  Widget _customColumn() {
    // _getServicesList();
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomSizeBox(),
          const CustomPadding(child: CustomDivider()),
          CustomSizeBox(height: 15.h),
          _companyDetailWidget(
              companyDetail:
                  _getCompanyDetailProvider?.getCompanyDetailData?.data),
          _descriptionWidget(),
          CustomSizeBox(height: 15.h),
          _services(context),
          CustomSizeBox(height: 25.h),
        ],
      ),
    );
  }

  Widget _companyDetailWidget({CompanyDetailData? companyDetail}) {
    return CompanyDetailWidget(
      profileImage: companyDetail?.profileImage ?? "",
      companyName: companyDetail?.companyName ?? "",
      rating: companyDetail?.averageRating == null
          ? "0.0"
          : companyDetail?.averageRating.toString(),
      address: companyDetail?.address ?? "",
      phoneNumber:
          "${companyDetail?.phoneCode ?? ""} ${companyDetail?.phoneNumber ?? ""}",
      email: companyDetail?.email ?? "",
      website: companyDetail?.website ?? "",
      companyId: companyDetail?.id,
      onTap: () {
        AppNavigation.navigateTo(
            context, AppRouteName.customerServiceProviderScreenRoute,
            arguments: CustomerServiceProviderArguments(
              companyLanguages: _getCompanyDetailProvider
                  ?.getCompanyDetailData?.data?.languages,
            ));
      },
      onTapRating: () {
        AppNavigation.navigateTo(
            context, AppRouteName.BUSINESS_REVIEWS_SCREEN_ROUTE,
            arguments: BusinessReviewsArguments(
              companyId: companyDetail?.id,
            ));
      },
      onWebsiteTap: () {
        Constants.launchLink(url: companyDetail?.website);
      },
    );
  }

  Widget _descriptionWidget() {
    return CustomPadding(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSizeBox(height: 25.h),
            _purpleText(AppStrings.DESCRIPTION, AppFonts.Jost_SemiBold),
            CustomSizeBox(height: 15.h),
            _description(),
            CustomSizeBox(height: 15.h),
            _purpleText(AppStrings.MY_SERVICES, AppFonts.Roboto_Bold),
          ],
        ),
      ),
    );
  }

  Widget _purpleText(text, fontFamily) {
    return CustomText(
      text: text,
      fontColor: AppColors.THEME_COLOR_PURPLE,
      // fontweight: FontWeight.bold,
      fontSize: 16.sp,
      textAlign: TextAlign.left,
      fontFamily: fontFamily,
    );
  }

  Widget _description() {
    print(
        "DESCRIPTION: ${_getCompanyDetailProvider?.getCompanyDetailData?.data?.companyDescription}");
    return CustomText(
      text: _getCompanyDetailProvider
              ?.getCompanyDetailData?.data?.companyDescription ??
          "",
      fontColor: AppColors.THEME_COLOR_BLACK,
      textAlign: TextAlign.left,
      fontFamily: AppFonts.Jost_Regular,
    );
  }

  Widget _services(context) {
    return _servicesProvider?.waitingStatus == true
        ? AppDialogs.circularProgressWidget()
        : (_servicesProvider?.getServicesListData?.data?.length ?? 0) > 0
            ? _servicesGridView(
                servicesData: _servicesProvider?.getServicesListData?.data)
            : CustomErrorWidget(
                errorImagePath: AssetPath.DATA_NOT_FOUND_ICON,
                errorText: AppStrings.MY_SERVICES_NOT_FOUND_ERROR,
                imageSize: 70.h,
                imageColor: AppColors.THEME_COLOR_BLACK,
              );
    // : CustomDataNotFoundForRefreshIndicatorTextWidget(height: 90.h);
  }

  Widget _servicesGridView({List<ServicesListData?>? servicesData}) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 0.5.sw,
          childAspectRatio: 1.0,
          crossAxisSpacing: 22.0,
          mainAxisSpacing: 22.0,
        ),
        itemCount: servicesData?.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext ctx, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index.isEven ? 20.w : 0.w,
              right: index.isOdd ? 20.w : 0.w,
            ),
            child: GestureDetector(
              onTap: () {
                AppNavigation.navigateTo(
                    context, AppRouteName.SERVICE_DETAIL_SCREEN_ROUTE,
                    arguments: ServiceDetailArguments(
                        serviceId: servicesData?[index]?.id));
                print("service id: ${servicesData?[index]?.id}");
              },
              child: CustomHomeContainer(
                placeHolderImage: AssetPath.SERVICE_PLACEHOLDER_IMAGE,
                isViewAsset:
                    servicesData?[index]?.serviceImage == null ? true : false,
                image: servicesData?[index]?.serviceImage ?? "",
                mainText: servicesData?[index]?.name ?? "",
                description: servicesData?[index]?.description ?? "",
              ),
            ),
          );
        });
  }
}
