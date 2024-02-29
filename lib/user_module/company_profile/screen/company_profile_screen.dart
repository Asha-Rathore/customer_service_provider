import 'package:customer_service_provider_hybrid/auth/providers/user_provider.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/model/company_detail_model.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/provider/company_details_provider.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/provider/reviews_list_provider.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/screen/reviews_screen.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/screen/services_screen.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/widgets/company_detail_widget.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/widgets/custom_tabbar.dart';
import 'package:customer_service_provider_hybrid/user_module/favorites/provider/favorite_list_provider.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../chat/routing_arguments/inbox_routing_argument.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/app_route_name.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/network_strings.dart';
import '../../../widgets/custom_chat_or_call_button.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/custom_not_found_text_refresh_indicator_widget.dart';
import '../../../widgets/custom_refresh_indicator_widget.dart';
import '../../../widgets/custom_text.dart';
import '../../custom_service_provider/routing_arguments/customer_service_provider_arguments.dart';
import '../../home/bloc/add_to_favorite_bloc.dart';
import '../../home/provider/get_compaines_list_provider.dart';
import 'package:collection/collection.dart';

class CompanyProfileScreen extends StatefulWidget {
  final bool? isFavourite;
  final int? index;
  int? companyId;

  CompanyProfileScreen({this.isFavourite, required this.companyId, this.index});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AddToFavoriteBloc _addToFavoriteBloc = AddToFavoriteBloc();
  GetCompanyDetailProvider? _getCompanyDetailProvider;
  GetCompaniesListProvider? _companiesListProvider;
  GetFavoriteListProvider? _getFavoriteListProvider;

  int initialIndex = 0;
  bool isFilled = false;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _getCompanyDetail();
    _companiesListProvider = context.read<GetCompaniesListProvider>();
    _getFavoriteListProvider = context.read<GetFavoriteListProvider>();
    setState(() {
      _tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: initialIndex,
      );
    });
    isFilled = widget.isFavourite ?? false;
  }

  Future<void> _getCompanyDetail() async {
    _userId = context.read<UserProvider>().getCurrentUser?.id;

    _getCompanyDetailProvider = context.read<GetCompanyDetailProvider>();
    await _getCompanyDetailProvider?.getCompanyDetailProviderMethod(
        context: context, companyId: widget.companyId);
  }

  void _initializeProvider() {
    _getCompanyDetailProvider = context.watch<GetCompanyDetailProvider>();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Widget _heartIcon() {
    return GestureDetector(
      onTap: () {
        _addToFavoriteBloc.addToFavBlocMethod(
            context: context,
            companyId: widget.companyId,
            setProgressBar: () {
              AppDialogs.progressAlertDialog(context: context);
            },
            onApiSuccess: (isFav) {
              _companiesListProvider?.addOrRemoveFavorite(
                  index: widget.index ?? 0, isFav: isFav,companyId: widget.companyId);
              _getCompanyDetailProvider?.addOrRemoveFavoriteInDetails(
                  isFav: isFav,);

              _getFavoriteListProvider?.removeFavorite(companyId: widget.companyId);

            });
      },
      child: Icon(
        _getCompanyDetailProvider
                    ?.getCompanyDetailData?.data?.isFavoriteCount ==
                NetworkStrings.IS_FAVORITE
            ? Icons.favorite_rounded
            : Icons.favorite_border_rounded,
        color: AppColors.THEME_COLOR_RED,
        size: 25.sp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initializeProvider();
    return CustomAppTemplate(
      title: AppStrings.COMPANY_PROFILE,
      resizeToAvoidBottomInset: false,
      isAction: true,
      // isDivider: true,
      actionWidget: _heartIcon(),
      child: CustomRefreshIndicatorWidget(
        onRefresh: _getCompanyDetail,
        child: _getCompanyDetailProvider?.waitingStatus == true
            ? Center(child: AppDialogs.circularProgressWidget())
            : _buildData(context: context),
      ),
    );
  }

  Widget _buildData({BuildContext? context}) {
    return _getCompanyDetailProvider?.waitingStatus == true
        ? AppDialogs.circularProgressWidget()
        : _getCompanyDetailProvider?.getCompanyDetailData != null
            ? _customColumn(context: context)
            : CustomDataNotFoundForRefreshIndicatorTextWidget(
      notFoundText: AppStrings.COMPANY_PROFILE_NOT_FOUND_ERROR);
  }

  Widget _customColumn({BuildContext? context}) {
    return Column(
      children: [
        CustomSizeBox(),
        const CustomPadding(child: CustomDivider()),
        CustomSizeBox(height: 15.h),
        _companyDetail(
            companyDetail:
                _getCompanyDetailProvider?.getCompanyDetailData?.data),
        _descriptionWidget(
            companyDetail:
                _getCompanyDetailProvider?.getCompanyDetailData?.data),
        _tabBarWidget(),
        _tabBarView(context: context),
        // _tabController.index == 0 ? _buttons() : _reviewButton(),
      ],
    );
  }

  Widget _companyDetail({CompanyDetailData? companyDetail}) {
    return ComapnyDetailWidget(
      profileImage: companyDetail?.profileImage ?? "",
      companyName: companyDetail?.companyName ?? "",
      rating: companyDetail?.averageRating == null
          ? "0.0"
          : companyDetail?.averageRating.toString(),
      address: companyDetail?.address ?? "",
      phoneNumber:
          "${companyDetail?.phoneCode ?? ""} ${companyDetail?.phoneNumber ?? ""}",
      email: companyDetail?.email ?? "",
      onPhoneTap: () {
        Constants.callOnPhoneNumberMethod(phoneNumber: "+11234567890");
      },
    );
  }

  Widget _descriptionWidget({CompanyDetailData? companyDetail}) {
    return CustomPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSizeBox(height: 25.h),
          _purpleText(AppStrings.DESCRIPTION),
          CustomSizeBox(height: 10.h),
          _description(text: companyDetail?.companyDescription ?? ""),
          CustomSizeBox(height: 12.h),
          _companyWebsite(text: companyDetail?.website ?? ""),
          CustomSizeBox(height: 12.h),
          customServiceProviderWidget(),
          CustomSizeBox(height: 10.h),
          const CustomDivider(),
        ],
      ),
    );
  }

  Widget _purpleText(text) {
    return CustomText(
      text: text,
      fontColor: AppColors.THEME_COLOR_PURPLE,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_SemiBold,
      fontSize: 16.sp,
      textAlign: TextAlign.left,
    );
  }

  Widget _description({String? text}) {
    return CustomText(
      text: text,
      fontColor: AppColors.THEME_COLOR_BLACK,
      textAlign: TextAlign.left,
      fontFamily: AppFonts.Jost_Regular,
      fontSize: 14.sp,
    );
  }

  Widget _companyWebsite({String? text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          AssetPath.GLOBE_ICON,
          scale: 3,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: CustomText(
            text: text,
            fontColor: AppColors.THEME_COLOR_BLUE,
            fontSize: 14.sp,
            textAlign: TextAlign.left,
            fontFamily: AppFonts.Jost_Regular,
          ),
        ),
      ],
    );
  }

  Widget customServiceProviderWidget() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
            context, AppRouteName.customerServiceProviderScreenRoute,
            arguments: CustomerServiceProviderArguments(
              companyLanguages: _getCompanyDetailProvider?.getCompanyDetailData?.data?.languages,
            ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AssetPath.phoneBookIcon,
            scale: 28,
            color: AppColors.THEME_COLOR_PURPLE,
          ),
          SizedBox(width: 10.w),
          CustomText(
            text: AppStrings.customerServiceProvider,
            fontColor: AppColors.THEME_COLOR_BLUE,
            fontSize: 14.sp,
            textAlign: TextAlign.left,
            fontFamily: AppFonts.Jost_Regular,
            underlined: true,
          ),
        ],
      ),
    );
  }

  Widget _tabBarWidget() {
    return CustomTabBar(
      tabController: _tabController,
      firstTabText: AppStrings.SERVICES,
      secTabText: AppStrings.REVIEWS,
    );
  }

  Widget _tabBarView({BuildContext? context}) {
    return Flexible(
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          //------------------------- SERVICES -----------------------------//
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ServicesScreen(companyId: widget.companyId),
              _buttons(),
            ],
          ),
          //------------------------- REVIEWS --------------------------- //
          // _reviews(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReviewsScreen(companyId: widget.companyId),
              _reviewButton(context: context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttons() {
    return IntrinsicWidth(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: CustomChatOrCallButton(
          text: AppStrings.CHAT_WITH_US,
          icon: AssetPath.CHAT_WITH_DOTS_ICON,
          onTap: () {
            AppNavigation.navigateTo(
              context,
              AppRouteName.INBOX_SCREEN_ROUTE,
              arguments: InboxRoutingArgument(
                name: _getCompanyDetailProvider?.getCompanyDetailData?.data?.companyName,
                image: _getCompanyDetailProvider?.getCompanyDetailData?.data?.profileImage,
                id: widget.companyId,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _reviewButton({BuildContext? context}) {
    return Consumer<ReviewsListProvider>(
        builder: (context, reviewConsumerData, child) {
      return Visibility(
        visible: reviewConsumerData.getReviewsList?.data?.firstWhereOrNull(
                    (reviewData) => reviewData?.userId == _userId) !=
                null
            ? false
            : true,
        child: IntrinsicWidth(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: CustomButton(
              verticalPadding: 17.0,
              horizontalPadding: 40.0,
              onTap: () {
                AppDialogs().showRatingDialog(
                    context: context,
                    companyId: widget.companyId,
                    isEdit: false);
              },
              text: AppStrings.ADD_A_REVIEW,
            ),
          ),
        ),
      );
    });
  }
}
