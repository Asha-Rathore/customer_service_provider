import 'dart:developer';

import 'package:customer_service_provider_hybrid/auth/arguments/otp_arguments.dart';
import 'package:customer_service_provider_hybrid/auth/screens/login_screen.dart';
import 'package:customer_service_provider_hybrid/auth/screens/otp_verification_screen.dart';
import 'package:customer_service_provider_hybrid/auth/screens/prelogin_screen.dart';
import 'package:customer_service_provider_hybrid/auth/screens/role_selection_screen.dart';
import 'package:customer_service_provider_hybrid/auth/screens/signup_screen.dart';
import 'package:customer_service_provider_hybrid/business_module/Reviews/routing_arguments/business_reviews_arguments.dart';
import 'package:customer_service_provider_hybrid/business_module/Reviews/screen/reviews_screen.dart';
import 'package:customer_service_provider_hybrid/business_module/card/screens/add_new_card_screen.dart';
import 'package:customer_service_provider_hybrid/business_module/card/screens/card_details_screen.dart';
import 'package:customer_service_provider_hybrid/business_module/service/routing_arguments/service_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/business_module/service/screen/add_or_edit_service_screen.dart';
import 'package:customer_service_provider_hybrid/business_module/subscription/screens/subscription_plan_screen.dart';
import 'package:customer_service_provider_hybrid/chat/routing_arguments/inbox_routing_argument.dart';
import 'package:customer_service_provider_hybrid/chat/screens/inbox_screen.dart';
import 'package:customer_service_provider_hybrid/content/enums/user_agreement.dart';
import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/notification/arguments/notification_arguments.dart';
import 'package:customer_service_provider_hybrid/notification/screen/notification_screen.dart';
import 'package:customer_service_provider_hybrid/password/routing_arguments/reset_password_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/password/screens/change_password_screen.dart';
import 'package:customer_service_provider_hybrid/password/screens/forgot_password_screen.dart';
import 'package:customer_service_provider_hybrid/password/screens/reset_password_screen.dart';
import 'package:customer_service_provider_hybrid/profile/arguments/complete_profile_arguments.dart';
import 'package:customer_service_provider_hybrid/profile/screen/complete_profile.dart';
import 'package:customer_service_provider_hybrid/profile/screen/edit_profile.dart';
import 'package:customer_service_provider_hybrid/services_detail/routing_arguments/service_detail_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/services_detail/screen/services_detail_screen.dart';
import 'package:customer_service_provider_hybrid/settings/screen/settings_screen.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/arguments/company_profile_arguments.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/screen/company_profile_screen.dart';
import 'package:customer_service_provider_hybrid/user_module/custom_service_provider/screen/customer_service_provider.dart';
import 'package:customer_service_provider_hybrid/user_module/favorites/arguments/favorite_arguments.dart';
import 'package:customer_service_provider_hybrid/user_module/favorites/screen/favorite_screen.dart';
import 'package:customer_service_provider_hybrid/user_module/service_provider_number/screens/service_provider_number_screen.dart';
import 'package:flutter/material.dart';
import '../content/routing_arguments/content_routing_argument.dart';
import '../content/screen/content_screen.dart';
import '../main_screen/screen/main_screen.dart';
import '../splash/screen/splash_screen.dart';
import '../user_module/custom_service_provider/routing_arguments/customer_service_provider_arguments.dart';
import 'app_route_name.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
      settings: routeSettings,
      builder: (BuildContext context) {
        switch (routeSettings.name) {
          case AppRouteName.SPLASH_SCREEN_ROUTE:
            return SplashScreen();
          case AppRouteName.ROLE_SELECTION_SCREEN_ROUTE:
            return RoleSelectionScreen();
          case AppRouteName.PRE_LOGIN_SCREEN_ROUTE:
            return PreLoginScreen();
          case AppRouteName.LOGIN_SCREEN_ROUTE:
            return LoginScreen();
          case AppRouteName.SIGNUP_SCREEN_ROUTE:
            return SignupScreen();
          case AppRouteName.FORGET_PASSWORD_SCREEN_ROUTE:
            return ForgotPasswordScreen();
          case AppRouteName.RESET_PASSWORD_SCREEN_ROUTE:
            ResetPasswordRoutingArguments? resetPasswordRoutingArguments =
                routeSettings.arguments as ResetPasswordRoutingArguments?;
            return ResetPasswordScreen(
                userId: resetPasswordRoutingArguments?.userId);
          case AppRouteName.OTP_VERIFICATION_SCREEN_ROUTE:
            // final args = routeSettings.arguments as bool?;
            OtpVerficationArguments? otpVerficationArguments =
                routeSettings.arguments as OtpVerficationArguments?;
            return OtpVerificationScreen(
              isProfile: otpVerficationArguments?.isProfile ?? false,
              emailAddress: otpVerficationArguments?.emailAddress ?? "",
              fullName: otpVerficationArguments?.fullName ?? "",
              userId: otpVerficationArguments?.userId,
              otpType: otpVerficationArguments?.otpVerificationType,
            );

          case AppRouteName.CONTENT_SCREEN_ROUTE:
            ContentRoutingArgument? contentRoutingArgument =
                routeSettings.arguments as ContentRoutingArgument?;
            return ContentScreen(
              title: contentRoutingArgument?.title ?? "",
              contentType: contentRoutingArgument?.contentType ?? "",
            );

          case AppRouteName.MAIN_SCREEN_ROUTE:
            MainScreenRoutingArgument? mainScreenRoutingArgument =
                routeSettings.arguments as MainScreenRoutingArgument?;
            return MainScreen(selectedIndex: mainScreenRoutingArgument!.index!);

          case AppRouteName.NOTIFICATION_SCREEN_ROUTE:
            NotificationArguments? notificationArgument =
                routeSettings.arguments as NotificationArguments?;
            return NotificationScreen(
              notificationNavigationEnable:
                  notificationArgument?.notificationNavigationEnable,
            );
          case AppRouteName.SETTING_SCREEN_ROUTE:
            return SettingScreen();
          case AppRouteName.CHANGE_PASSWORD_SCREEN_ROUTE:
            return ChangePasswordScreen();
          case AppRouteName.FAVORITE_SCREEN_ROUTE:
            FavoriteArguments? favoriteArguments =
                routeSettings.arguments as FavoriteArguments?;
            return FavoriteScreen(
              userid: favoriteArguments?.userId ?? 0,
            );

          case AppRouteName.SERVICE_DETAIL_SCREEN_ROUTE:
            ServiceDetailArguments? serviceDetailArguments =
                routeSettings.arguments as ServiceDetailArguments?;
            return ServicesDetailScreen(
              serviceId: serviceDetailArguments?.serviceId,
              notificationNavigationEnable:
                  serviceDetailArguments?.notificationNavigationEnable,
            );

          case AppRouteName.COMPANY_PROFILE_SCREEN_ROUTE:
            CompanyProfileArguments? companyProfileArgument =
                routeSettings.arguments as CompanyProfileArguments?;
            return CompanyProfileScreen(
              index: companyProfileArgument?.index,
              isFavourite: companyProfileArgument?.isFavourite,
              companyId: companyProfileArgument?.companyId,
            );

          case AppRouteName.INBOX_SCREEN_ROUTE:
            InboxRoutingArgument? inboxRoutingArgument =
                routeSettings.arguments as InboxRoutingArgument?;
            return InboxScreen(
              name: inboxRoutingArgument?.name,
              image: inboxRoutingArgument?.image,
              id: inboxRoutingArgument?.id,
              notificationNavigationEnable:
                  inboxRoutingArgument?.notificationNavigationEnable,
            );

          case AppRouteName.COMPLETE_PROFILE_SCREEN_ROUTE:
            CompleteProfileArguments? completeProfileArguments =
                routeSettings.arguments as CompleteProfileArguments?;
            return CompleteProfile(
              fullName: completeProfileArguments?.fullName ?? "",
              emailAddress: completeProfileArguments?.emailAddress ?? "",
              token: completeProfileArguments?.token ?? "",
            );

          case AppRouteName.EDIT_PROFILE_SCREEN_ROUTE:
            final args = routeSettings.arguments as ValueChanged<dynamic>?;
            return EditProfileScreen(addCard: args);

          //------------------- BUSINESS INTERFACE ----------------//

          case AppRouteName.ADD_OR_EDIT_SERVICE_SCREEN_ROUTE:
            ServiceScreenRoutingArgument? serviceScreenRoutingArgument =
                routeSettings.arguments as ServiceScreenRoutingArgument?;
            return AddOrEditServiceScreen(
              isEditService: serviceScreenRoutingArgument!.isEditService,
              isFromProfile: serviceScreenRoutingArgument.isFromProfile,
              serviceId: serviceScreenRoutingArgument.serviceid,
              serviceImage: serviceScreenRoutingArgument.serviceImage,
              serviceName: serviceScreenRoutingArgument.serviceName,
              location: serviceScreenRoutingArgument.location,
              description: serviceScreenRoutingArgument.description,
            );
          case AppRouteName.SUBSCRIPTION_PLAN_SCREEN_ROUTE:
            final args = routeSettings.arguments as bool?;
            return SubscriptionPlanScreen(isFromProfile: args);
          case AppRouteName.CARD_DETAIL_SCREEN_ROUTE:
            return CardDetailScreen();
          case AppRouteName.ADD_NEW_CARD_SCREEN_ROUTE:
            return AddNewCardScreen();
          case AppRouteName.SERVICE_PROVIDER_NUMBER_SCREEN_ROUTE:
            return ServiceProviderNumberScreen();

          case AppRouteName.customerServiceProviderScreenRoute:
            CustomerServiceProviderArguments? customerServiceProviderArguments =
                routeSettings.arguments as CustomerServiceProviderArguments?;
            return CustomerServiceProviderScreen(
              companyLanguages:
                  customerServiceProviderArguments?.companyLanguages,
            );
          case AppRouteName.BUSINESS_REVIEWS_SCREEN_ROUTE:
            BusinessReviewsArguments? businessReviewsArguments =
                routeSettings.arguments as BusinessReviewsArguments?;
            return BusinessReviewsScreen(
              companyId: businessReviewsArguments?.companyId,
              notificationNavigationEnable:
                  businessReviewsArguments?.notificationNavigationEnable,
            );
          default:
            return Container();
        }
      },
    );
  }
}
