import 'dart:async';
import 'dart:convert';

import 'package:customer_service_provider_hybrid/auth/enums/auth_roles.dart';
import 'package:customer_service_provider_hybrid/service_navigation/notification_navigation_class.dart';
import 'package:customer_service_provider_hybrid/services/firebase_messaging_service.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_bottom_space.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../auth/model/user_model.dart';
import '../../auth/providers/auth_role_provider.dart';
import '../../auth/providers/user_provider.dart';
import '../../main_screen/routing_arguments/main_screen_routing_arguments.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_padding.dart';
import '../../utils/app_route_name.dart';
import '../../utils/app_strings.dart';
import '../../utils/asset_paths.dart';
import '../../widgets/custom_app_logo.dart';
import '../../widgets/custom_text.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserProvider? _userProvider;

  AuthRoleProvider? _authRoleProvider;

  NotificationNavigationClass _notificationNavigationClass =
      NotificationNavigationClass();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _splashTimer();
  }


  @override
  Widget build(BuildContext context) {
    _authRoleProvider = context.read<AuthRoleProvider>();
    return Container(
      width: 1.sw,
      height: 1.sh,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetPath.SPLASH_BG_IMAGE),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          _appLogo(),
         // _getStartedTextButton(context),
         // const BottomHeightSpace(),
        ],
      ),
    );
  }

  Widget _appLogo() {
    return Expanded(
      child: Center(
        child: Entry.scale(
          curve: Curves.easeIn,
          duration: const Duration(seconds: 2),
          child: CustomLogo(height: 250.w, width: 250.w),
        ),
      ),
    );
  }

  Widget _getStartedTextButton(context) {
    return CustomPadding(
      child: GestureDetector(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.THEME_COLOR_TRANSPARENT,
            border: Border.all(color: AppColors.THEME_COLOR_WHITE, width: 2),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppPadding.BUTTON_VERTICAL_PADDING.h,
                horizontal: AppPadding.DEFAULT_BUTTON_HORIZONTAL_PADDING.w),
            child: CustomText(
              text: AppStrings.LETS_GET_STARTED_NOW,
              fontSize: 17.sp,
              fontColor: AppColors.THEME_COLOR_WHITE,
              fontweight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          _validateUser();
        },
      ),
    );
  }


  Future<Timer> _splashTimer() async {
    return Timer(Duration(seconds: 2), _onComplete);
  }

  void _onComplete() async {
    _validateUser();
  }

  void _validateUser() async {
    try {
      await SharedPreference().sharedPreference;
      await FirebaseMessagingService().initializeNotificationSettings();

      _setNotifications();
    } catch (error) {
      _notificationNavigationClass.clearAppDataMethod(context: context);
    }
  }

  void _setNotifications() async {
    FirebaseMessagingService().foregroundNotification();
    FirebaseMessagingService().backgroundTapNotification();
  }


  // _validateUser(context) async {
  //   await SharedPreference().sharedPreference;
  //
  //   if (SharedPreference().getUser() != null) {
  //
  //     _userProvider = Provider.of<UserProvider>(context, listen: false);
  //     _userProvider?.setCurrentUser(
  //         user: User.fromJson(
  //             jsonDecode(SharedPreference().getUser()!)));
  //     print("role ${_userProvider?.getCurrentUser?.role}");
  //     String? role = _userProvider?.getCurrentUser?.role;
  //     if (role == AuthRole.user.name) {
  //       _authRoleProvider?.setRole(role: AuthRole.user.name);
  //       AppNavigation.navigateToRemovingAll(
  //         context,
  //         AppRouteName.MAIN_SCREEN_ROUTE,
  //         arguments: MainScreenRoutingArgument(
  //           index: 1,
  //         ),
  //       );
  //     } else if (role == AuthRole.business.name) {
  //       _authRoleProvider?.setRole(role: AuthRole.business.name);
  //       AppNavigation.navigateToRemovingAll(
  //         context,
  //         AppRouteName.MAIN_SCREEN_ROUTE,
  //         arguments: MainScreenRoutingArgument(
  //           index: 0,
  //         ),
  //       );
  //     }
  //   } else {
  //     print("In  splash : user null ");
  //     AppNavigation.navigateToRemovingAll(
  //         context, AppRouteName.ROLE_SELECTION_SCREEN_ROUTE);
  //   }
  // }
}
