import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSizeBox extends StatelessWidget {
  double? height;
  CustomSizeBox({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height ?? 10.h);
  }
}
