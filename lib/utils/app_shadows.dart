import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppShadow {
  static List<BoxShadow>? boxShadow({double? colorOpacity, Color? color}) {
    return [
      BoxShadow(
        color: color ?? AppColors.THEME_COLOR_BLACK.withOpacity(colorOpacity ?? 0.15), 
        offset: Offset(
          6.0,
          6.0,
        ),
        blurRadius: 10.0,
        spreadRadius: 0,
        // offset: const Offset(1.0, 0),
        // blurRadius: 1,
        // spreadRadius: 1,
      ),
    ];
  }
}
