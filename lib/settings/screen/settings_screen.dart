import 'package:customer_service_provider_hybrid/settings/bloc/enable_notification_bloc.dart';
import 'package:customer_service_provider_hybrid/settings/widgets/push_notification_widget.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/user_provider.dart';
import '../../utils/app_dialogs.dart';
import '../bloc/delete_account_bloc.dart';
import '../enums/notification_type.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  EnableNotificationBloc _enableNotificationBloc = EnableNotificationBloc();
  DeleteAccountBloc _deleteAccountBloc = DeleteAccountBloc();
  bool enable = true;

  @override
  Widget build(BuildContext context) {
    return CustomAppTemplate(
      title: AppStrings.SETTINGS,
      isDivider: true,
      child: CustomPadding(
        child: Column(
          children: [
            _pushNotification(context),
            CustomSizeBox(height: 15.h),
            _changePasswordButton(context),
            CustomSizeBox(height: 15.h),
            _deleteAccountButton(context),
          ],
        ),
      ),
    );
  }

  Widget _pushNotification(BuildContext context){
    return Consumer<UserProvider>(builder: (context, userConsumerData, child) {
        return PushNotification(
          enable: userConsumerData.getCurrentUser?.notifications ==
              NotificationType.enable.index
              ? true
              : false,
          onChanged: (bool switchData){
            _enableNotificationBloc.enableNotificationBlocMethod(
                context: context,
                notificationEnable: switchData,
                setProgressBar: (){
                  AppDialogs.progressAlertDialog(context: context);
            });
          },
        );
      }
    );
  }

  Widget _changePasswordButton(context) {
    return CustomButton(
      onTap: () {
        AppNavigation.navigateTo(
            context, AppRouteName.CHANGE_PASSWORD_SCREEN_ROUTE);
      },
      text: AppStrings.CHANGE_PASSWORD,
      textColor: AppColors.THEME_COLOR_BLACK,
      backgroundColor: AppColors.THEME_COLOR_WHITE,
    );
  }

  Widget _deleteAccountButton(context) {
    return CustomButton(
      onTap: () {
        _deleteAccountTap(context);
      },
      text: AppStrings.DELETE_ACCOUNT,
      textColor: AppColors.THEME_COLOR_BLACK,
      backgroundColor: AppColors.THEME_COLOR_WHITE,
    );
  }

  void _deleteAccountTap(context) {
    AppDialogs().showCustomConfirmationDialog(
      context,
      title: AppStrings.ARE_YOU_SURE,
      description: AppStrings.DO_YOU_WANT_TO_DELETE_ACCOUNT,
      button1Text: AppStrings.NO,
      button2Text: AppStrings.YES,
      onTapYes: () {
        _deleteAccountMethod(context);
      },
      onTapNo: () {},
    );
  }

  void _deleteAccountMethod(BuildContext context) {
    _deleteAccountBloc.deleteAccountBlocMethod(
        context: context,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        });
  }
}
