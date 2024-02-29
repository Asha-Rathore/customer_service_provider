import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/app_route_name.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_divider.dart';
import '../../../widgets/custom_padding.dart';
import '../../../widgets/custom_sizebox.dart';
import '../../../widgets/custom_text.dart';
import '../widget/card_widget.dart';

class CardDetailScreen extends StatefulWidget {
  const CardDetailScreen({Key? key}) : super(key: key);

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  int _selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return CustomAppTemplate(
      title: AppStrings.CARD_DETAILS,
      child: CustomPadding(
        child: Column(
          children: [
            CustomSizeBox(),
            CustomDivider(),
            CustomSizeBox(height: 15.h),
            _customCardListView(),
            CustomSizeBox(),
            _addNewCardText(),
            const Spacer(),
            _button(),
            CustomSizeBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  Widget _customCardListView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: AppStrings.cardsList['cardsData'].length,
      itemBuilder: ((context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: CustomPaymentCards(
            slidableEnable: true,
            leading: AppStrings.cardsList['cardsData'][index]['image'],
            title: AppStrings.cardsList['cardsData'][index]['name'],
            optionValue: AppStrings.cardsList['cardsData'][index]
                ['optionValue'],
            groupValue: _selectedOption,
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
                print("selected option ${_selectedOption}");
              });
            },
          ),
        );
      }),
    );
  }

  Widget _addNewCardText() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
            context, AppRouteName.ADD_NEW_CARD_SCREEN_ROUTE);
      },
      child: CustomText(
        text: AppStrings.ADD_NEW_CARD,
        fontColor: AppColors.THEME_COLOR_DARK_PURPLE,
        // fontweight: FontWeight.bold,
        fontSize: 17.sp,
        fontFamily: AppFonts.Jost_SemiBold,
      ),
    );
  }

  Widget _button() {
    return CustomPadding(
      child: CustomButton(
        onTap: () {
          if (_selectedOption == 1) {
            AppDialogs.showToast(message: "Please select any payment method.");
          } else {
            AppDialogs().showSuccessDialog(
              context: context,
              successMsg: AppStrings.YOUR_PAYMENT_FOR_SUBSCRIPTION,
              onTap: () {
                AppNavigation.navigateReplacementNamed(
                  context,
                  AppRouteName.MAIN_SCREEN_ROUTE,
                  arguments: MainScreenRoutingArgument(index: 0),
                );
              },
            );
          }
        },
        text: AppStrings.CONTINUE,
      ),
    );
  }
}
