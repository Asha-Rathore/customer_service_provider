import 'package:customer_service_provider_hybrid/user_module/company_profile/bloc/add_review_bloc.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_card_dialog.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_cross_icon.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:customer_service_provider_hybrid/utils/field_validator.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_button.dart';
import '../user_module/company_profile/provider/reviews_list_provider.dart';
import '../utils/app_fonts.dart';
import '../utils/app_navigation.dart';

class RateReviewScreen extends StatefulWidget {
  int? companyId, reviewId, reviewIndex;
  bool? isEdit;
  double? rating;
  String? feedback;

  RateReviewScreen(
      {Key? key,
      this.companyId,
      this.isEdit = false,
      this.rating,
      this.feedback,
      this.reviewId,
      this.reviewIndex})
      : super(key: key);

  @override
  State<RateReviewScreen> createState() => _RateReviewScreenState();
}

class _RateReviewScreenState extends State<RateReviewScreen> {
  AddReviewBloc _addReviewBloc = AddReviewBloc();
  double ratingValue = 0.0;
  final _feedbackFormKey = GlobalKey<FormState>();
  ReviewsListProvider? _reviewsListProvider;
  final _msgCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setReviewdata();
    _reviewsListProvider = context.read<ReviewsListProvider>();
  }

  void _setReviewdata() {
    if (widget.isEdit == true) {
      ratingValue = widget.rating!;
      _msgCtrl.text = widget.feedback!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCardDialog(
      child: Form(
        key: _feedbackFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _titleAndCrossIcon(),
            //  _dialogTitle(),
            SizedBox(height: 10.h),
            _starRatingBar(),
            SizedBox(height: 10.h),
            _descriptionTextField(),
            SizedBox(height: 14.h),
            _submitButton(context),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  Widget _titleAndCrossIcon() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(width: 20.w),
        const Spacer(),
        _title(),
        const Spacer(),
        const CustomCrossIconTap(),
      ],
    );
  }

  Widget _title() {
    return CustomText(
      text: AppStrings.YOUR_FEEDBACK,
      fontColor: AppColors.THEME_COLOR_BLACK,
      // fontweight: FontWeight.w900,
      fontSize: 17.sp,
      textAlign: TextAlign.center,
      fontFamily: AppFonts.Jost_Bold,
    );
  }

  // Widget _dialogTitle() {
  Widget _descriptionTextField() {
    return CustomTextField(
        controller: _msgCtrl,
        hint: AppStrings.SHARE_YOUR_OWN_EXPERIENCE,
        keyboardType: TextInputType.name,
        lines: 8,
        validator: (value) => value?.validateEmpty("Feedback"),
        inputFormatters: [
          LengthLimitingTextInputFormatter(Constants.DESCRIPTION_MAX_LENGTH)
        ]);
  }

  Widget _starRatingBar() {
    return RatingBar(
      initialRating: ratingValue,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 50,
      glow: false,
      ratingWidget: RatingWidget(
        full: const Icon(
          Icons.star_rounded,
          color: AppColors.THEME_COLOR_YELLOW,
        ),
        half: const Icon(
          Icons.star_half_rounded,
          color: AppColors.THEME_COLOR_YELLOW,
        ),
        empty: const Icon(
          Icons.star_rounded,
          color: AppColors.THEME_COLOR_OFF_WHITE,
        ),
      ),
      itemPadding: EdgeInsets.symmetric(horizontal: 1.h),
      onRatingUpdate: (rating) {
        setState(() {
          print(ratingValue);
          ratingValue = rating;
        });
      },
    );
  }

  Widget _submitButton(BuildContext context) {
    return CustomButton(
      text: AppStrings.SUBMIT,
      onTap: () => _feedbackValidationMethod(),
    );
  }

  void _feedbackValidationMethod() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_feedbackFormKey.currentState!.validate()) {
      if (ratingValue != 0.0) {
        _addReviewBloc.addReviewBlocMethod(
          context: context,
          companyId: widget.companyId,
          rating: ratingValue,
          feedBack: _msgCtrl.text,
          isEdit: widget.isEdit,
          reviewId: widget.reviewId,
          reviewIndex: widget.reviewIndex,
          setProgressBar: () {
            AppDialogs.progressAlertDialog(context: context);
          },
        );
      } else {
        AppDialogs.showToast(message: "Please Select Rating");
        print("Please Select Rating");
      }
    }
  }
}
