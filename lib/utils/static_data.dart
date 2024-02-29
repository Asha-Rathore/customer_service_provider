import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/providers/user_provider.dart';
import '../services/shared_preference.dart';
import 'app_navigation.dart';
import 'app_route_name.dart';

class StaticData {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static String? chatRouting;
  static int? chatFriendId;


  static clearAllAppData({required BuildContext context}) {
    print("all data");
    UserProvider _userProvider =
    Provider.of<UserProvider>(context, listen: false);
    if (_userProvider.getCurrentUser != null) {
      _userProvider.clearCurrentUser();
      SharedPreference().clear();
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.ROLE_SELECTION_SCREEN_ROUTE);
    }
  }

//If there is some error on splash when initializing notification then in try catch this method call
  static cleaAppDataOnError({required BuildContext context}) {
    print("all data");
    UserProvider _userProvider =
    Provider.of<UserProvider>(context, listen: false);
    _userProvider.clearCurrentUser();
    SharedPreference().clear();
    AppNavigation.navigateToRemovingAll(
        context, AppRouteName.PRE_LOGIN_SCREEN_ROUTE);

  }
}
