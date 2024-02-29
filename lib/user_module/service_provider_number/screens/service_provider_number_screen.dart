import 'package:customer_service_provider_hybrid/user_module/service_provider_number/widgets/numbers_widget.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/custom_divider.dart';
import '../../../widgets/custom_sizebox.dart';

class ServiceProviderNumberScreen extends StatelessWidget {
  const ServiceProviderNumberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppTemplate(
      title: AppStrings.SERVICE_PROVIDER_NUMBER,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: CustomPadding(
          child: Column(
            children: [
              CustomSizeBox(height: 15.h),
              _numbersListViewWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numbersListViewWidget() {
    return ListView.builder(
      itemCount: AppStrings.LANGUAGES.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return NumbersWidget(
          language: AppStrings.LANGUAGES[index],
        );
      },
     );
  }
}
