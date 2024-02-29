import 'package:customer_service_provider_hybrid/utils/app_fonts.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../widgets/custom_text.dart';

class NumbersWidget extends StatefulWidget {
  String? language, number;
  NumbersWidget({Key? key, this.language, this.number});
  @override
  State<NumbersWidget> createState() => _NumbersWidgetState();
}

class _NumbersWidgetState extends State<NumbersWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10,
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: widget.language,
            fontColor: AppColors.THEME_COLOR_PURPLE,
            fontFamily: AppFonts.Jost_SemiBold,
          ),
          // Spacer(),
          _numbersListViewWidget(),
        ],
      ),
    );
  }

  Widget _numbersListViewWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: AppStrings.ENGLISH_NUMBERS.length,
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return CustomText(
            text: AppStrings.ENGLISH_NUMBERS[index],
            textAlign: TextAlign.right,
            fontColor: AppColors.THEME_COLOR_BLACK,
            fontFamily: AppFonts.Jost_SemiBold,
          );
        },
      ),
    );
  }
}
