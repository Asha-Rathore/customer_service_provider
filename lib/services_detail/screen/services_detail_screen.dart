import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/services_detail/widget/custom_company_widget.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/provider/service_detail_provider.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../auth/enums/auth_roles.dart';
import '../../auth/providers/auth_role_provider.dart';
import '../../business_module/service/routing_arguments/service_routing_arguments.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_strings.dart';
import '../../utils/asset_paths.dart';
import '../../widgets/custom_not_found_text_refresh_indicator_widget.dart';
import '../../widgets/custom_refresh_indicator_widget.dart';
import '../../widgets/custom_sliver_appbar.dart';
import '../../widgets/custom_text.dart';

class ServicesDetailScreen extends StatefulWidget {
  int? serviceId;
  bool? notificationNavigationEnable;

  ServicesDetailScreen(
      {Key? key, this.serviceId, this.notificationNavigationEnable})
      : super(key: key);

  @override
  State<ServicesDetailScreen> createState() => _ServicesDetailScreenState();
}

class _ServicesDetailScreenState extends State<ServicesDetailScreen> {
  late ScrollController _scrollController;
  AuthRoleProvider? _authRoleProvider;
  ServiceDetailProvider? _serviceDetailProvider;

  bool isFilled = false;

  bool lastStatus = true;

  double height = 200;

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _getServiceDetail();
    _authRoleProvider = context.read<AuthRoleProvider>();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  Future<void> _getServiceDetail() async {
    _serviceDetailProvider = context.read<ServiceDetailProvider>();
    await _serviceDetailProvider?.getServiceDetailProviderMethod(
        context: context, serviceId: widget.serviceId);
  }

  void _initializeProvider() {
    _authRoleProvider = context.watch<AuthRoleProvider>();
    _serviceDetailProvider = context.watch<ServiceDetailProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _initializeProvider();
    return WillPopScope(
      onWillPop: () async {
        _backMethod();

        return true;
      },
      child: Scaffold(
          backgroundColor: AppColors.THEME_COLOR_WHITE,
          body: CustomRefreshIndicatorWidget(
            onRefresh: _getServiceDetail,
            child: _serviceDetailProvider?.waitingStatus == true
                ? Center(child: AppDialogs.circularProgressWidget())
                : _buildData(),
          )),
    );
  }

  Widget _buildData() {
    return _serviceDetailProvider?.waitingStatus == true
        ? AppDialogs.circularProgressWidget()
        : _serviceDetailProvider?.getServiceDetailData != null
            ? _nestedScrollView()
            : Column(
              children: [
                AppBar(
                  backgroundColor: AppColors.THEME_COLOR_WHITE,
                  elevation: 0,
                  leading:    GestureDetector(
                    onTap: (){
                      _backMethod();
                    },
                    child: Image.asset(
                      AssetPath.BACK_ARROW_ICON,
                      scale: 3.sp,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0.2.sh),
                  child: CustomDataNotFoundForRefreshIndicatorTextWidget(
                      notFoundText: AppStrings.SERVICE_DETAIL_NOT_FOUND_ERROR),
                ),
              ],
            );
  }

  Widget _nestedScrollView() {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          _customSliverAppBar(),
        ];
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizeBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _purpleText(
                _serviceDetailProvider?.getServiceDetailData?.data?.name ?? "",
                AppFonts.Jost_SemiBold,
              ),
              SizedBox(width: 50.w),
              // _authRoleProvider?.role == AuthRole.user.name
              //     ? _chatWithUsButton()
              //     : SizedBox(
              //         height: 30.h,
              //       ),
            ],
          ),
          CustomSizeBox(height: 10.h),
          _detailText(),
          CustomSizeBox(height: 15.h),
          _companyWebsite(),
          CustomSizeBox(height: 15.h),
          // _purpleText(
          //     _authRoleProvider?.role == AuthRole.user.name
          //         ? AppStrings.SERVICES
          //         : AppStrings.MORE_SERVICES,
          //     AppFonts.Roboto_Bold),
          // _gridView(),
        ],
      ),
    );
  }

  Widget _purpleText(text, fontFamily) {
    return CustomPadding(
      child: CustomText(
        text: text,
        fontColor: AppColors.THEME_COLOR_PURPLE,
        // fontweight: FontWeight.bold,
        fontFamily: fontFamily,
        fontSize: 16.sp,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _detailText() {
    return CustomPadding(
      child: CustomText(
        text: _serviceDetailProvider?.getServiceDetailData?.data?.description ??
            "",
        fontColor: AppColors.THEME_COLOR_BLACK,
        fontSize: 14.sp,
        textAlign: TextAlign.left,
        fontFamily: AppFonts.Jost_Regular,
      ),
    );
  }

  Widget _companyWebsite() {
    return CustomCompanyWidget(
      companyName: _serviceDetailProvider
              ?.getServiceDetailData?.data?.user?.companyName ??
          "",
      companyImage: _serviceDetailProvider
              ?.getServiceDetailData?.data?.user?.profileImage ??
          "",
      companyWebsite:
          _serviceDetailProvider?.getServiceDetailData?.data?.user?.website ??
              "",
      onTap: () {
        // _authRoleProvider?.role == AuthRole.user.name
        //     ? AppNavigation.navigateTo(
        //         context, AppRouteName.COMPANY_PROFILE_SCREEN_ROUTE)
        //     : AppNavigation.navigateTo(
        //         context,
        //         AppRouteName.MAIN_SCREEN_ROUTE,
        //         arguments: MainScreenRoutingArgument(
        //           index: 0,
        //         ),
        //       );
      },
    );
  }

  Widget _customSliverAppBar() {
    return CustomSliverAppBar(
      title: AppStrings.SERVICES_DETAIL,
      fontColor: !_isShrink
          ? AppColors.THEME_COLOR_WHITE
          : AppColors.THEME_COLOR_BLACK,
      context: context,
      isViewAsset:
          _serviceDetailProvider?.getServiceDetailData?.data?.serviceImage ==
                  null
              ? true
              : false,
      backgroundImagePath:
          _serviceDetailProvider?.getServiceDetailData?.data?.serviceImage ??
              "",
      // AssetPath.SLIVER_IMAGE,
      showLeading: true,
      showAction: true,
      actionWidget: GestureDetector(
        onTap: () {
          setState(() {
            isFilled = !isFilled;
          });
        },
        child: Padding(
          padding: EdgeInsets.only(
              right:
                  _authRoleProvider?.role == AuthRole.user.name ? 10.w : 5.w),
          child: _authRoleProvider?.role == AuthRole.user.name
              ? Container()
              : _editButton(),
        ),
      ),
      onTapLeading: () => _backMethod(),
      shape: _isShrink
          ? ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            )
          : null,
    );
  }

  Widget _editButton() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.ADD_OR_EDIT_SERVICE_SCREEN_ROUTE,
          arguments: ServiceScreenRoutingArgument(
            isEditService: true,
            isFromProfile: false,
            serviceid: _serviceDetailProvider?.getServiceDetailData?.data?.id,
            serviceImage: _serviceDetailProvider
                ?.getServiceDetailData?.data?.serviceImage,
            serviceName:
                _serviceDetailProvider?.getServiceDetailData?.data?.name,
            location:
                _serviceDetailProvider?.getServiceDetailData?.data?.location,
            description:
                _serviceDetailProvider?.getServiceDetailData?.data?.description,
          ),
        );
        print(
            "service detail id: ${_serviceDetailProvider?.getServiceDetailData?.data?.id}");
      },
      child: Image.asset(
        AssetPath.EDIT_ROUNDED_ICON,
        scale: 3.5,
      ),
    );
  }

  void _backMethod() {
    if (widget.notificationNavigationEnable == true) {
      AppNavigation.navigateToRemovingAll(
        context,
        AppRouteName.MAIN_SCREEN_ROUTE,
        arguments: MainScreenRoutingArgument(
          index: 1,
        ),
      );
    } else {
      AppNavigation.navigatorPop(context);
    }
  }
}
