import 'package:customer_service_provider_hybrid/auth/widgets/custom_auth_template.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_navigation.dart';
import '../../utils/app_route_name.dart';
import '../enums/auth_roles.dart';
import '../providers/auth_role_provider.dart';

class RoleSelectionScreen extends StatelessWidget {
  RoleSelectionScreen({Key? key}) : super(key: key);

  AuthRoleProvider? _authRoleProvider;

  @override
  Widget build(BuildContext context) {
    _authRoleProvider = context.read<AuthRoleProvider>();
    return CustomAuthTemplate(
      title: AppStrings.SELECT_YOUR_ROLE,
      isLeading: false,
      child: Column(
        children: [
          _userButton(context),
          CustomSizeBox(),
          _businessButton(context),
        ],
      ),
    );
  }

  Widget _userButton(context) {
    return CustomButton(
      onTap: () {
        _authRoleProvider?.setRole(role: AuthRole.user.name);
        AppNavigation.navigateTo(
              context, AppRouteName.PRE_LOGIN_SCREEN_ROUTE);
      },
      text: AppStrings.AS_A_USER,
    );
  }

  Widget _businessButton(context) {
    return CustomButton(
      onTap: () {
        _authRoleProvider?.setRole(role: AuthRole.business.name);
        AppNavigation.navigateTo(
              context, AppRouteName.PRE_LOGIN_SCREEN_ROUTE);
      },
      text: AppStrings.AS_A_BUSINESS_PROVIDER,
      backgroundColor: AppColors.THEME_COLOR_DARK_PURPLE,
    );
  }
}
