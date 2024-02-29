import 'dart:io';

import 'package:customer_service_provider_hybrid/business_module/home/provider/services_provider.dart';
import 'package:customer_service_provider_hybrid/chat/provider/chat_messages_provider.dart';
import 'package:customer_service_provider_hybrid/chat/provider/chat_provider.dart';
import 'package:customer_service_provider_hybrid/notification/provider/notifications_provider.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/provider/company_details_provider.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/provider/reviews_list_provider.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/provider/service_detail_provider.dart';
import 'package:customer_service_provider_hybrid/user_module/favorites/provider/favorite_list_provider.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_router.dart';
import 'package:customer_service_provider_hybrid/utils/app_size.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/scroll_behaviour.dart';
import 'package:customer_service_provider_hybrid/utils/static_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

import 'auth/providers/auth_role_provider.dart';
import 'auth/providers/user_provider.dart';
import 'user_module/home/provider/get_compaines_list_provider.dart';

bool shouldUseFirebaseEmulator = false;
// late final FirebaseApp app;
// late final FirebaseAuth auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthRoleProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GetCompaniesListProvider()),
        ChangeNotifierProvider(create: (_) => GetFavoriteListProvider()),
        ChangeNotifierProvider(create: (_) => GetCompanyDetailProvider()),
        ChangeNotifierProvider(create: (_) => ServiceDetailProvider()),
        ChangeNotifierProvider(create: (_) => ReviewsListProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsListProvider()),
        ChangeNotifierProvider(create: (_) => ChatMessagesProvider()),
      ],
      child: ScreenUtilInit(
        designSize: Size(AppSize.FULL_SCREEN_WIDTH, AppSize.FULL_SCREEN_HEIGHT),
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: StaticData.navigatorKey,
            localizationsDelegates: [
              MonthYearPickerLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: AppStrings.APP_TITLE_TEXT,
            theme: ThemeData(primarySwatch: AppColors.kPrimaryColor),
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: MyScrollBehavior(),
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                ),
              );
            },
            // home: MainScreen() ,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
