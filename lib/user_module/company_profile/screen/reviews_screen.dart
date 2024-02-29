import 'package:customer_service_provider_hybrid/user_module/company_profile/bloc/delete_review_bloc.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/provider/reviews_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../auth/model/user_model.dart';
import '../../../auth/providers/user_provider.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/asset_paths.dart';
import '../../../widgets/custom_error_widget.dart';
import '../model/reviews_model.dart';
import '../widgets/reviews_widget.dart';

class ReviewsScreen extends StatefulWidget {
  int? companyId;

  ReviewsScreen({super.key, this.companyId});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  ReviewsListProvider? _reviewsListProvider;
  DeleteReviewBloc _deleteReviewBloc = DeleteReviewBloc();
  User? _user;
  UserProvider? _userProvider;

  @override
  void initState() {
    _userProvider = context.read<UserProvider>();
    if (_userProvider?.getCurrentUser != null) {
      _user = _userProvider?.getCurrentUser;
    }
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
    return _reviewsListProvider?.waitingStatus == true
        ? Padding(
            padding: EdgeInsets.only(top: 60.h),
            child: AppDialogs.circularProgressWidget(),
          )
        : (_reviewsListProvider?.getReviewsList?.data?.length ?? 0) > 0
            ? _reviewsListView(
                reviews: _reviewsListProvider?.getReviewsList?.data)
            : Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: CustomErrorWidget(
                  errorImagePath: AssetPath.DATA_NOT_FOUND_ICON,
                  errorText: AppStrings.REVIEWS_NOT_FOUND_ERROR,
                  imageSize: 70.h,
                ),
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
              enableSlider:
                  reviews?[index]?.user?.id == _user?.id ? true : false,
              image: reviews?[index]?.user?.profileImage,
              name: reviews?[index]?.user?.fullName,
              rating: reviews?[index]?.rating.toString(),
              review: reviews?[index]?.feedback,
              onTapDelete: () {
                _deleteReviewTap(
                    context: context,
                    reviewId: reviews?[index]?.id,
                    index: index);
              },
              onTapEdit: () {
                AppDialogs().showRatingDialog(
                  context: context,
                  companyId: widget.companyId,
                  isEdit: true,
                  rating: reviews?[index]?.rating,
                  feedback: reviews?[index]?.feedback,
                  reviewId: reviews?[index]?.id,
                  reviewIndex: index
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void _deleteReviewTap(
      {required BuildContext context, int? reviewId, required int index}) {
    AppDialogs().showCustomConfirmationDialog(
      context,
      title: AppStrings.ARE_YOU_SURE,
      description: AppStrings.DO_YOU_WANT_TO_DELETE_REVIEW,
      button1Text: AppStrings.NO,
      button2Text: AppStrings.YES,
      onTapYes: () {
        _deleteReviewMethod(context: context, reviewId: reviewId, index: index);
      },
      onTapNo: () {},
    );
  }

  void _deleteReviewMethod(
      {required BuildContext context, int? reviewId, required int index}) {
    _deleteReviewBloc.deleteReview(
      context: context,
      reviewId: reviewId.toString(),
      setProgressBar: () {
        AppDialogs.progressAlertDialog(context: context);
      },
      onApiSuccess: () {
        _reviewsListProvider?.removeReview(index: index);
      },
    );
  }
}
