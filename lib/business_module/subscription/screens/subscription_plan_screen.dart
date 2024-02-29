import 'package:carousel_slider/carousel_slider.dart';
import 'package:customer_service_provider_hybrid/business_module/service/routing_arguments/service_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/business_module/subscription/bloc/add_subscription_bloc.dart';
import 'package:customer_service_provider_hybrid/business_module/subscription/bloc/subscription_bloc.dart';
import 'package:customer_service_provider_hybrid/business_module/subscription/widgets/slider_container.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_button.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/app_fonts.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/asset_paths.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_error_widget.dart';
import '../model/subscription_model.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  bool? isFromProfile;

  SubscriptionPlanScreen({Key? key, this.isFromProfile}) : super(key: key);

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  // SubscriptionBloc _subscriptionBloc = SubscriptionBloc();
  AddSubscriptionBloc _addSubscriptionBloc = AddSubscriptionBloc();
  int _current = 0;
  List sliders = [0, 1, 2];

  @override
  void initState() {
    super.initState();
    // _getSubscriptionMethod();
  }

  // Future<void> _getSubscriptionMethod() async {
  //   await _subscriptionBloc?.subscriptions(context: context);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetPath.APP_BACKGROUND_IMAGE),
            fit: BoxFit.cover,
          ),
        ),
        child: _scaffoldWidget(context));
  }

  Widget _scaffoldWidget(context) {
    return Scaffold(
      backgroundColor: AppColors.THEME_COLOR_TRANSPARENT,
      appBar: _appBar(context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            _chooseYoutPackageText(),
            SizedBox(height: 30.h),
            _sliderContainer(),
            _sliderDots(),
            // CustomSizeBox(),

            _button(),
            if (widget.isFromProfile == true) ...[
              CustomSizeBox(),
              _skipForNowText(),
            ],
            CustomSizeBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  CustomAppBar _appBar(context) {
    return CustomAppBar(
      leading: AssetPath.BACK_ARROW_ICON,
      title: AppStrings.SUBSCRIPTION_PLAN,
      color: AppColors.THEME_COLOR_WHITE,
      onclickLead: () {
        AppNavigation.navigatorPop(context);
      },
    );
  }

  Widget _chooseYoutPackageText() {
    return CustomText(
      text: AppStrings.CHOOSE_YOUR_PACKAGE,
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontSize: 20.sp,
      fontFamily: AppFonts.PlayfairDisplay_Regular,
    );
  }

  // Widget _subscriptions() {
  //   return StreamBuilder(
  //       stream: _subscriptionBloc.getSubscriptionList(),
  //       builder: (BuildContext context, AsyncSnapshot<SubscriptionModel?>? snapshot) {
  //         if (snapshot?.connectionState == ConnectionState.waiting) {
  //           return Center(child: AppDialogs.circularProgressWidget());
  //         } else {
  //           return snapshot?.data?.data != null ? Expanded(
  //             child: Column(
  //               children: [
  //                 _sliderContainer(snapshot: snapshot),
  //                 _sliderDots(snapshot: snapshot),
  //               ],
  //             ),
  //           ) : CustomErrorWidget(
  //             errorImagePath: AssetPath.DATA_NOT_FOUND_ICON,
  //             errorText: AppStrings.DATA_NOT_FOUND_ERROR,
  //             imageSize: 70.h,
  //           );
  //         }
  //       }
  //   );
  // }

  Widget _sliderContainer({AsyncSnapshot<SubscriptionModel?>? snapshot}) {
    return CarouselSlider.builder(
      itemCount: AppStrings.subscriptionList['SubscriptionList'].length,
      options: CarouselOptions(
        height: 370.h,
        // height: double.nan,
        //  viewportFraction: 1.0,
        // enlargeCenterPage: true,
        // aspectRatio: 10 / 9,
        // viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
      itemBuilder: (BuildContext context, int i, int pageViewIndex) =>
          SliderContainer(
        packageName: AppStrings.subscriptionList['SubscriptionList'][i]
            ['subscriptionPlan'],
        price: AppStrings.subscriptionList['SubscriptionList'][i]['price'],
        duration: AppStrings.subscriptionList['SubscriptionList'][i]
            ['duration'],
        description: AppStrings.subscriptionList['SubscriptionList'][i]
            ['description'],
      ),
    );
  }

  Widget _sliderDots({AsyncSnapshot<SubscriptionModel?>? snapshot}) {
    return Flexible(
      child: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ListView.builder(
            itemCount: AppStrings.subscriptionList['SubscriptionList'].length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: ((context, index) {
              return Container(
                width: 10.0.w,
                height: 10.0.h,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? AppColors.THEME_COLOR_WHITE
                      : AppColors.THEME_COLOR_INDICATOR,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _button() {
    return CustomPadding(
      child: CustomButton(
        onTap: () {
          _addSubscriptionBloc.addSubscriptionBlocMethod(
            context: context,
            isFromProfile: widget.isFromProfile,
            setProgressBar: () {
              AppDialogs.progressAlertDialog(context: context);
            },
          );

        },
        text: AppStrings.SUBSCRIBE,
        textColor: AppColors.THEME_COLOR_PURPLE,
        backgroundColor: AppColors.THEME_COLOR_WHITE,
      ),
    );
  }

  Widget _skipForNowText() {
    return GestureDetector(
      onTap: () {
        AppNavigation.navigateTo(
          context,
          AppRouteName.ADD_OR_EDIT_SERVICE_SCREEN_ROUTE,
          arguments: ServiceScreenRoutingArgument(
              isEditService: false, isFromProfile: true),
        );
      },
      child: CustomText(
        text: AppStrings.SKIP_FOR_NOW,
        fontColor: AppColors.THEME_COLOR_WHITE,
        fontSize: 16.sp,
        fontFamily: AppFonts.Jost_SemiBold,
      ),
    );
  }
}
