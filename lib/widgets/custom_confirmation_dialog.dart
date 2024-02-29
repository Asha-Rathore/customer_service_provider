import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';
import '../utils/app_navigation.dart';
import 'custom_text.dart';

class CustomConfirmationDialog extends StatefulWidget {
  final String? title, description, button1Text, button2Text;
  final Function()? onTapYes;
  final Function()? onTapNo;
  final bool? isDescriptionVisible;
  const CustomConfirmationDialog(
      {Key? key,
      this.title,
      this.description,
      this.button1Text,
      this.button2Text,
      this.onTapYes,
      this.onTapNo,
      this.isDescriptionVisible = true})
      : super(key: key);

  @override
  _CustomConfirmationDialogState createState() =>
      _CustomConfirmationDialogState();
}

class _CustomConfirmationDialogState extends State<CustomConfirmationDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: animationController!, curve: Curves.easeIn);
    animationController!.addListener(() {
      setState(() {});
    });
    animationController!.forward();
  }

  @override
  void dispose() {
    animationController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation!,
      child: Dialog(
        insetAnimationCurve: Curves.bounceOut,
        insetAnimationDuration: const Duration(seconds: 2),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /////////--------- DIALOG TITLE ---------/////////
              _dialogTitle(),
              /////////--------- DIALOG DESCRIPTION ---------/////////
              Visibility(
                visible: widget.isDescriptionVisible ?? true,
                child: _dialogDescription(),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /////////--------- NO TAP BUTTON ---------/////////
                    _onTapNoBtn(),
                    SizedBox(width: 10.w),
                    /////////--------- YES TAP BUTTON ---------/////////
                    _onTapYesBtn(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogTitle() {
    return Visibility(
      visible: widget.title != null ? true : false,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: CustomText(
          text: widget.title ?? "",
          fontColor: AppColors.THEME_COLOR_BLACK,
          fontSize: 16.sp,
          // fontweight: FontWeight.bold,
          fontFamily: AppFonts.Jost_Bold,
        ),
      ),
    );
  }

  Widget _dialogDescription() {
    return CustomText(
      text: widget.description ?? "",
      fontColor: AppColors.THEME_COLOR_BLACK,
      fontSize: 16.sp,
      maxLines: 2,
      textAlign: TextAlign.center,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_Bold,
    );
  }

  Widget _onTapNoBtn() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          animationController!.reverse();
          AppNavigation.navigatorPop(context);
          widget.onTapNo!();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: CustomText(
              text: widget.button1Text ?? "",
              fontColor: AppColors.THEME_COLOR_WHITE,
              fontSize: 16.sp,
              // fontweight: FontWeight.bold,
              fontFamily: AppFonts.Jost_Bold,
            ),
          ),
          decoration: const BoxDecoration(
            color: AppColors.THEME_COLOR_BLACK,
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
        ),
      ),
    );
  }

  Widget _onTapYesBtn() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          animationController!.reverse();
          AppNavigation.navigatorPop(context);
          widget.onTapYes!();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: CustomText(
              text: widget.button2Text,
              fontColor: AppColors.THEME_COLOR_WHITE,
              fontSize: 16.sp,
              // fontweight: FontWeight.bold
              fontFamily: AppFonts.Jost_Bold,
            ),
          ),
          decoration: const BoxDecoration(
            color: AppColors.THEME_COLOR_PURPLE,
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
        ),
      ),
    );
  }
}
