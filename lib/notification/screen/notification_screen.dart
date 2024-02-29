import 'package:customer_service_provider_hybrid/auth/enums/auth_roles.dart';
import 'package:customer_service_provider_hybrid/auth/model/user_model.dart';
import 'package:customer_service_provider_hybrid/auth/providers/auth_role_provider.dart';
import 'package:customer_service_provider_hybrid/auth/providers/user_provider.dart';
import 'package:customer_service_provider_hybrid/business_module/Reviews/routing_arguments/business_reviews_arguments.dart';
import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/notification/bloc/delete_notification_bloc.dart';
import 'package:customer_service_provider_hybrid/notification/model/notification_model.dart';
import 'package:customer_service_provider_hybrid/notification/provider/notifications_provider.dart';
import 'package:customer_service_provider_hybrid/notification/widget/notification_container.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/enum.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../services_detail/routing_arguments/service_detail_routing_arguments.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_not_found_text_refresh_indicator_widget.dart';
import '../../widgets/custom_padding.dart';
import '../../widgets/custom_refresh_indicator_widget.dart';
import '../../widgets/custom_sizebox.dart';

class NotificationScreen extends StatefulWidget {
  final bool? notificationNavigationEnable;

  NotificationScreen({this.notificationNavigationEnable});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationsListProvider? _notificationsListProvider;
  DeleteNotificationBloc _deleteNotificationBloc = DeleteNotificationBloc();

  User? _user;
  String? _role;

  @override
  void initState() {
    super.initState();
    _getNotificationsList();
  }

  Future<void> _getNotificationsList() async {
    _user = context.read<UserProvider>().getCurrentUser;
    _role = context.read<AuthRoleProvider>().role;

    _notificationsListProvider = context.read<NotificationsListProvider>();
    await _notificationsListProvider?.getNotificationsListProviderMethod(
        context: context);
  }

  void _initializeProvider() {
    _notificationsListProvider = context.watch<NotificationsListProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _initializeProvider();
    return WillPopScope(
      onWillPop: () async {
        _backMethod();
        return true;
      },
      child: CustomAppTemplate(
        title: AppStrings.NOTIFICATION,
        onClickLead: (){
          _backMethod();
        },
        child: CustomRefreshIndicatorWidget(
            onRefresh: _getNotificationsList,
            child: _notificationsListProvider?.waitingStatus == true
                ? Center(child: AppDialogs.circularProgressWidget())
                : _buildList()),
      ),
    );
  }

  Widget _buildList() {
    return _notificationsListProvider?.waitingStatus == true
        ? AppDialogs.circularProgressWidget()
        : _notificationsListProvider?.getNotificationsList != null
            ? _customColumn()
            : CustomDataNotFoundForRefreshIndicatorTextWidget(
                notFoundText: AppStrings.NOTIFICATIONS_NOT_FOUND_ERROR);
  }

  Widget _customColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizeBox(height: 15.h),
        // _todayText(),
        // CustomSizeBox(height: 15.h),
        _chatListView(
            notificationsData:
                _notificationsListProvider?.getNotificationsList?.data),
      ],
    );
  }

  Widget _todayText() {
    return CustomPadding(
      child: CustomText(
        text: AppStrings.TODAY,
        fontColor: AppColors.THEME_COLOR_PURPLE,
        // fontweight: FontWeight.bold,
        fontSize: 17.sp,
        textAlign: TextAlign.left,
        fontFamily: AppFonts.Jost_SemiBold,
      ),
    );
  }

  Widget _chatListView({List<NotificationsModelData?>? notificationsData}) {
    return Expanded(
      child: ListView.builder(
        itemCount: notificationsData?.length,
        itemBuilder: ((context, index) {
          return NotificationContainer(
            isSlideEnable: true,
            title: notificationsData?[index]?.title,
            detail: notificationsData?[index]?.message,
            date: notificationsData?[index]?.createdAt,
            onTapDelete: () {
              _deleteNotificationTap(
                  context: context,
                  notificationId: notificationsData?[index]?.id,
                  index: index);
            },
            onTap: () {
              if (notificationsData?[index]?.type ==
                  NotificationNavigationType.Review.name) {
                AppNavigation.navigateTo(
                    context, AppRouteName.BUSINESS_REVIEWS_SCREEN_ROUTE,
                    arguments: BusinessReviewsArguments(
                      companyId: notificationsData?[index]?.typeId,
                    ));
              } else if (notificationsData?[index]?.type ==
                  NotificationNavigationType.Service.name) {
                AppNavigation.navigateTo(
                    context, AppRouteName.SERVICE_DETAIL_SCREEN_ROUTE,
                    arguments: ServiceDetailArguments(
                      serviceId: notificationsData?[index]?.typeId,
                    ));
              } else if (notificationsData?[index]?.type ==
                  NotificationNavigationType.Admin.name) {
                if (_user?.role == AuthRole.user.name) {
                  AppNavigation.navigateToRemovingAll(
                    context,
                    AppRouteName.MAIN_SCREEN_ROUTE,
                    arguments: MainScreenRoutingArgument(
                      index: 1,
                    ),
                  );
                } else if (_user?.role == AuthRole.business.name) {
                  AppNavigation.navigateToRemovingAll(
                    context,
                    AppRouteName.MAIN_SCREEN_ROUTE,
                    arguments: MainScreenRoutingArgument(
                      index: 0,
                    ),
                  );
                }
              }
            },
          );
        }),
      ),
    );
  }

  void _deleteNotificationTap(
      {required BuildContext context,
      int? notificationId,
      required int index}) {
    AppDialogs().showCustomConfirmationDialog(
      context,
      title: AppStrings.ARE_YOU_SURE,
      description: AppStrings.DO_YOU_WANT_TO_DELETE_THIS_NOTIFICATION,
      button1Text: AppStrings.NO,
      button2Text: AppStrings.YES,
      onTapYes: () {
        _deleteNotificationMethod(
            context: context, notificationId: notificationId, index: index);
      },
      onTapNo: () {},
    );
  }

  void _deleteNotificationMethod(
      {required BuildContext context,
      int? notificationId,
      required int index}) {
    _deleteNotificationBloc.deleteNotification(
      context: context,
      notificationId: notificationId.toString(),
      setProgressBar: () {
        AppDialogs.progressAlertDialog(context: context);
      },
      onApiSuccess: () {
        _notificationsListProvider?.removeNotification(index: index);
      },
    );
  }



  void _backMethod() {
    if (widget.notificationNavigationEnable == true) {
      if (_role == AuthRole.user.name) {
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.MAIN_SCREEN_ROUTE,
          arguments: MainScreenRoutingArgument(
            index: 1,
          ),
        );
      } else if (_role == AuthRole.business.name) {
        AppNavigation.navigateToRemovingAll(
          context,
          AppRouteName.MAIN_SCREEN_ROUTE,
          arguments: MainScreenRoutingArgument(
            index: 0,
          ),
        );
      }
    } else {
      AppNavigation.navigatorPop(context);
    }
  }
}
