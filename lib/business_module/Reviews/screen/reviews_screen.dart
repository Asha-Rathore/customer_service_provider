import 'package:customer_service_provider_hybrid/main_screen/routing_arguments/main_screen_routing_arguments.dart';
import 'package:customer_service_provider_hybrid/notification/bloc/delete_notification_bloc.dart';
import 'package:customer_service_provider_hybrid/notification/model/notification_model.dart';
import 'package:customer_service_provider_hybrid/notification/provider/notifications_provider.dart';
import 'package:customer_service_provider_hybrid/notification/widget/notification_container.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/model/reviews_model.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/widgets/reviews_widget.dart';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_not_found_text_refresh_indicator_widget.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_refresh_indicator_widget.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../user_module/company_profile/provider/reviews_list_provider.dart';

class BusinessReviewsScreen extends StatefulWidget {
  int? companyId;
  bool? notificationNavigationEnable;

  BusinessReviewsScreen(
      {Key? key, this.companyId, this.notificationNavigationEnable})
      : super(key: key);

  @override
  State<BusinessReviewsScreen> createState() => _BusinessReviewsScreenState();
}

class _BusinessReviewsScreenState extends State<BusinessReviewsScreen> {
  ReviewsListProvider? _reviewsListProvider;

  @override
  void initState() {
    super.initState();
    _getReviewsList();
  }

  Future<void> _getReviewsList() async {
    _reviewsListProvider = context.read<ReviewsListProvider>();
    await _reviewsListProvider?.getReviewsListProviderMethod(
        context: context, companyId: widget.companyId);
  }

  void _initializeProvider() {
    _reviewsListProvider = context.watch<ReviewsListProvider>();
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
        title: AppStrings.REVIEWS,
        onClickLead: () {
          _backMethod();
        },
        child: CustomRefreshIndicatorWidget(
            onRefresh: _getReviewsList,
            child: _reviewsListProvider?.waitingStatus == true
                ? Center(child: AppDialogs.circularProgressWidget())
                : _buildList()),
      ),
    );
  }

  Widget _buildList() {
    return _reviewsListProvider?.waitingStatus == true
        ? AppDialogs.circularProgressWidget()
        : _reviewsListProvider?.getReviewsList != null
            ? _customColumn()
            : CustomDataNotFoundForRefreshIndicatorTextWidget(
                notFoundText: AppStrings.REVIEWS_NOT_FOUND_ERROR);
  }

  Widget _customColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSizeBox(height: 15.h),
        _reviewsListView(reviews: _reviewsListProvider?.getReviewsList?.data),
      ],
    );
  }

  Widget _reviewsListView({List<ReviewsModelData?>? reviews}) {
    print("REVIEWS LENGTH : ${reviews?.length}");
    return Expanded(
      child: ListView.builder(
        itemCount: reviews?.length,
        itemBuilder: ((context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
            child: ReviewsWidget(
              enableSlider: false,
              image: reviews?[index]?.user?.profileImage,
              name: reviews?[index]?.user?.fullName,
              rating: reviews?[index]?.rating.toString(),
              review: reviews?[index]?.feedback,
            ),
          );
        }),
      ),
    );
  }

  void _backMethod() {
    if (widget.notificationNavigationEnable == true) {
      AppNavigation.navigateToRemovingAll(
        context,
        AppRouteName.MAIN_SCREEN_ROUTE,
        arguments: MainScreenRoutingArgument(
          index: 0,
        ),
      );
    } else {
      AppNavigation.navigatorPop(context);
    }
  }
}
