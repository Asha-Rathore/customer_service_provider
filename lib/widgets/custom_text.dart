import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final Color fontColor;
  final TextAlign textAlign;
  final FontWeight fontweight;
  final bool underlined, lineThrough;
  final String? fontFamily;
  final double fontSize, lineSpacing, letterSpacing;
  final int? maxLines;
  final TextOverflow overflow;

  const CustomText({
    this.text,
    this.fontColor = AppColors.THEME_COLOR_WHITE,
    this.fontSize = 15,
    this.textAlign = TextAlign.center,
    this.fontweight = FontWeight.normal,
    this.underlined = false,
    this.lineSpacing = 1,
    this.fontFamily,
    this.letterSpacing = 0,
    this.maxLines,
    this.overflow = TextOverflow.visible,
    this.lineThrough = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : overflow,
      textAlign: textAlign,
      style: TextStyle(
        color: fontColor,
        fontWeight: fontweight,
        height: lineSpacing,
        letterSpacing: letterSpacing,
        fontSize: fontSize,
        fontFamily: fontFamily,
        decoration: underlined
            ? TextDecoration.underline
            : (lineThrough ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    );
  }
}
