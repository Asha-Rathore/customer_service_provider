import 'dart:io';

import 'package:customer_service_provider_hybrid/business_module/home/screen/home_screen.dart';
import 'package:customer_service_provider_hybrid/business_module/service/screen/add_or_edit_service_screen.dart';
import 'package:customer_service_provider_hybrid/chat/screens/chat_screen.dart';
import 'package:customer_service_provider_hybrid/main_screen/bottom_bar_widget.dart';
import 'package:customer_service_provider_hybrid/profile/screen/profile_screen.dart';
import 'package:customer_service_provider_hybrid/user_module/home/screen/home.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_shadows.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_drawer.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../auth/enums/auth_roles.dart';
import '../../auth/providers/auth_role_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../utils/asset_paths.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_confirmation_dialog.dart';

class MainScreen extends StatefulWidget {
  final int? selectedIndex;

  const MainScreen({Key? key, this.selectedIndex = 1}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  AuthRoleProvider? _authRoleProvider;

  List<Widget> userPages = <Widget>[
    ChatScreen(),
    UserHomeScreen(),
    ProfileScreen(),
  ];

  List<Widget> businessPages = [
    BusinessHomeScreen(),
    AddOrEditServiceScreen(isEditService: false, isFromProfile: false),
    ChatScreen(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) {
              return _exitDialog();
            })) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    _authRoleProvider = context.read<AuthRoleProvider>();
    _selectedIndex = widget.selectedIndex!;
  }

  @override
  Widget build(BuildContext context) {
    _authRoleProvider = context.watch<AuthRoleProvider>();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: AppColors.THEME_COLOR_WHITE,
        drawer: CustomDrawer(),
        appBar: _appBar(context),
        body: _authRoleProvider?.role == AuthRole.user.name
            ? userPages.elementAt(_selectedIndex)
            : businessPages.elementAt(_selectedIndex),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Transform.translate(
          offset: Offset(0, 6),
          child: _authRoleProvider?.role == AuthRole.user.name
              ? _userFloatingActionButton()
              : _businessFloatingActionButton(),
        ),
        bottomNavigationBar: _customBottomBar(),
        extendBody: false,
      ),
    );
  }

  Widget _customBottomBar() {
    return BottomNavigationView(
      firstChild: GestureDetector(
        onTap: () {
          print("ON TAP 0");
          _onItemTapped(0);
        },
        child: _authRoleProvider?.role == AuthRole.user.name
            ? _userBottomItem(
                text: AppStrings.USER_APP_BAR_TITLE[0],
                icon: _selectedIndex == 0
                    ? AssetPath.CHAT_WITH_DOTS_ICON
                    : AppStrings.USER_NAV_BAR_ITEMS[0],
                color: _selectedIndex == 0
                    ? AppColors.THEME_COLOR_PURPLE
                    : AppColors.THEME_COLOR_LIGHT_GREY,
              )
            : _businessBottomItem(
                text: AppStrings.HOME,
                icon: _selectedIndex == 0
                    ? AssetPath.HOME_ICON
                    : AssetPath.HOME_OUTLINE_ICON,
                color: _selectedIndex == 0
                    ? AppColors.THEME_COLOR_PURPLE
                    : AppColors.THEME_COLOR_LIGHT_GREY,
              ),
      ),
      secondChild: GestureDetector(
        onTap: () {
          _onItemTapped(2);
        },
        child: _authRoleProvider?.role == AuthRole.user.name
            ? _userBottomItem(
                text: AppStrings.USER_APP_BAR_TITLE[2],
                icon: _selectedIndex == 2
                    ? AssetPath.PERSON_ICON
                    : AppStrings.USER_NAV_BAR_ITEMS[2],
                color: _selectedIndex == 2
                    ? AppColors.THEME_COLOR_PURPLE
                    : AppColors.THEME_COLOR_LIGHT_GREY,
              )
            : _businessBottomItem(
                text: AppStrings.CHAT,
                icon: _selectedIndex == 2
                    ? AssetPath.CHAT_WITH_DOTS_ICON
                    : AssetPath.CHAT_OUTLINE_ICON,
                color: _selectedIndex == 2
                    ? AppColors.THEME_COLOR_PURPLE
                    : AppColors.THEME_COLOR_LIGHT_GREY,
              ),
      ),
    );
  }

  // Widget _customBottomBar() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 12.0),
  //     child: BottomAppBar(
  //       color: Colors.transparent,
  //       elevation: 0,
  //       child: CustomPadding(
  //         child: Container(
  //             height: 55.h,
  //             decoration: const BoxDecoration(
  //               color: AppColors.THEME_COLOR_TRANSPARENT,
  //               image: DecorationImage(
  //                 image: AssetImage(
  //                   AssetPath.NAV_BAR_ICON,
  //                 ),
  //                 fit: BoxFit.cover,
  //                 scale: 3,
  //               ),
  //             ),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       _onItemTapped(0);
  //                     },
  //                     child: _authRoleProvider?.role == AuthRole.user.name
  //                         ? _userBottomItem(
  //                             text: AppStrings.USER_APP_BAR_TITLE[0],
  //                             icon: _selectedIndex == 0
  //                                 ? AssetPath.CHAT_WITH_DOTS_ICON
  //                                 : AppStrings.USER_NAV_BAR_ITEMS[0],
  //                             color: _selectedIndex == 0
  //                                 ? AppColors.THEME_COLOR_PURPLE
  //                                 : AppColors.THEME_COLOR_LIGHT_GREY,
  //                           )
  //                         : _businessBottomItem(
  //                             text: AppStrings.HOME,
  //                             icon: _selectedIndex == 0
  //                                 ? AssetPath.HOME_ICON
  //                                 : AssetPath.HOME_OUTLINE_ICON,
  //                             color: _selectedIndex == 0
  //                                 ? AppColors.THEME_COLOR_PURPLE
  //                                 : AppColors.THEME_COLOR_LIGHT_GREY,
  //                           ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       _onItemTapped(2);
  //                     },
  //                     child: _authRoleProvider?.role == AuthRole.user.name
  //                         ? _userBottomItem(
  //                             text: AppStrings.USER_APP_BAR_TITLE[2],
  //                             icon: _selectedIndex == 2
  //                                 ? AssetPath.PERSON_ICON
  //                                 : AppStrings.USER_NAV_BAR_ITEMS[2],
  //                             color: _selectedIndex == 2
  //                                 ? AppColors.THEME_COLOR_PURPLE
  //                                 : AppColors.THEME_COLOR_LIGHT_GREY,
  //                           )
  //                         : _businessBottomItem(
  //                             text: AppStrings.CHAT,
  //                             icon: _selectedIndex == 2
  //                                 ? AssetPath.CHAT_WITH_DOTS_ICON
  //                                 : AssetPath.CHAT_OUTLINE_ICON,
  //                             color: _selectedIndex == 2
  //                                 ? AppColors.THEME_COLOR_PURPLE
  //                                 : AppColors.THEME_COLOR_LIGHT_GREY,
  //                           ),
  //                   ),
  //                 ),
  //               ],
  //             )),
  //       ),
  //     ),
  //   );
  // }

  Widget _userBottomItem({text, icon, color}) {
    return Container(
      color: AppColors.THEME_COLOR_TRANSPARENT,
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _icon(
            icon: icon,
            scale: icon == AssetPath.CHAT_WITH_DOTS_ICON ? 2.5 : 3,
            color: color,
          ),
          CustomSizeBox(height: 5.h),
          _text(text, color),
        ],
      ),
    );
  }

  Widget _businessBottomItem({text, icon, color}) {
    return Container(
      color: AppColors.THEME_COLOR_TRANSPARENT,
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _icon(
            icon: icon,
            scale: icon == AssetPath.CHAT_WITH_DOTS_ICON ? 2.5 : 3,
            color: color,
          ),
          CustomSizeBox(height: 5.h),
          _text(text, color),
        ],
      ),
    );
  }

  Widget _userFloatingActionButton() {
    return Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
      child: Padding(
        padding: EdgeInsets.only(bottom: 6.w),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: AppShadow.boxShadow(
                  color: AppColors.THEME_COLOR_PURPLE.withOpacity(0.3))),
          child: FloatingActionButton(
            backgroundColor: _selectedIndex == 1
                ? AppColors.THEME_COLOR_PURPLE
                : AppColors.THEME_COLOR_WHITE,
            onPressed: () {
              _onItemTapped(1);
            },
            child: _icon(
              icon: AppStrings.USER_NAV_BAR_ITEMS[1],
              scale: 3.5,
              color: _selectedIndex == 1
                  ? AppColors.THEME_COLOR_WHITE
                  : AppColors.THEME_COLOR_PURPLE,
            ),
          ),
        ),
      ),
    );
  }

  Widget _businessFloatingActionButton() {
    return Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
      child: Padding(
        padding: EdgeInsets.only(bottom: 6.w),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: FloatingActionButton(
            backgroundColor: AppColors.THEME_COLOR_PURPLE,
            onPressed: () {
              _onItemTapped(1);
            },
            child: _icon(
              icon: AssetPath.PLUS_ICON,
              scale: 3.5,
            ),
          ),
        ),
      ),
    );
  }

  CustomAppBar _appBar(context) {
    return CustomAppBar(
      title: _authRoleProvider?.role == AuthRole.user.name
          ? AppStrings.USER_APP_BAR_TITLE[_selectedIndex]
          : AppStrings.BUSINESS_APP_BAR_TITLE[_selectedIndex],
      leading: AssetPath.MENU_ICON,
      showAction: true,
      leadingIconScale: 2.5.sp,
      actionWidget: _authRoleProvider?.role == AuthRole.user.name
          ? _icon(
              icon: _selectedIndex == 2
                  ? AssetPath.EDIT_ROUNDED_ICON
                  : AssetPath.NOTIFICATION_ICON,
              scale: 2.7,
            )
          : _selectedIndex != 1
              ? InkWell(
                  onTap: () {
                    AppNavigation.navigateTo(
                        context, AppRouteName.NOTIFICATION_SCREEN_ROUTE);
                  },
                  child: _icon(
                    icon: AssetPath.NOTIFICATION_ICON,
                    scale: 2.7,
                  ),
                )
              : null,
      onclickLead: () {
        FocusScope.of(context).unfocus();
        _scaffoldKey.currentState!.openDrawer();
      },
      onclickAction: () {
        FocusScope.of(context).unfocus();
        print("msdfnhklsdfjskldf");
        if (_authRoleProvider?.role == AuthRole.user.name) {
          if (_selectedIndex != 2) {
            AppNavigation.navigateTo(
                context, AppRouteName.NOTIFICATION_SCREEN_ROUTE);
          } else {
            AppNavigation.navigateTo(
                context, AppRouteName.EDIT_PROFILE_SCREEN_ROUTE,
                arguments: (v) {
              setState(() {});
            });
          }
        }
      },
    );
  }

  Widget _icon({String? icon, double? scale, color}) {
    return Image.asset(
      icon!,
      color: color,
      scale: scale,
    );
  }

  Widget _text(text, color) {
    return CustomText(
      text: text,
      fontColor: color,
      fontSize: 12.sp,
      // fontweight: FontWeight.w400,
      fontFamily: AppFonts.Jost_Medium,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //------------------- EXIT DIALOG ------------------//
  Widget _exitDialog() {
    return CustomConfirmationDialog(
      description: AppStrings.DO_YOU_WANT_TO_EXIT,
      button1Text: AppStrings.NO,
      button2Text: AppStrings.YES,
      onTapNo: () {},
      onTapYes: () {
        exit(0);
      },
    );
  }
}
