import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/user_module/favorites/arguments/favorite_arguments.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_padding.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../auth/bloc/logout_bloc.dart';
import '../auth/enums/auth_roles.dart';
import '../auth/model/user_model.dart';
import '../auth/providers/auth_role_provider.dart';
import '../auth/providers/user_provider.dart';
import '../content/enums/user_agreement.dart';
import '../content/routing_arguments/content_routing_argument.dart';
import '../utils/app_fonts.dart';
import '../utils/app_navigation.dart';
import '../utils/app_route_name.dart';
import '../utils/asset_paths.dart';
import '../utils/network_strings.dart';
import 'custom_circular_profile.dart';

class CustomDrawer extends StatefulWidget {
  final int? index;
  const CustomDrawer({Key? key, this.index}) : super(key: key);
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<VoidCallback> _useronTapList = [];
  List<VoidCallback> _businessOnTapList = [];
  AuthRoleProvider? _authRoleProvider;
  logoutBloc _logoutBloc = logoutBloc();
  User? _user;
  UserProvider? _userProvider;

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();
    if (_userProvider?.getCurrentUser != null) {
      _user = _userProvider?.getCurrentUser;
    }
    super.initState();
    _authRoleProvider = context.read<AuthRoleProvider>();
    _useronTapList = [
      _homeTap,
      _favoritesTap,
      _settingTap,
      _privacyPolicyTap,
      _termsConditionTap,
      _logoutTap,
    ];
    _businessOnTapList = [
      _homeTap,
      _settingTap,
      _subscriptionTap,
      // _cardDetailTap,
      _privacyPolicyTap,
      _termsConditionTap,
      _logoutTap,
    ];
  }

  @override
  Widget build(BuildContext context) {
    _authRoleProvider = context.watch<AuthRoleProvider>();
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(40.r),
        topRight: Radius.circular(40.r),
      ),
      child: Drawer(
        backgroundColor: AppColors.THEME_COLOR_PURPLE,
        child: Column(
          children: [
            CustomSizeBox(height: 50.h),
            _crossIcon(),
            _userProfile(),
            CustomSizeBox(height: 15.h),
            _userName(),
            CustomSizeBox(height: 6.h),
            _userEmail(),
            CustomSizeBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.h),
              child: Image.asset(AssetPath.DIVIDER_ICON),
            ),
            CustomSizeBox(height: 25.h),
            Expanded(
              // child: _userMenuListWidget(context: context),
              child: _authRoleProvider?.role == AuthRole.user.name
                  ? _userMenuListWidget(context: context)
                  : _tailorMenuListWidget(context: context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crossIcon() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(right: 15.w),
        child: InkWell(
          onTap: () => AppNavigation.navigatorPop(context),
          child: Image.asset(
            AssetPath.CROSS_WHITE_ICON,
            scale: 3,
          ),
        ),
      ),
    );
  }

  Widget _userProfile() {
    return CustomCircularImageWidget(
      image: _user?.profileImage,
      height: 85.h,
      width: 85.h,
      isFileImage: false,
      borderWidth: 4.5,
      isViewAsset: _user?.profileImage == null ? true : false,
    );
  }

  Widget _userName() {
    return CustomText(
      text: _user?.fullName ?? "",
      fontSize: 16.sp,
      // fontweight: FontWeight.w500,
      fontFamily: AppFonts.Jost_SemiBold,
      fontColor: AppColors.THEME_COLOR_WHITE,
    );
  }

  Widget _userEmail() {
    return CustomText(
      text: _user?.email ?? "",
      fontSize: 12.sp,
      fontColor: AppColors.THEME_COLOR_WHITE,
      // fontweight: FontWeight.w400,
      fontFamily: AppFonts.Jost_Regular,
      textAlign: TextAlign.start,
    );
  }

  Widget _userMenuListWidget({required BuildContext context}) {
    return ListView.builder(
      itemCount: AppStrings.USER_DRAWER_TITLE_LIST.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext ctxt, int index) {
        return menuListTile(
            context: context,
            index: index,
            imagePath: AppStrings.USER_DRAWER_ICONS_LIST[index],
            title: AppStrings.USER_DRAWER_TITLE_LIST[index],
            onTap: _useronTapList[index]);
      },
    );
  }

  Widget _tailorMenuListWidget({required BuildContext context}) {
    return ListView.builder(
      itemCount: AppStrings.BUSINESS_DRAWER_TITLE_LIST.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext ctxt, int index) {
        return menuListTile(
          context: context,
          index: index,
          imagePath: AppStrings.BUSINESS_DRAWER_ICONS_LIST[index],
          title: AppStrings.BUSINESS_DRAWER_TITLE_LIST[index],
          onTap: _businessOnTapList[index],
        );
      },
    );
  }

  Widget menuListTile(
      {required BuildContext context,
      required int index,
      required String imagePath,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 30.w, top: 6.5.h, bottom: 6.5.h),
        margin: EdgeInsets.only(top: 3.h, bottom: 3.h, right: 26.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _trailingImage(imagePath: imagePath),
            SizedBox(width: 25.w),
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: _title(text: title),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trailingImage({String? imagePath}) {
    return Image.asset(
      imagePath!,
      height: 25,
      width: 25,
    );
  }

  Widget _title({String? text, Color? color}) {
    return CustomText(
      text: text,
      fontColor: color ?? AppColors.THEME_COLOR_WHITE,
      fontSize: 14.sp,
      fontFamily: AppFonts.Jost_Regular,
      maxLines: 1,
    );
  }

  void _homeTap() {
    _closeDrawerMethod();
    AppNavigation.navigateTo(context, AppRouteName.MAIN_SCREEN_ROUTE,
        arguments: MainScreenRoutingArgument(
          index: _authRoleProvider?.role == AuthRole.user.name ? 1 : 0,
        ));
  }

  void _subscriptionTap() {
    _closeDrawerMethod();
    AppNavigation.navigateTo(
        context, AppRouteName.SUBSCRIPTION_PLAN_SCREEN_ROUTE,
        arguments: false);
  }

  void _cardDetailTap() {
    AppNavigation.navigateTo(context, AppRouteName.CARD_DETAIL_SCREEN_ROUTE);
  }

  void _favoritesTap() {
    _closeDrawerMethod();
    AppNavigation.navigateTo(context, 
        AppRouteName.FAVORITE_SCREEN_ROUTE, 
        arguments: FavoriteArguments(userId: _user?.id ?? 0),
    );
  }

  void _settingTap() {
    _closeDrawerMethod();
    AppNavigation.navigateTo(context, AppRouteName.SETTING_SCREEN_ROUTE);
  }

  void _termsConditionTap() {
    _closeDrawerMethod();
    AppNavigation.navigateTo(
      context,
      AppRouteName.CONTENT_SCREEN_ROUTE,
      arguments: ContentRoutingArgument(
        title: AppStrings.TERMS_CONDITION,
        contentType: NetworkStrings.TERMS_AND_CONDITION,
      ),
    );
  }

  void _privacyPolicyTap() {
    _closeDrawerMethod();
    AppNavigation.navigateTo(
      context,
      AppRouteName.CONTENT_SCREEN_ROUTE,
      arguments: ContentRoutingArgument(
        title: AppStrings.PRIVACY_POLICY,
        contentType: NetworkStrings.PRIVACY_POLICY,
      ),
    );
  }

  void _logoutTap() {
    AppDialogs().showCustomConfirmationDialog(
      context,
      description: AppStrings.DO_YOU_WANT_TO_LOGOUT,
      button1Text: AppStrings.NO,
      button2Text: AppStrings.YES,
      onTapYes: () {
        _logOutMethod(context);
        // AppNavigation.navigateToRemovingAll(
        //     context, AppRouteName.ROLE_SELECTION_SCREEN_ROUTE);
        // AppDialogs.showToast(message: "Logout Successfully");
      },
      onTapNo: () {},
    );
  }

  void _logOutMethod(BuildContext context) {
    //log("User Id:$userId");

    _logoutBloc.logoutBlocMethod(
        context: context,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        });
  }



  void _closeDrawerMethod(){
    AppNavigation.navigatorPop(context);
  }
}
