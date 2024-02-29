import 'dart:async';
import 'dart:developer';

import 'package:customer_service_provider_hybrid/auth/bloc/resend_otp_bloc.dart';
import 'package:customer_service_provider_hybrid/auth/widgets/custom_auth_template.dart';
import 'package:customer_service_provider_hybrid/auth/widgets/custom_pincode_textfield.dart';
import 'package:customer_service_provider_hybrid/auth/widgets/custom_progress_indicator.dart';
import 'package:customer_service_provider_hybrid/profile/arguments/complete_profile_arguments.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_sizebox.dart';
import '../../widgets/custom_text.dart';
import '../bloc/verify_otp_bloc.dart';
import '../enums/otp_verification_type.dart';

class OtpVerificationScreen extends StatefulWidget {
  bool? isProfile;
  String? emailAddress;
  String? fullName;
  final int? userId;
  final OTPVerificationType? otpType;
  OtpVerificationScreen(
      {this.isProfile,
      Key? key,
      this.emailAddress,
      this.fullName,
      this.userId,
      this.otpType})
      : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _pinCtrl = TextEditingController();
  VerifyOtpBloc _verifyOtpBloc = VerifyOtpBloc();
  ResendCodeBloc _resendCodeBloc = ResendCodeBloc();

  Color? _linkTextColor;
  int count = 59;

  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _linkTextColor = AppColors.THEME_COLOR_LIGHTEST_GREY;
    startTime();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAuthTemplate(
      flex: 10,
      title: AppStrings.VERIFICATION,
      child: _formWidget(context),
      firstBottomText: AppStrings.CODE_DIDNT_RECEIVE,
      secBottomText: AppStrings.RESEND_CODE,
      resizeToAvoidBottomInset: false,
      linkTextColor: _linkTextColor,
      onTap: () {
        if (count == 0) {
          FocusScope.of(context).unfocus();
          reset();
          _resendOTPCode();
        }
      },
      isBottomText: true,
      isOTP: true,
      // otpChild: _timerText(),
      otpChild: _progressIndicator(),
    );
  }

  Widget _formWidget(context) {
    return Column(
      children: [
        _verificationText(context),
        CustomSizeBox(),
        _pinCodeTextField(context),
      ],
    );
  }

  Widget _verificationText(context) {
    return CustomPadding(
      padding: 25.w,
      child: const CustomText(
        text: AppStrings.WE_HAVE_SENT_YOU_EMAIL,
        fontColor: AppColors.THEME_COLOR_GREY,
        // fontweight: FontWeight.w500,
        fontFamily: AppFonts.Jost_Medium,
        lineSpacing: 1.3,
      ),
    );
  }

  Widget _timerText() {
    return CustomText(
      text: "00:${count > 9 ? count : "0$count"} ",
      fontColor: AppColors.THEME_COLOR_WHITE,
      fontweight: FontWeight.w300,
      fontSize: 17.sp,
    );
  }

  Widget _pinCodeTextField(context) {
    return CustomPinCodeTextField(
      controller: _pinCtrl,
      onComplete: (value) {
        if (_pinCtrl.text.length == 0) {
          AppDialogs.showToast(message: AppStrings.OTP_EMPTY_ERROR);
        } else {
          if (_pinCtrl.text.length == 6) {
            _otpVerificationApiMethod(verificationType: widget.otpType);

            print("TYPE : ${widget.otpType}");
          }
        }
      },
    );
  }

  Widget _progressIndicator() {
    return CustomProgressIndicator(count: count);
  }

  void startTime() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (count > 0) {
        setState(() {
          count--;
          // _linkTextColor = AppColors.THEME_COLOR_LIGHTEST_GREY;
        });
      } else {
        _timer.cancel();
        setState(() {
          _linkTextColor = AppColors.THEME_COLOR_WHITE;
        });
      }
    });
  }

  void reset() {
    if (count == 0) {
      _pinCtrl.clear();
      setState(() {
        _timer.cancel();
        count = 59;
        startTime();
        _linkTextColor = AppColors.THEME_COLOR_LIGHTEST_GREY;
      });
    }
  }

  void _otpVerificationApiMethod(
      {required OTPVerificationType? verificationType}) {
    _verifyOtpBloc.verifyOtpBlocMethod(
        context: context,
        otpCode: _pinCtrl.text,
        verificationType: verificationType ?? OTPVerificationType.verification,
        userEmail: widget.emailAddress,
        userId: widget.userId,
        fullName: widget.fullName,
        setProgressBar: () {
          AppDialogs.progressAlertDialog(context: context);
        });
  }

  void _resendOTPCode() {
    _resendCodeBloc.resendCodeBlocMethod(
      context: context,
      userEmail: widget.emailAddress,
      userId: widget.userId,
      setProgressBar: () {
        AppDialogs.progressAlertDialog(context: context);
      },
      otpType: widget.otpType!,
    );
    // }
  }
}
