import 'dart:convert';
import 'dart:developer';
import 'package:customer_service_provider_hybrid/auth/enums/auth_roles.dart';
import 'package:customer_service_provider_hybrid/auth/model/user_model.dart';
import 'package:customer_service_provider_hybrid/auth/providers/auth_role_provider.dart';
import 'package:customer_service_provider_hybrid/auth/providers/user_provider.dart';
import 'package:customer_service_provider_hybrid/business_module/Reviews/routing_arguments/business_reviews_arguments.dart';
import 'package:customer_service_provider_hybrid/chat/routing_arguments/inbox_routing_argument.dart';
import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/notification/arguments/notification_arguments.dart';
import 'package:customer_service_provider_hybrid/services/shared_preference.dart';
import 'package:customer_service_provider_hybrid/services_detail/routing_arguments/service_detail_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/settings/enums/notification_type.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/enum.dart';
import 'package:customer_service_provider_hybrid/utils/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class NotificationNavigationClass {
  UserProvider? _userProvider;
  AuthRoleProvider? _authRoleProvider;
  String? _role;

  void notificationMethod(
      {required BuildContext context,
      Map<String, dynamic>? notificationData,
      String? pushNotificationType}) {
    _setUserSession(context: context);

    print ("Notification Data ha :${notificationData}");

    if (notificationData != null) {
      // //when new event added go to home screen

      //If related to userRole
      if (_role == AuthRole.user.name) {
        if (notificationData["type"] ==
            NotificationNavigationType.Service.name) {
          _serviceDetailNavigationMethod(
              context: context,
              notificationData: notificationData,
              pushNotificationType: pushNotificationType);
        } else if (notificationData["type"] ==
            NotificationNavigationType.CHAT.name) {
          _chatNavigationMethod(
              context: context,
              notificationData: notificationData,
              pushNotificationType: pushNotificationType);
        } else if (notificationData["type"] ==
            NotificationNavigationType.Admin.name) {
          _adminNotificationNavigationMethod(
              context: context,
              notificationData: notificationData,
              pushNotificationType: pushNotificationType);
        }

        else {
          _navigateRoleScreen(context: context);
        }

        //If related to businessRole
      } else if (_role == AuthRole.business.name) {
        if (notificationData["type"] ==
            NotificationNavigationType.Review.name) {
          _reviewListNavigationMethod(
              context: context,
              notificationData: notificationData,
              pushNotificationType: pushNotificationType);
        }
        else if (notificationData["type"] ==
            NotificationNavigationType.CHAT.name) {
          _chatNavigationMethod(
              context: context,
              notificationData: notificationData,
              pushNotificationType: pushNotificationType);
        } else if (notificationData["type"] ==
            NotificationNavigationType.Admin.name) {
          _adminNotificationNavigationMethod(
              context: context,
              notificationData: notificationData,
              pushNotificationType: pushNotificationType);
        }


        else {
          _navigateRoleScreen(context: context);
        }
      } else {
        _navigateRoleScreen(context: context);
      }
    } else {
      _navigateRoleScreen(context: context);
    }
  }

  void checkUserSessionMethod({required BuildContext context}) {
    if (SharedPreference().getUser() != null) {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      _userProvider?.setCurrentUser(
          user: User.fromJson(jsonDecode(SharedPreference().getUser()!)));
      _authRoleProvider = Provider.of<AuthRoleProvider>(context, listen: false);
      // print("role ${_userProvider?.getCurrentUser?.role}");
      _role = _userProvider?.getCurrentUser?.role;
      _authRoleProvider?.setRole(role: _role);
      _navigateRoleScreen(context: context);
    } else {
      clearAppDataMethod(context: context);
    }
  }

  void _setUserSession({required BuildContext context}) {
    if (SharedPreference().getUser() != null) {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      _authRoleProvider = Provider.of<AuthRoleProvider>(context, listen: false);
      // print("role ${_userProvider?.getCurrentUser?.role}");

      if (_userProvider?.getCurrentUser == null) {
        _userProvider?.setCurrentUser(
            user: User.fromJson(jsonDecode(SharedPreference().getUser()!)));

        _role = _userProvider?.getCurrentUser?.role;
        _authRoleProvider?.setRole(role: _role);
      }
    }
  }

  void _serviceDetailNavigationMethod(
      {required BuildContext context,
      Map<String, dynamic>? notificationData,
      String? pushNotificationType}) {
    print("Notification Data:${notificationData?["type_id"]}");
    // print("Notification Data:${notificationData?["type_id"] is int}");

    if (pushNotificationType == AppStrings.FOREGROUND_NOTIFICATION ||
        pushNotificationType == AppStrings.BACKGROUND_NOTIFICATION) {
      AppNavigation.navigateTo(
          context, AppRouteName.SERVICE_DETAIL_SCREEN_ROUTE,
          arguments: ServiceDetailArguments(
            serviceId: int.parse(notificationData?["type_id"] ?? "0"),
          ));
    } else {
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.SERVICE_DETAIL_SCREEN_ROUTE,
          arguments: ServiceDetailArguments(
              serviceId: int.parse(notificationData?["type_id"] ?? "0"),
              notificationNavigationEnable: true));
    }
  }

  void _reviewListNavigationMethod(
      {required BuildContext context,
      Map<String, dynamic>? notificationData,
      String? pushNotificationType}) {
    print("Notification Data:${notificationData?["type_id"]}");
    // print("Notification Data:${notificationData?["type_id"] is int}");

    if (pushNotificationType == AppStrings.FOREGROUND_NOTIFICATION ||
        pushNotificationType == AppStrings.BACKGROUND_NOTIFICATION) {
      AppNavigation.navigateTo(
          context, AppRouteName.BUSINESS_REVIEWS_SCREEN_ROUTE,
          arguments: BusinessReviewsArguments(
              companyId: int.parse(
            notificationData?["type_id"] ?? "0",
          )));
    } else {
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.BUSINESS_REVIEWS_SCREEN_ROUTE,
          arguments: BusinessReviewsArguments(
              companyId: int.parse(
                notificationData?["type_id"] ?? "0",
              ),
              notificationNavigationEnable: true));
    }
  }

  void _chatNavigationMethod(
      {required BuildContext context,
      Map<String, dynamic>? notificationData,
      String? pushNotificationType}) {
    int? _friendId = notificationData!["type_id"] != null
        ? int.parse(notificationData["type_id"])
        : null;

    if (pushNotificationType == AppStrings.FOREGROUND_NOTIFICATION ||
        pushNotificationType == AppStrings.BACKGROUND_NOTIFICATION) {
      if (StaticData.chatRouting == AppRouteName.INBOX_SCREEN_ROUTE &&
          _friendId == StaticData.chatFriendId) {
        log("no data");
      } else if (StaticData.chatRouting == AppRouteName.INBOX_SCREEN_ROUTE &&
          _friendId != StaticData.chatFriendId) {
        AppNavigation.navigateReplacementNamed(
            context, AppRouteName.INBOX_SCREEN_ROUTE,
            arguments: InboxRoutingArgument(
                id: _friendId,
                name: notificationData["sender_name"],
               image: notificationData["sender_image"],
        ));
      } else {
        AppNavigation.navigateTo(context, AppRouteName.INBOX_SCREEN_ROUTE,
            arguments: InboxRoutingArgument(
                id: _friendId,
                name: notificationData["sender_name"],
                image: notificationData["sender_image"],
            )
        );
      }
    } else {
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.INBOX_SCREEN_ROUTE,
          arguments: InboxRoutingArgument(
              id: _friendId,
              name: notificationData["sender_name"],
              image: notificationData["sender_image"],
              notificationNavigationEnable: true)
      );
    }
  }




  void _adminNotificationNavigationMethod(
      {required BuildContext context,
        Map<String, dynamic>? notificationData,
        String? pushNotificationType}) {
    print("Notification Data:${notificationData?["type_id"]}");
    // print("Notification Data:${notificationData?["type_id"] is int}");

    if (pushNotificationType == AppStrings.FOREGROUND_NOTIFICATION ||
        pushNotificationType == AppStrings.BACKGROUND_NOTIFICATION) {
      AppNavigation.navigateTo(
          context, AppRouteName.NOTIFICATION_SCREEN_ROUTE,
      );
    } else {
      AppNavigation.navigateToRemovingAll(
          context, AppRouteName.NOTIFICATION_SCREEN_ROUTE,
          arguments: NotificationArguments(
            notificationNavigationEnable: true
          )
      );
    }
  }



  void _navigateRoleScreen({required BuildContext context}) {
    if (_role == AuthRole.user.name) {
      print("Check role:${_role}");

      // _authRoleProvider?.setRole(role: AuthRole.user.name);
      AppNavigation.navigateToRemovingAll(
        context,
        AppRouteName.MAIN_SCREEN_ROUTE,
        arguments: MainScreenRoutingArgument(
          index: 1,
        ),
      );
    } else if (_role == AuthRole.business.name) {
      //_authRoleProvider?.setRole(role: AuthRole.business.name);
      AppNavigation.navigateToRemovingAll(
        context,
        AppRouteName.MAIN_SCREEN_ROUTE,
        arguments: MainScreenRoutingArgument(
          index: 0,
        ),
      );
    }
  }

  void clearAppDataMethod({required BuildContext context}) {
    AppNavigation.navigateToRemovingAll(
        context, AppRouteName.ROLE_SELECTION_SCREEN_ROUTE);
    SharedPreference().clear();
  }
}
