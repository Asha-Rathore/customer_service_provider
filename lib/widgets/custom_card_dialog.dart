import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class CustomCardDialog extends StatefulWidget {
  final Widget? child;
  const CustomCardDialog({Key? key, this.child}) : super(key: key);
  @override
  _CustomCardDialogState createState() => _CustomCardDialogState();
}

class _CustomCardDialogState extends State<CustomCardDialog>
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppColors.THEME_COLOR_WHITE,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: widget.child,
        ),
      ),
    );
  }
}
